(* 
   Steven Alvarado & 
   PA3c2

   Produce "three-address-code" TAC intermediate representation for (some) cool
   programs
*)
open Printf

type static_type = Class of string | SELF_TYPE of string

(* class name -> (attribute list, method list with parameter types) *)
type class_map = (string, string list * (string * string) list) Hashtbl.t

(* class name -> parent class *)
type parent_map = (string, string) Hashtbl.t

type ast = cool_class list
and loc = string (* "really an integer "*)
and id = loc * string
and cool_type = id
and cool_class = id * id option * feature list

and feature =
  | Attribute of id * cool_type * exp option
  | Method of id * formal list * cool_type * exp

and formal = id * cool_type

and exp = {
  loc : loc;
  exp_kind : exp_kind;
  mutable static_type : static_type option; (* can change*)
}

and exp_kind =
  | AST_Integer of string (* "really an integer"*)
  | AST_Assign of id * exp
  | AST_DynamicDispatch of exp * id * exp list
  | AST_StaticDispatch of exp * id * id * exp list
  | AST_SelfDispatch of id * exp list
  | AST_If of exp * exp * exp
  | AST_While of exp * exp
  | AST_Block of exp list
  | AST_New of id
  | AST_IsVoid of exp
  | AST_Plus of exp * exp
  | AST_Minus of exp * exp
  | AST_Times of exp * exp
  | AST_Divide of exp * exp
  | AST_Lt of exp * exp
  | AST_Le of exp * exp
  | AST_Eq of exp * exp
  | AST_Not of exp
  | AST_Negate of exp
  | AST_String of string
  | AST_Identifier of id
  | AST_True
  | AST_False
  | AST_Let of (id * id * exp option) list * exp
  | AST_Case of exp * (id * id * exp) list
  | AST_Internal of string

(* Debug and double check ast definition*)
and tac_expr =
  | TAC_Variable of string (* Named variables and temporaries *)
  | TAC_Constant_Int of int (* Integer constants*)
  | TAC_Constant_Bool of bool (* Boolean constants *)
  | TAC_Constant_String of string
  | TAC_BinaryOp of string * tac_expr * tac_expr
  | TAC_UnaryOp of string * tac_expr
  | TAC_FunctionCall of string * tac_expr list

(*TODO*)

(* (class_name, method_name) -> formals, defining_class, method_body *)
type impl_map =
  (string * string, string list * string list * string * exp) Hashtbl.t

type tac_instr =
  | TAC_Assign_Int of string * int (* temp1 <- int 5*)
  | TAC_Assign_Variable of string * string (* temp1 <- x *)
  | TAC_Assign_Plus of string * tac_expr * tac_expr (* temp3 <- + temp1 temp2 *)
  | TAC_Assign_Minus of string * tac_expr * tac_expr
  | TAC_Assign_Times of string * tac_expr * tac_expr
  | TAC_Assign_Divide of string * tac_expr * tac_expr
  | TAC_Assign_Bool of string * bool (* temp1 <- bool true *)
  | TAC_Assign_String of string * string (* temp1 <- string "hi" *)
  | TAC_Assign_Lt of string * tac_expr * tac_expr
  | TAC_Assign_Le of string * tac_expr * tac_expr
  | TAC_Assign_Not of string * tac_expr
  | TAC_Assign_Negate of string * tac_expr
  | TAC_Assign_IsVoid of string * tac_expr
  | TAC_Assign_New of string * tac_expr
  | TAC_Assign_Call of string * tac_expr
  | TAC_Assign_Eq of string * tac_expr * tac_expr
  | TAC_Binary of string * string * string * string
  | TAC_Label of string (* label L1 *)
  | TAC_Jump of string (* jmp L1 *)
  | TAC_ConditionalJump of string * string (* bt x L2 *)
  | TAC_Return of string
  | TAC_Assign of string * tac_expr
  | TAC_Call of string * string * string list
  | TAC_StaticCall of string * string * string * string list
  | TAC_New of string * string
  | TAC_IsVoid of string * string
  | TAC_Compare of string * string * string * string
  | TAC_Not of string * string
  | TAC_Negate of string * string
  | TAC_Assign_StaticCall of string * string * string * string list
  | TAC_Comment of string
  | TAC_Assign_Default of string * string

let tac_instr_to_str x =
  match x with
  | TAC_Assign_Int _ -> "TAC_Assign_Int"
  | TAC_Assign_Variable _ -> "TAC_Assign_Variable"
  | TAC_Assign_Plus _ -> "TAC_Assign_Plus"
  | TAC_Assign_Minus _ -> "TAC_Assign_Minus"
  | TAC_Assign_Times _ -> "TAC_Assign_Times"
  | TAC_Assign_Divide _ -> "TAC_Assign_Divide"
  | TAC_Assign_Bool _ -> "TAC_Assign_Bool"
  | TAC_Assign_String _ -> "TAC_Assign_String"
  | TAC_Assign_Lt _ -> "TAC_Assign_Lt"
  | TAC_Assign_Le _ -> "TAC_Assign_Le"
  | TAC_Assign_Not _ -> "TAC_Assign_Not"
  | TAC_Assign_Negate _ -> "TAC_Assign_Negate"
  | TAC_Assign_IsVoid _ -> "TAC_Assign_IsVoid"
  | TAC_Assign_New _ -> "TAC_Assign_New"
  | TAC_Assign_Call _ -> "TAC_Assign_Call"
  | TAC_Assign_Eq _ -> "TAC_Assign_Eq"
  | TAC_Binary _ -> "TAC_Binary"
  | TAC_Label _ -> "TAC_Label"
  | TAC_Jump _ -> "TAC_Jump"
  | TAC_ConditionalJump _ -> "TAC_ConditionalJump"
  | TAC_Return _ -> "TAC_Return"
  | TAC_Assign _ -> "TAC_Assignment"
  | TAC_Call _ -> "TAC_Call"
  | TAC_StaticCall _ -> "TAC_StaticCall"
  | TAC_New _ -> "TAC_New"
  | TAC_IsVoid _ -> "TAC_IsVoid"
  | TAC_Compare _ -> "TAC_Compare"
  | TAC_Not _ -> "TAC_Not"
  | TAC_Negate _ -> "TAC_Negate"
  | TAC_Assign_StaticCall _ -> "TAC_Assign_StaticCall"
  | TAC_Comment _ -> "TAC_Comment"
  | TAC_Assign_Default _ -> "TAC_Assign_Default"

let ast_to_string x =
  match x with
  (*| AST_Attribute _ -> " Attirute"*)
  (*| AST_Method _ -> "Method"*)
  | AST_Assign _ -> "Assign"
  | AST_DynamicDispatch _ -> "dynamic_dispatch"
  | AST_StaticDispatch _ -> "static_dispatch"
  | AST_SelfDispatch _ -> "self_dispatch"
  | AST_If _ -> "if"
  | AST_While _ -> "while"
  | AST_Block _ -> "block"
  | AST_New _ -> "new"
  | AST_IsVoid _ -> "isvoid"
  | AST_Plus _ -> "plus"
  | AST_Minus _ -> "minus"
  | AST_Times _ -> "times"
  | AST_Divide _ -> "divide"
  | AST_Lt _ -> "lt"
  | AST_Le _ -> "le"
  | AST_Eq _ -> "eq"
  | AST_Not _ -> "not"
  | AST_Negate _ -> "negate"
  | AST_Integer _ -> "int"
  | AST_String _ -> "string"
  | AST_True -> "true"
  | AST_False -> "false"
  | AST_Let _ -> "let"
  | AST_Case _ -> "case"
  | AST_Identifier _ -> "identifier"
  | AST_Internal _ -> "internal"
(* return x *)
(*TODO*)

let rec tac_expr_to_string expr =
  match expr with
  | TAC_Variable v -> v (* Just return the variable name *)
  | TAC_Constant_Int i -> string_of_int i
  | TAC_Constant_Bool b -> string_of_bool b
  | TAC_Constant_String s -> "\"" ^ s ^ "\""
  | TAC_BinaryOp (op, e1, e2) ->
      Printf.sprintf "(%s %s %s)" (tac_expr_to_string e1) op
        (tac_expr_to_string e2)
  | TAC_UnaryOp (op, e) -> Printf.sprintf "(%s %s)" op (tac_expr_to_string e)
  | TAC_FunctionCall (f, args) ->
      let args_str = String.concat ", " (List.map tac_expr_to_string args) in
      Printf.sprintf "%s(%s)" f args_str

(* count variables*)
let temp_var_counter = ref 1

let fresh_variable () =
  let v = "t$" ^ string_of_int !temp_var_counter in
  temp_var_counter := !temp_var_counter + 1;
  v

let label_counter = ref 1

(* Count labals *)
let fresh_label class_name method_name =
  let l = class_name ^ "_" ^ method_name ^ "_" ^ string_of_int !label_counter in
  label_counter := !label_counter + 1;
  l

(* The traditional approach to converting expressions to three-address 
   code involves a recursive descent traversal of the abstract syntax tree. 
   The recursive descent traversal returns both a three-address code 
   instruction as well as a list of additional instructions that should be 
   prepended to the output.
*)

(* Main logic for parsing ast and converting to tac *)
let rec convert (current_class : string) (current_method : string) (a : exp) :
    tac_instr list * tac_expr =
  match a.exp_kind with
  | AST_Identifier var_name ->
      if snd var_name = "self" then
        ([], TAC_Variable "self")
      else
        let temp = fresh_variable () in
        ([ TAC_Assign_Variable (temp, snd var_name) ], TAC_Variable temp)
  | AST_Integer i ->
      let new_var = fresh_variable () in
      ([ TAC_Assign_Int (new_var, int_of_string i) ], TAC_Variable new_var)
  | AST_String s ->
      let new_var = fresh_variable () in
      ([ TAC_Assign_String (new_var, s) ], TAC_Variable new_var)
  | AST_True ->
      let new_var = fresh_variable () in
      ([ TAC_Assign_Bool (new_var, true) ], TAC_Variable new_var)
  | AST_False ->
      let new_var = fresh_variable () in
      ([ TAC_Assign_Bool (new_var, false) ], TAC_Variable new_var)
  | AST_Plus (a1, a2) ->
      let i1, ta1 = convert current_class current_method a1 in
      let i2, ta2 = convert current_class current_method a2 in
      let new_var = fresh_variable () in
      let to_output = TAC_Assign_Plus (new_var, ta1, ta2) in
      (i1 @ i2 @ [ to_output ], TAC_Variable new_var)
  | AST_Minus (a1, a2) ->
      let i1, ta1 = convert current_class current_method a1 in
      let i2, ta2 = convert current_class current_method a2 in
      let new_var = fresh_variable () in
      let to_output = TAC_Assign_Minus (new_var, ta1, ta2) in
      (i1 @ i2 @ [ to_output ], TAC_Variable new_var)
  | AST_Times (a1, a2) ->
      let i1, ta1 = convert current_class current_method a1 in
      let i2, ta2 = convert current_class current_method a2 in
      let new_var = fresh_variable () in
      let to_output = TAC_Assign_Times (new_var, ta1, ta2) in
      (i1 @ i2 @ [ to_output ], TAC_Variable new_var)
  | AST_Divide (a1, a2) ->
      let i1, ta1 = convert current_class current_method a1 in
      let i2, ta2 = convert current_class current_method a2 in
      let new_var = fresh_variable () in
      let to_output = TAC_Assign_Divide (new_var, ta1, ta2) in
      (i1 @ i2 @ [ to_output ], TAC_Variable new_var)
  | AST_Lt (a1, a2) ->
      let i1, ta1 = convert current_class current_method a1 in
      let i2, ta2 = convert current_class current_method a2 in
      let new_var = fresh_variable () in
      let to_output = TAC_Assign_Lt (new_var, ta1, ta2) in
      (i1 @ i2 @ [ to_output ], TAC_Variable new_var)
  | AST_Le (a1, a2) ->
      let i1, ta1 = convert current_class current_method a1 in
      let i2, ta2 = convert current_class current_method a2 in
      let new_var = fresh_variable () in
      let to_output = TAC_Assign_Le (new_var, ta1, ta2) in
      (i1 @ i2 @ [ to_output ], TAC_Variable new_var)
  | AST_Eq (a1, a2) ->
      let i1, ta1 = convert current_class current_method a1 in
      let i2, ta2 = convert current_class current_method a2 in
      let new_var = fresh_variable () in
      let to_output = TAC_Assign_Eq (new_var, ta1, ta2) in
      (i1 @ i2 @ [ to_output ], TAC_Variable new_var)
  | AST_Not a1 ->
      let i1, ta1 = convert current_class current_method a1 in
      let new_var = fresh_variable () in
      let to_output = TAC_Assign_Not (new_var, ta1) in
      (i1 @ [ to_output ], TAC_Variable new_var)
  | AST_Negate a1 ->
      let i1, ta1 = convert current_class current_method a1 in
      let new_var = fresh_variable () in
      let to_output = TAC_Assign_Negate (new_var, ta1) in
      (i1 @ [ to_output ], TAC_Variable new_var)
  | AST_IsVoid a1 ->
      let i1, ta1 = convert current_class current_method a1 in
      let new_var = fresh_variable () in
      let to_output = TAC_Assign_IsVoid (new_var, ta1) in
      (i1 @ [ to_output ], TAC_Variable new_var)
  | AST_New type_name ->
      let new_var = fresh_variable () in
      ( [ TAC_Assign_New (new_var, TAC_Variable (snd type_name)) ],
        TAC_Variable new_var )
  | AST_If (cond, then_branch, else_branch) ->
      (* Convert condition (assumed to produce its result in a temporary) *)
      let cond_instrs, cond_expr = convert current_class current_method cond in
      (* Compute negation of condition *)
      let not_temp = fresh_variable () in
      let not_instr = TAC_Assign_Not (not_temp, cond_expr) in
      (* Use fixed labels per expected output *)
      let label_then = fresh_label current_class current_method in
      let label_else = fresh_label current_class current_method in
      let label_join = fresh_label current_class current_method in

      (* Convert the then branch *)
      let then_instrs, then_expr =
        convert current_class current_method then_branch
      in
      let then_code =
        [ TAC_Comment "then branch"; TAC_Label label_then ]
        @ then_instrs @ [ TAC_Jump label_join ]
      in

      (* Convert the else branch *)
      let else_instrs, else_expr =
        convert current_class current_method else_branch
      in
      let else_code =
        [ TAC_Comment "else branch"; TAC_Label label_else ]
        @ else_instrs
        @ [
            TAC_Assign_Variable ("t$0", tac_expr_to_string else_expr);
            TAC_Jump label_join;
          ]
      in

      let if_instrs =
        cond_instrs
        @ [
            not_instr;
            TAC_ConditionalJump (not_temp, label_else);
            TAC_ConditionalJump (tac_expr_to_string cond_expr, label_then);
          ]
        @ then_code @ else_code
        @ [ TAC_Comment "if-join"; TAC_Label label_join ]
      in
      (if_instrs, TAC_Variable "t$0")
  | AST_Assign (var_name, expr) ->
      let instrs, expr_val = convert current_class current_method expr in
      let assign_instr =
        TAC_Assign_Variable (snd var_name, tac_expr_to_string expr_val)
      in
      let final_copy = TAC_Assign_Variable ("t$0", snd var_name) in
      (instrs @ [ assign_instr; final_copy ], TAC_Variable "t$0")
  | AST_Block exprs ->
      (* For blocks, evaluate each expression sequentially and return the last one *)
      let rec process_block exprs =
        match exprs with
        | [] -> ([], TAC_Variable "void") (* Empty block returns void *)
        | [ last ] ->
            convert current_class current_method
              last (* Last expression determines the block's value *)
        | first :: rest ->
            let first_instrs, _ = convert current_class current_method first in
            let rest_instrs, rest_expr = process_block rest in
            (first_instrs @ rest_instrs, rest_expr)
      in
      process_block exprs
  (*| AST_If (cond, then_branch, else_branch) ->*)
  | AST_While (cond, body) ->
      (* Reset label counter for consistent naming *)
      label_counter := 0;
      let while_start = fresh_label current_class current_method in
      let while_pred = fresh_label current_class current_method in
      let while_join = fresh_label current_class current_method in
      let while_body = fresh_label current_class current_method in
      let cond_instrs, cond_expr = convert current_class current_method cond in
      let body_instrs, body_expr = convert current_class current_method body in

      (* Create a result variable for the condition evaluation *)
      let cond_var = fresh_variable () in

      (* Not condition for branch to exit *)
      let not_cond_var = fresh_variable () in

      let tac_instrs =
        [
          TAC_Comment "start";
          TAC_Label while_start;
          TAC_Jump while_pred;
          TAC_Comment "while-pred";
          TAC_Label while_pred;
        ]
        @ cond_instrs
        @ [
            (* Store the result of condition in cond_var *)
            TAC_Assign (cond_var, cond_expr);
            TAC_Assign_Not (not_cond_var, TAC_Variable cond_var);
            TAC_ConditionalJump (not_cond_var, while_join);
            TAC_ConditionalJump (cond_var, while_body);
            TAC_Comment "while-join";
            TAC_Label while_join;
            TAC_Assign_Default ("t$0", "Object");
            TAC_Return "t$0";
            TAC_Comment "while-body";
            TAC_Label while_body;
          ]
        @ body_instrs @ [ TAC_Jump while_pred ]
      in

      (* While loops return void in your implementation *)
      let result_var = fresh_variable () in
      (tac_instrs, TAC_Variable result_var)
  | AST_DynamicDispatch (obj, method_name, args) ->
      (* Convert object expression *)
      let obj_instrs, obj_expr = convert current_class current_method obj in

      (* Convert each argument *)
      let args_data =
        List.map (fun arg -> convert current_class current_method arg) args
      in
      let arg_instrs = List.concat (List.map fst args_data) in
      let arg_exprs = List.map snd args_data in

      (* Generate function call instruction, storing result in t$0 *)
      let call_instr =
        TAC_Call ("t$0", snd method_name, List.map tac_expr_to_string arg_exprs)
      in

      (obj_instrs @ arg_instrs @ [ call_instr ], TAC_Variable "t$0")
  | AST_StaticDispatch (obj, type_name, method_name, args) ->
      (* Convert object expression *)
      let obj_instrs, obj_expr = convert current_class current_method obj in

      (* Convert each argument *)
      let args_data =
        List.map (fun arg -> convert current_class current_method arg) args
      in
      let arg_instrs = List.concat (List.map fst args_data) in
      let arg_exprs = List.map snd args_data in

      let result_var = fresh_variable () in
      let obj_var = tac_expr_to_string obj_expr in

      (* Generate static call instruction *)
      let call_instr =
        TAC_Assign_StaticCall
          ( result_var,
            obj_var,
            snd method_name,
            List.map tac_expr_to_string arg_exprs )
      in

      (obj_instrs @ arg_instrs @ [ call_instr ], TAC_Variable result_var)
  | AST_SelfDispatch (method_name, args) ->
      (* Create a proper exp record for "self" identifier *)
      let self_exp =
        {
          loc = "0";
          (* Use appropriate location *)
          exp_kind = AST_Identifier ("0", "self");
          static_type = None;
        }
      in

      (* Create a proper exp record for the dynamic dispatch *)
      let dispatch_exp =
        {
          loc = a.loc;
          exp_kind = AST_DynamicDispatch (self_exp, method_name, args);
          static_type = None;
        }
      in

      (* Now call convert on the properly formed expression *)
      convert current_class current_method dispatch_exp
  | AST_Let (bindings, body) ->
      (* Process each binding in order *)
      let rec process_bindings bindings acc_instrs =
        match bindings with
        | [] -> acc_instrs
        | ((_, var_name), (_, type_name), None) :: rest ->
            (* A binding without initialization *)
            process_bindings rest acc_instrs
        | ((_, var_name), (_, type_name), Some init) :: rest ->
            (* A binding with initialization *)
            let init_instrs, init_expr =
              convert current_class current_method init
            in
            let assign_instr =
              TAC_Assign_Variable (var_name, tac_expr_to_string init_expr)
            in
            process_bindings rest (acc_instrs @ init_instrs @ [ assign_instr ])
      in
      let binding_instrs = process_bindings bindings [] in
      let body_instrs, body_expr = convert current_class current_method body in
      (binding_instrs @ body_instrs, body_expr)
  | AST_Internal s ->
      let new_var = fresh_variable () in
      ([ TAC_Call (new_var, s, []) ], TAC_Variable new_var)
  | x -> failwith ("Unimplemented AST Node: " ^ ast_to_string x)

(* IO methods copied straight from the reference compiler*)
let generate_io_methods () =
  [
    (* IO.out_string implementation *)
    ".globl IO.out_string";
    "IO.out_string:          ## method definition";
    "                        pushq %rbp";
    "                        movq %rsp, %rbp";
    "                        movq 16(%rbp), %r12";
    "                        ## stack room for temporaries: 2";
    "                        movq $16, %r14";
    "                        subq %r14, %rsp";
    "                        ## return address handling";
    "                        ## fp[3] holds argument x (String)";
    "                        ## method body begins";
    "                        movq 24(%rbp), %r14";
    "                        movq 24(%r14), %r13";
    "                        ## guarantee 16-byte alignment before call";
    "\t\t\tandq $0xFFFFFFFFFFFFFFF0, %rsp";
    "\t\t\tmovq %r13, %rdi";
    "\t\t\tcall cooloutstr";
    "                        movq %r12, %r13";
    ".globl IO.out_string.end";
    "IO.out_string.end:      ## method body ends";
    "                        ## return address handling";
    "                        movq %rbp, %rsp";
    "                        popq %rbp";
    "                        ret";
    (* IO.out_int implementation - similar structure *)
    ".globl IO.out_int";
    "IO.out_int:             ## method definition";
    "                        pushq %rbp";
    "                        movq %rsp, %rbp";
    "                        movq 16(%rbp), %r12";
    "                        ## stack room for temporaries: 2";
    "                        movq $16, %r14";
    "                        subq %r14, %rsp";
    "                        ## return address handling";
    "                        ## fp[3] holds argument x (Int)";
    "                        ## method body begins";
    "                        movq 24(%rbp), %r14";
    "                        movq 24(%r14), %r13";
    "                        ## guarantee 16-byte alignment before call";
    "\t\t\tandq $0xFFFFFFFFFFFFFFF0, %rsp";
    "\t\t\tmovq $percent.d, %rdi";
    "\t\t\tmovl %r13d, %eax";
    "\t\t\tcdqe";
    "\t\t\tmovq %rax, %rsi";
    "\t\t\tmovl $0, %eax";
    "\t\t\tcall printf";
    "                        movq %r12, %r13";
    ".globl IO.out_int.end";
    "IO.out_int.end:         ## method body ends";
    "                        ## return address handling";
    "                        movq %rbp, %rsp";
    "                        popq %rbp";
    "                        ret";
  ]


(* Modify generate_vtables to use the ordered list *)
let generate_vtables (class_map : class_map) (impl_map : impl_map)
    (parent_map : parent_map) (class_order : string list)
    (method_order : (string * string) list) =
  (* Use the provided class_order directly *)
  let all_classes = class_order in

  (* Create string number mapping (starting from 1) while preserving order *)
  let string_numbers =
    let counter = ref 0 in
    List.fold_left
      (fun acc cls ->
         incr counter;
         (cls, !counter) :: acc)
      [] all_classes
    |> List.rev |> List.to_seq |> Hashtbl.of_seq
  in

  (* Helper to get all methods for a class, including inherited ones, in proper order *)
  let rec get_all_methods class_name =
    (* Get parent's methods, if any *)
    let parent_methods =
      match Hashtbl.find_opt parent_map class_name with
      | Some parent -> get_all_methods parent
      | None -> []
    in
    (* Get methods defined directly in this class from method_order, excluding "new" *)
    let own_methods =
      List.filter (fun (c, m) -> c = class_name && m <> "new") method_order
      |> List.map snd
    in
    (* Combine parent's methods and then append any new methods defined in this class *)
    parent_methods @ (List.filter (fun m -> not (List.mem m parent_methods)) own_methods)
  in

  (* Generate VTable for a single class *)
  let generate_class_vtable class_name =
    let string_num = Hashtbl.find string_numbers class_name in
    let methods = get_all_methods class_name in

    (* Generate method entries; always prepend "new" as the constructor *)
    let method_entries =
      List.map
        (fun method_name ->
          let label =
            if method_name = "new" then
              class_name ^ "..new"
            else
              (* Lookup in impl_map: if the method is defined in this class, use that definition.
                 Otherwise, recursively check parent classes. *)
              match Hashtbl.find_opt impl_map (class_name, method_name) with
              | Some (_, _, defining_class, _) ->
                  defining_class ^ "." ^ method_name
              | None ->
                  let rec find_definer cls =
                    match Hashtbl.find_opt impl_map (cls, method_name) with
                    | Some (_, _, defining_class, _) -> defining_class
                    | None ->
                        (match Hashtbl.find_opt parent_map cls with
                         | Some parent -> find_definer parent
                         | None -> "Object")  (* fallback *)
                  in
                  let defining_class = find_definer class_name in
                  defining_class ^ "." ^ method_name
          in
          "\t\t\t\t\t\t.quad " ^ label)
        ("new" :: methods)
    in

    (* Build the VTable assembly for this class *)
    [
      "                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;";
      ".globl " ^ class_name ^ "..vtable";
      class_name ^ "..vtable:           ## virtual function table for " ^ class_name;
      "\t\t\t\t\t\t.quad string" ^ string_of_int string_num;
    ]
    @ method_entries
  in

  (* Generate VTables for all classes in the specified order *)
  List.concat_map generate_class_vtable all_classes

(* let generate_vtable class_name methods = *)
(*   [ *)
(*     ".globl " ^ class_name ^ "..vtable"; *)
(*     class_name ^ "..vtable:           ## virtual function table for " *)
(*     ^ class_name; *)
(*     "                        .quad string1"; *)
(*     (* temporary placeholder - replace with actual index *) *)
(*   ] *)
(*   @ List.map *)
(*       (fun method_name -> "                        .quad " ^ method_name) *)
(*       methods *)
(**)
(* Register allocation for TAC variables*)
let reg_map var =
  match var with
  | "t$0" -> "%r13" (* Return value register *)
  | "self" -> "%r12" (* Self object *)
  | var when String.starts_with ~prefix:"t$" var ->
      (* Map other temporaries to registers or stack *)
      (* For simplicity, we'll use stack slots here *)
      let idx = int_of_string (String.sub var 2 (String.length var - 2)) in
      sprintf "-%d(%%rbp)" ((idx * 8) + 8)
  | _ ->
      (* For named variables, store them in the object *)
      (* This would require additional analysis *)
      sprintf "[TODO: named var %s]" var

let translate_tac_to_assembly tac =
  match tac with
  | TAC_Comment text -> [ "                        ## " ^ text ]
  | TAC_Label label -> [ ".globl " ^ label; label ^ ":" ]
  | TAC_Assign_Int (dest, value) ->
      [
        "                        movq $" ^ string_of_int value ^ ", "
        ^ reg_map dest;
      ]
  | TAC_Assign_Plus (dest, op1, op2) ->
      [
        "                        movq "
        ^ reg_map (tac_expr_to_string op1)
        ^ ", %r14";
        "                        addq "
        ^ reg_map (tac_expr_to_string op2)
        ^ ", %r14";
        "                        movq %r14, " ^ reg_map dest;
      ]
  | TAC_Assign_Variable (dest, src) ->
      [ "                        movq " ^ reg_map src ^ ", " ^ reg_map dest ]
  | TAC_Jump label -> [ "                        jmp " ^ label ]
  | TAC_ConditionalJump (cond, label) ->
      [
        "                        cmpq $0, " ^ reg_map cond;
        "                        je " ^ label;
      ]
  | TAC_Call (dest, method_name, args) ->
      [
        "                        pushq %rbp";
        "                        pushq %r12";
        "                        movq $" ^ method_name ^ ", %r14";
        "                        call *%r14";
        "                        popq %r12";
        "                        popq %rbp";
        "                        movq %r13, " ^ reg_map dest;
      ]
  | TAC_Return var ->
      [
        "                        movq " ^ reg_map var ^ ", %r13";
        "                        ## return address handling";
        "                        movq %rbp, %rsp";
        "                        popq %rbp";
        "                        ret";
      ]
(* Add other TAC instructions as needed *)

(* standard prologue and epilogue for each method*)
let generate_method_prologue class_name method_name =
  [
    ".globl " ^ class_name ^ "." ^ method_name;
    class_name ^ "." ^ method_name ^ ":           ## method definition";
    "                        pushq %rbp";
    "                        movq %rsp, %rbp";
    "                        movq 16(%rbp), %r12";
    "                        ## stack room for temporaries: 2";
    "                        movq $16, %r14";
    "                        subq %r14, %rsp";
    "                        ## return address handling";
    "                        ## method body begins";
  ]

let generate_method_epilogue class_name method_name =
  [
    ".globl " ^ class_name ^ "." ^ method_name ^ ".end";
    class_name ^ "." ^ method_name ^ ".end:       ## method body ends";
    "                        ## return address handling";
    "                        movq %rbp, %rsp";
    "                        popq %rbp";
    "                        ret";
  ]

(* Analyze the tac_program to extract classes, methods, etc. *)
let extract_method_info (tac_instrs : tac_instr list) : (string * string) option
    =
  (* Look for labels that match the pattern "ClassName_MethodName_0" *)
  let rec find_method_label instrs =
    match instrs with
    | [] -> None
    | TAC_Label label :: _ -> (
        (* Check if label follows the expected format *)
        try
          let parts = String.split_on_char '_' label in
          if List.length parts >= 3 then
            Some (List.nth parts 0, List.nth parts 1)
          else
            None
        with _ -> None)
    | _ :: rest -> find_method_label rest
  in
  find_method_label tac_instrs

(* Extract basic blocks from TAC instructions *)
let generate_basic_blocks (tac_instructions : tac_instr list) :
    (string * tac_instr list) list =
  (* Find leader instructions that start basic blocks *)
  let rec find_leaders (instrs : tac_instr list) (leaders : int list)
      (idx : int) =
    match instrs with
    | [] -> leaders
    | TAC_Label _ :: rest -> find_leaders rest (idx :: leaders) (idx + 1)
    | TAC_Jump _ :: rest ->
        if rest <> [] then
          find_leaders rest ((idx + 1) :: leaders) (idx + 1)
        else
          find_leaders rest leaders (idx + 1)
    | TAC_ConditionalJump _ :: rest ->
        if rest <> [] then
          find_leaders rest ((idx + 1) :: leaders) (idx + 1)
        else
          find_leaders rest leaders (idx + 1)
    | TAC_Return _ :: rest ->
        if rest <> [] then
          find_leaders rest ((idx + 1) :: leaders) (idx + 1)
        else
          find_leaders rest leaders (idx + 1)
    | _ :: rest -> find_leaders rest leaders (idx + 1)
  in

  (* Always include the first instruction as a leader *)
  let leader_positions = 0 :: find_leaders tac_instructions [] 0 in
  let sorted_leaders = List.sort compare leader_positions in

  (* Create basic blocks from leader positions *)
  let rec create_blocks leaders blocks =
    match leaders with
    | [] -> List.rev blocks
    | [ last ] ->
        let block_instrs =
          List.filteri
            (fun i _ -> i >= last && i < List.length tac_instructions)
            tac_instructions
        in
        let block_id = "BB" ^ string_of_int last in
        create_blocks [] ((block_id, block_instrs) :: blocks)
    | leader :: next_leader :: rest ->
        let block_instrs =
          List.filteri
            (fun i instr -> i >= leader && i < next_leader)
            tac_instructions
        in
        let block_id = "BB" ^ string_of_int leader in
        create_blocks (next_leader :: rest) ((block_id, block_instrs) :: blocks)
  in

  create_blocks sorted_leaders []

(* Generate data section with string constants and other data *)
let generate_data_section () : string list =
  [
    ".data";
    "string1: .asciz \"\"";
    "percent.d: .asciz \"%d\"";
    "percent.s: .asciz \"%s\"";
    ".text";
    ".globl main";
  ]

(* Extract classes and methods from the TAC program *)
let extract_classes (tac_program : tac_instr list) : (string * string list) list
    =
  (* First, extract class and method names from TAC labels *)
  let classes = ref [] in
  let class_methods = Hashtbl.create 10 in

  List.iter
    (fun instr ->
      match instr with
      | TAC_Label label -> (
          try
            let parts = String.split_on_char '_' label in
            if List.length parts >= 3 then (
              let class_name = List.nth parts 0 in
              let method_name = List.nth parts 1 in

              (* Add class to list if not already present *)
              if not (List.mem class_name !classes) then
                classes := class_name :: !classes;

              (* Add method to class_methods *)
              let methods =
                try Hashtbl.find class_methods class_name with Not_found -> []
              in
              if not (List.mem method_name methods) then
                Hashtbl.replace class_methods class_name (method_name :: methods))
          with _ -> ())
      | _ -> ())
    tac_program;

  (* Convert hashtable to list *)
  List.map
    (fun class_name -> (class_name, Hashtbl.find class_methods class_name))
    !classes

(* Function to write the assembly file *)
let write_assembly_file (filename : string) (assembly : string list) : unit =
  let outfile = open_out filename in
  List.iter (fun line -> output_string outfile (line ^ "\n")) assembly;
  close_out outfile

let main () =
  let fname = Sys.argv.(1) in
  let fin = open_in fname in

  let read () = input_line fin in
  (* simalar to python range(k)
           reads up to element*)
  let rec range k =
    if k <= 0 then
      []
    else
      k :: range (k - 1)
  in

  let read_list worker =
    let k = int_of_string (read ()) in
    let lst = range k in
    List.map (fun _ -> worker ()) lst
  in

  (* Many mutually recursive procedures to read in the cl-ast file *)
  let rec read_ast () = read_list read_cool_class
  and read_id () =
    let loc = read () in
    let name = read () in
    (loc, name)
  and read_cool_class () =
    let cname = read_id () in
    let inherits =
      match read () with
      | "no_inherits" -> None
      | "inherits" ->
          let super = read_id () in
          Some super
      | x -> failwith ("cannot happen: " ^ x)
    in

    let features = read_list read_feature in
    (cname, inherits, features)
  and read_feature () =
    match read () with
    | "attribute_no_init" ->
        let fname = read_id () in
        let ftype = read_id () in
        Attribute (fname, ftype, None)
    | "attribute_init" ->
        let fname = read_id () in
        let ftype = read_id () in
        let finit = read_exp () in
        Attribute (fname, ftype, Some finit)
    | "method" ->
        let mname = read_id () in
        let formals = read_list read_formal in
        let mtype = read_id () in
        let mbody = read_exp () in
        Method (mname, formals, mtype, mbody)
    | x -> failwith ("cannot happen: " ^ x)
  and read_formal () =
    let fname = read_id () in
    let ftype = read_id () in
    (fname, ftype)
  and read_exp () =
    let eloc = read () in
    (*printf "eloc: %s\n" eloc;*)
    let etype_str = read () in
    (*printf "etype: %s\n" etype_str;*)
    let etype =
      if etype_str = "SELF_TYPE" then
        Some (SELF_TYPE "")
      else
        Some (Class etype_str)
    in
    let ekind_str = read () in
    (*printf "[DEBUG] Read ekind: '%s'\n" ekind_str;*)
    let ekind =
      match ekind_str with
      | "internal" ->
          let internal_method = read () in
          (*printf "Internal method: %s\n" internal_method;*)
          AST_Internal internal_method
      | "assign" ->
          let var = read_id () in
          let rhs = read_exp () in
          AST_Assign (var, rhs)
      | "dynamic_dispatch" ->
          let e = read_exp () in
          let mname = read_id () in
          let args = read_list read_exp in
          AST_DynamicDispatch (e, mname, args)
      | "static_dispatch" ->
          let e = read_exp () in
          let tname = read_id () in
          let mname = read_id () in
          let args = read_list read_exp in
          AST_StaticDispatch (e, tname, mname, args)
      | "self_dispatch" ->
          let mname = read_id () in
          let args = read_list read_exp in
          AST_SelfDispatch (mname, args)
      | "if" ->
          let predicate = read_exp () in
          let then_branch = read_exp () in
          let else_branch = read_exp () in
          AST_If (predicate, then_branch, else_branch)
      | "while" ->
          let predicate = read_exp () in
          let body = read_exp () in
          AST_While (predicate, body)
      | "block" ->
          let body = read_list read_exp in
          AST_Block body
      | "new" ->
          let cname = read_id () in
          AST_New cname
      | "isvoid" ->
          let e = read_exp () in
          AST_IsVoid e
      | "plus" ->
          let x = read_exp () in
          let y = read_exp () in
          AST_Plus (x, y)
      | "minus" ->
          let x = read_exp () in
          let y = read_exp () in
          AST_Minus (x, y)
      | "times" ->
          let x = read_exp () in
          let y = read_exp () in
          AST_Times (x, y)
      | "divide" ->
          let x = read_exp () in
          let y = read_exp () in
          AST_Divide (x, y)
      | "lt" ->
          let x = read_exp () in
          let y = read_exp () in
          AST_Lt (x, y)
      | "le" ->
          let x = read_exp () in
          let y = read_exp () in
          AST_Le (x, y)
      | "eq" ->
          let x = read_exp () in
          let y = read_exp () in
          AST_Eq (x, y)
      | "not" ->
          let x = read_exp () in
          AST_Not x
      | "negate" ->
          let x = read_exp () in
          AST_Negate x
      | "integer" ->
          let ival = read () in
          AST_Integer ival
      | "string" ->
          let sval = read () in
          AST_String sval
      | "identifier" ->
          let variable = read_id () in
          AST_Identifier variable
      | "true" -> AST_True
      | "false" -> AST_False
      | "let" ->
          let bindings =
            read_list (fun () ->
                match read () with
                | "let_binding_no_init" ->
                    let var = read_id () in
                    let var_type = read_id () in
                    (var, var_type, None)
                | "let_binding_init" ->
                    let var = read_id () in
                    let var_type = read_id () in
                    let value = read_exp () in
                    (var, var_type, Some value)
                | x -> failwith ("Unexpected binding type: " ^ x))
          in
          let body = read_exp () in
          AST_Let (bindings, body)
      | "case" ->
          let expr = read_exp () in
          let case_elements =
            read_list (fun () ->
                let var = read_id () in
                let var_type = read_id () in
                let body = read_exp () in
                (var, var_type, body))
          in
          AST_Case (expr, case_elements)
      | x ->
          (* Add debugging to see what we're trying to parse *)
          Printf.fprintf stderr "Unhandled expression kind: '%s'\n" x;
          (* Read the next few lines to see what's coming next for debugging *)
          let next1 = try read () with End_of_file -> "EOF" in
          let next2 = try read () with End_of_file -> "EOF" in
          let next3 = try read () with End_of_file -> "EOF" in
          let next4 = try read () with End_of_file -> "EOF" in
          let next5 = try read () with End_of_file -> "EOF" in
          let next6 = try read () with End_of_file -> "EOF" in
          let next7 = try read () with End_of_file -> "EOF" in
          let next8 = try read () with End_of_file -> "EOF" in

          Printf.fprintf stderr
            "Next tokens: '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s'\n"
            next1 next2 next3 next4 next5 next6 next7 next8;
          failwith (sprintf "Expression kind unhandled: '%s'" x)
    in
    { loc = eloc; exp_kind = ekind; static_type = etype }
  in
 (* class name -> (attribute list, method list with parameter types) *)

let read_class_map () =
  let tbl = Hashtbl.create 10 in
  let class_order = ref [] in  (* Track class declaration order *)
  let section_name = read () in
  if section_name <> "class_map" then
    failwith ("Expected 'class_map' but got '" ^ section_name ^ "'");
  (* Read number of classes *)
  let num_classes_str = read () in
  let num_classes =
    try int_of_string num_classes_str
    with Failure _ ->
      failwith ("Error: Expected integer for number of classes but got '" ^ num_classes_str ^ "'")
  in
  for _ = 1 to num_classes do
    let class_name = read () in
    (* Add to our ordered list *)
    class_order := !class_order @ [class_name];
    (* Read number of attributes *)
    let num_attrs_str = read () in
    let num_attrs =
      try int_of_string num_attrs_str
      with Failure _ ->
        failwith ("Error: Expected integer for number of attributes but got '" ^ num_attrs_str ^ "'")
    in
    (* Read attributes only if num_attrs > 0 *)
    let attributes =
      if num_attrs > 0 then
        List.init num_attrs (fun _ ->
            match read () with
            | "no_initializer" ->
                let attr_name = read () in
                let attr_type = read () in
                `NoInitializer (attr_name, attr_type)
            | "initializer" ->
                let attr_name = read () in
                let attr_type = read () in
                let init_expr = read_exp () in
                (* Read the initializer expression *)
                `Initializer (attr_name, attr_type, init_expr)
            | x ->
                failwith ("Unexpected attribute type in class " ^ class_name ^ ": " ^ x))
      else
        []
    in
    (* Extract just the attribute names from the variants *)
    let attribute_names =
      List.map (function
          | `NoInitializer (name, _) -> name
          | `Initializer (name, _, _) -> name
      ) attributes
    in
    (* Store class attributes as a tuple: (attribute names, empty method list) *)
    Hashtbl.add tbl class_name (attribute_names, [])
  done;
  (tbl, !class_order)  (* Return both the hashtable and the ordered list *)
    in
(* Global reference to record the order of methods as (class, method) pairs *)
let method_order = ref []  (* Initially empty *)
    in
(* Returns a pair: (impl_map, method_order) where method_order is a list of (class_name, method_name) in read order *)
let read_implementation_map () =
  let tbl = Hashtbl.create 10 in
  let method_order = ref [] in
  let section_name = read () in
  if section_name <> "implementation_map" then
    failwith ("Expected 'implementation_map' but got " ^ section_name);

  let num_classes_str = read () in
  let num_classes =
    try int_of_string num_classes_str
    with Failure _ ->
      failwith ("Error: Expected integer but got '" ^ num_classes_str ^ "'")
  in

  if num_classes > 0 then
    for i = 1 to num_classes do
      let class_name = read () in
      if String.length class_name > 0 &&
         class_name.[0] >= '0' && class_name.[0] <= '9' then
        failwith (Printf.sprintf "Invalid class name: '%s' (expected non-numeric name)" class_name);

      let num_methods_str = read () in
      let num_methods =
        try int_of_string num_methods_str
        with Failure _ ->
          failwith ("Error: expected int in num methods but got " ^ num_methods_str)
      in

      if num_methods > 0 then
        for j = 1 to num_methods do
          let method_name = read () in
          let num_formals_str = read () in
          let num_formals = int_of_string num_formals_str in

          (* Read formal parameter names *)
          let formals = List.init num_formals (fun _ -> read ()) in
          (* Supply default formal types (empty strings) *)
          let formal_types = List.init num_formals (fun _ -> "") in

          let defining_class = read () in
          let method_body = read_exp () in

          Hashtbl.add tbl (class_name, method_name)
            (formals, formal_types, defining_class, method_body);
          (* Record the method in the order it was read *)
          method_order := !method_order @ [(class_name, method_name)]
        done
    done;
  (tbl, !method_order)
 in
  (* Return the populated hashtable *)
  let read_parent_map () =
    let tbl = Hashtbl.create 10 in
    let section_name = read () in
    if section_name <> "parent_map" then
      failwith ("Expected 'parent_map' but got " ^ section_name);

    let num_relations_str = read () in
    let num_relations =
      try int_of_string num_relations_str
      with Failure _ ->
        failwith ("Error: expected int but got" ^ num_relations_str)
    in
    let class_list = ref [] in
    (* Store class names for sorting *)
    for _ = 1 to num_relations do
      let child_class = read () in
      let parent_class = read () in

      (* Store relationship in parent map *)
      Hashtbl.add tbl child_class parent_class;

      (* Collect class names for sorting *)
      class_list := child_class :: !class_list
    done;
    tbl
  in

  (* Read class map, stopping at the next section *)
  let (class_map, class_order) = read_class_map () in
  let (impl_map, method_order) = read_implementation_map () in
  let parent_map = read_parent_map () in
  let ast = read_ast () in

  close_in fin;
  let generate_tac_for_method (class_id : id) (feature : feature) =
    match feature with
    | Method (method_id, formals, mtype, body) ->
        (* Reset counters for variable naming consistency *)
        (* temp_var_counter := 0; *)
        (* label_counter := 0; *)
        (* (**) *)
        let class_name = snd class_id in
        let method_name = snd method_id in

        (* Generate TAC for the method's body with the proper context *)
        let tac_instrs, result_expr = convert class_name method_name body in

        (* Create preamble *)
        let preamble =
          [
            TAC_Comment "start";
            TAC_Label (class_name ^ "_" ^ method_name ^ "_0");
          ]
        in

        (* Handle the epilogue correctly based on the last instruction *)
        let final_instrs =
          match List.rev tac_instrs with
          | TAC_Call ("t$0", _, _) :: _ ->
              (* If last instruction is a call that stores result in t$0, just append return *)
              tac_instrs @ [ TAC_Return "t$0" ]
          | _ ->
              (* Otherwise, ensure result is in t$0 and then return it *)
              let result_var = tac_expr_to_string result_expr in
              if result_var = "t$0" then
                tac_instrs @ [ TAC_Return "t$0" ]
              else
                tac_instrs
                @ [ TAC_Assign_Variable ("t$0", result_var); TAC_Return "t$0" ]
        in

        preamble @ final_instrs
    | _ -> []
  in
  let tac_program =
    List.fold_left
      (fun acc (class_id, _inherits, features) ->
        List.fold_left
          (fun acc feature ->
            match feature with
            | Method _ ->
                let method_tac = generate_tac_for_method class_id feature in
                acc @ method_tac
            | _ -> acc)
          acc features)
      [] ast
  in

  let tacname = Filename.chop_extension fname ^ ".cl-tac" in
  let fout = open_out tacname in

  (* Emit the cl-tac program *)
  List.iter
    (fun tac ->
      match tac with
      | TAC_Comment text -> fprintf fout "comment %s\n" text
      | TAC_Assign (target, expr) ->
          fprintf fout "%s <- %s\n" target (tac_expr_to_string expr)
      | TAC_Assign_Default (target, type_name) ->
          fprintf fout "%s <- default %s\n" target type_name
      | TAC_Assign_Int (x, i) -> fprintf fout "%s <- int %d\n" x i
      | TAC_Assign_String (x, s) -> fprintf fout "%s <- string\n%s\n" x s
      | TAC_Assign_Variable (x, y) -> fprintf fout "%s <- %s\n" x y
      | TAC_Assign_Plus (x, y, z) ->
          let op1 = tac_expr_to_string y in
          let op2 = tac_expr_to_string z in
          fprintf fout "%s <- + %s %s\n" x op1 op2
      | TAC_Assign_Minus (x, y, z) ->
          fprintf fout "%s <- - %s %s\n" x (tac_expr_to_string y)
            (tac_expr_to_string z)
      | TAC_Assign_Times (x, y, z) ->
          fprintf fout "%s <- * %s %s\n" x (tac_expr_to_string y)
            (tac_expr_to_string z)
      | TAC_Assign_Divide (x, y, z) ->
          fprintf fout "%s <- / %s %s\n" x (tac_expr_to_string y)
            (tac_expr_to_string z)
      | TAC_Assign_Lt (x, y, z) ->
          fprintf fout "%s <- < %s %s\n" x (tac_expr_to_string y)
            (tac_expr_to_string z)
      | TAC_Assign_Le (x, y, z) ->
          fprintf fout "%s <- <= %s %s\n" x (tac_expr_to_string y)
            (tac_expr_to_string z)
      | TAC_Assign_Eq (x, y, z) ->
          fprintf fout "%s <- = %s %s\n" x (tac_expr_to_string y)
            (tac_expr_to_string z)
      | TAC_Assign_Not (x, y) ->
          fprintf fout "%s <- not %s\n" x (tac_expr_to_string y)
      | TAC_Assign_Negate (x, y) ->
          fprintf fout "%s <- ~ %s\n" x (tac_expr_to_string y)
      (* | TAC_Assign_IsVoid (x, y) -> *)
      (*     fprintf fout "%s <- isvoid %s\n" x (tac_expr_to_string y) *)
      | TAC_Assign_New (x, y) ->
          fprintf fout "%s <- new %s\n" x (tac_expr_to_string y)
      | TAC_Assign_Bool (x, b) -> fprintf fout "%s <- bool %b\n" x b
      | TAC_Label lbl -> fprintf fout "label %s\n" lbl
      | TAC_Jump lbl -> fprintf fout "jmp %s\n" lbl
      | TAC_ConditionalJump (x, lbl) -> fprintf fout "bt %s %s\n" x lbl
      | TAC_Return x -> fprintf fout "return %s\n" x
      | TAC_Call (result, method_name, args) ->
          fprintf fout "%s <- call %s %s\n" result method_name
            (String.concat ", " args)
      | TAC_Assign_StaticCall (result, obj, method_name, args) ->
          fprintf fout "%s <- static_call %s.%s(%s)\n" result obj method_name
            (String.concat ", " args)
      | x ->
          fprintf fout "ERROR: unhandled TAC Instruction: %s\n"
            (tac_instr_to_str x))
    tac_program;

  close_out fout;
  (* Main assembly generation function *)
  let generate_assembly (tac_program : tac_instr list) (class_map : class_map)
      (impl_map : impl_map) (parent_map : parent_map) : string list =
    (* Read the class information from your input files *)

    (* Generate standard vtables first *)
    let vtables = generate_vtables class_map impl_map parent_map class_order method_order in

    (* Extract class information from TAC program (for method implementations) *)
    let classes = extract_classes tac_program in

    (* Generate data section (string constants, etc.) *)
    let data_section = generate_data_section () in

    (* Generate method implementations *)
    let methods_assembly =
      List.map
        (fun tac_instr ->
          match extract_method_info [ tac_instr ] with
          | Some (class_name, method_name) ->
              (* Generate basic blocks for this method *)
              let method_tac =
                List.filter
                  (fun instr ->
                    match instr with
                    | TAC_Label label ->
                        String.starts_with label (class_name ^ "_" ^ method_name)
                    | _ -> false)
                  tac_program
              in

              let basic_blocks = generate_basic_blocks method_tac in

              (* Generate method prologue *)
              let prologue = generate_method_prologue class_name method_name in

              (* Generate code for each basic block *)
              let blocks_assembly =
                List.concat_map
                  (fun (block_id, block_instrs) ->
                    [ block_id ^ ":" ]
                    @ List.concat_map translate_tac_to_assembly block_instrs)
                  basic_blocks
              in

              (* Generate method epilogue *)
              let epilogue = generate_method_epilogue class_name method_name in

              prologue @ blocks_assembly @ epilogue
          | None -> [])
        tac_program
      |> List.concat
    in

    (* Generate IO methods (if needed) *)
    let io_methods = generate_io_methods () in

    (* Combine everything with proper ordering *)
    vtables @ data_section @ methods_assembly @ io_methods
  in

  let assembly = generate_assembly tac_program class_map impl_map parent_map in
  let asmname = Filename.chop_extension fname ^ ".s" in
  write_assembly_file asmname assembly;
  (* Print completion message *)
  Printf.printf "Generated TAC file: %s\n" tacname;
  Printf.printf "Generated assembly file: %s\n" asmname
;;

main ()
