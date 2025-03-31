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
let temp_var_counter = ref 0

let fresh_variable () =
  let v = "t$" ^ string_of_int !temp_var_counter in
  temp_var_counter := !temp_var_counter + 1;
  v

let label_counter = ref 0

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
let rec convert (a : exp) : tac_instr list * tac_expr =
  match a.exp_kind with
  | AST_Identifier var_name ->
      let temp = fresh_variable () in
      ([ TAC_Assign_Variable (temp, snd var_name) ], TAC_Variable (snd var_name))
  | AST_Integer i ->
      let new_var = fresh_variable () in
      let ival = int_of_string i in
      ([ TAC_Assign_Int (new_var, ival) ], TAC_Variable new_var)
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
      let i1, ta1 = convert a1 in
      let i2, ta2 = convert a2 in
      let new_var = fresh_variable () in
      let to_output = TAC_Assign_Plus (new_var, ta1, ta2) in
      (i1 @ i2 @ [ to_output ], TAC_Variable new_var)
  | AST_Minus (a1, a2) ->
      let i1, ta1 = convert a1 in
      let i2, ta2 = convert a2 in
      let new_var = fresh_variable () in
      let to_output = TAC_Assign_Minus (new_var, ta1, ta2) in
      (i1 @ i2 @ [ to_output ], TAC_Variable new_var)
  | AST_Times (a1, a2) ->
      let i1, ta1 = convert a1 in
      let i2, ta2 = convert a2 in
      let new_var = fresh_variable () in
      let to_output = TAC_Assign_Times (new_var, ta1, ta2) in
      (i1 @ i2 @ [ to_output ], TAC_Variable new_var)
  | AST_Divide (a1, a2) ->
      let i1, ta1 = convert a1 in
      let i2, ta2 = convert a2 in
      let new_var = fresh_variable () in
      let to_output = TAC_Assign_Divide (new_var, ta1, ta2) in
      (i1 @ i2 @ [ to_output ], TAC_Variable new_var)
  | AST_Lt (a1, a2) ->
      let i1, ta1 = convert a1 in
      let i2, ta2 = convert a2 in
      let new_var = fresh_variable () in
      let to_output = TAC_Assign_Lt (new_var, ta1, ta2) in
      (i1 @ i2 @ [ to_output ], TAC_Variable new_var)
  | AST_Le (a1, a2) ->
      let i1, ta1 = convert a1 in
      let i2, ta2 = convert a2 in
      let new_var = fresh_variable () in
      let to_output = TAC_Assign_Le (new_var, ta1, ta2) in
      (i1 @ i2 @ [ to_output ], TAC_Variable new_var)
  | AST_Eq (a1, a2) ->
      let i1, ta1 = convert a1 in
      let i2, ta2 = convert a2 in
      let new_var = fresh_variable () in
      let to_output = TAC_Assign_Eq (new_var, ta1, ta2) in
      (i1 @ i2 @ [ to_output ], TAC_Variable new_var)
  | AST_Not a1 ->
      let i1, ta1 = convert a1 in
      let new_var = fresh_variable () in
      let to_output = TAC_Assign_Not (new_var, ta1) in
      (i1 @ [ to_output ], TAC_Variable new_var)
  | AST_Negate a1 ->
      let i1, ta1 = convert a1 in
      let new_var = fresh_variable () in
      let to_output = TAC_Assign_Negate (new_var, ta1) in
      (i1 @ [ to_output ], TAC_Variable new_var)
  | AST_IsVoid a1 ->
      let i1, ta1 = convert a1 in
      let new_var = fresh_variable () in
      let to_output = TAC_Assign_IsVoid (new_var, ta1) in
      (i1 @ [ to_output ], TAC_Variable new_var)
  | AST_New type_name ->
      let new_var = fresh_variable () in
      ( [ TAC_Assign_New (new_var, TAC_Variable (snd type_name)) ],
        TAC_Variable new_var )
      (* Variable might cause problems*)
  | AST_Assign (var_name, expr) ->
      let instrs, var_expr = convert expr in
      let temp = fresh_variable () in
      let assign_to_var =
        TAC_Assign_Variable (snd var_name, tac_expr_to_string var_expr)
      in
      let assign_to_temp = TAC_Assign_Variable (temp, snd var_name) in
      (instrs @ [ assign_to_var; assign_to_temp ], TAC_Variable temp)
  | AST_Block exprs ->
      (* For blocks, evaluate each expression sequentially and return the last one *)
      let rec process_block exprs =
        match exprs with
        | [] -> ([], TAC_Variable "void") (* Empty block returns void *)
        | [ last ] ->
            convert last (* Last expression determines the block's value *)
        | first :: rest ->
            let first_instrs, _ = convert first in
            let rest_instrs, rest_expr = process_block rest in
            (first_instrs @ rest_instrs, rest_expr)
      in
      process_block exprs
      (*| AST_If (cond, then_branch, else_branch) ->*)
  | AST_While (cond, body) ->
      (* Reset label counter for consistent naming *)
      label_counter := 0;
      let while_start = fresh_label "Main" "main" in
      let while_pred = fresh_label "Main" "main" in
      let while_join = fresh_label "Main" "main" in
      let while_body = fresh_label "Main" "main" in
      let cond_instrs, cond_expr = convert cond in
      let body_instrs, body_expr = convert body in

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
      let obj_instrs, obj_expr = convert obj in

      (* Convert each argument *)
      let args_data = List.map convert args in
      let arg_instrs = List.concat (List.map fst args_data) in
      let arg_exprs = List.map snd args_data in

      let result_var = fresh_variable () in
      let obj_var = tac_expr_to_string obj_expr in

      (* Generate function call instruction *)
      let call_instr =
        TAC_Call
          (result_var, snd method_name, List.map tac_expr_to_string arg_exprs)
      in

      (obj_instrs @ arg_instrs @ [ call_instr ], TAC_Variable result_var)
  | AST_StaticDispatch (obj, type_name, method_name, args) ->
      (* Convert object expression *)
      let obj_instrs, obj_expr = convert obj in

      (* Convert each argument *)
      let args_data = List.map convert args in
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
      convert dispatch_exp
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
            let init_instrs, init_expr = convert init in
            let assign_instr =
              TAC_Assign_Variable (var_name, tac_expr_to_string init_expr)
            in
            process_bindings rest (acc_instrs @ init_instrs @ [ assign_instr ])
      in
      let binding_instrs = process_bindings bindings [] in
      let body_instrs, body_expr = convert body in
      (binding_instrs @ body_instrs, body_expr)
  | x -> failwith ("Unimplemented AST Node: " ^ ast_to_string x)

(* Function to find the main method's body in the Main class *)
let find_main_method (ast : ast) : exp =
  (* Find the Main class *)
  let main_class_opt =
    List.find_opt (fun (name, _, _) -> snd name = "Main") ast
  in
  match main_class_opt with
  | Some (_, _, features) -> (
      (* Find the main method inside the class *)
      let main_method_opt =
        List.find_opt
          (fun f ->
            match f with Method ((_, "main"), _, _, _) -> true | _ -> false)
          features
      in
      match main_method_opt with
      | Some (Method (_, _, _, body)) -> body (* Extract the method body *)
      | _ -> failwith "Error: main method not found in Main class")
  | None -> failwith "Error: Main class not found in AST"

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
  let read_class_map () =
    let tbl = Hashtbl.create 10 in
    let section_name = read () in
    if section_name <> "class_map" then
      failwith ("Expected 'class_map' but got '" ^ section_name ^ "'");

    (* Read number of classes *)
    let num_classes_str = read () in
    let num_classes =
      try int_of_string num_classes_str
      with Failure _ ->
        failwith
          ("Error: Expected integer for number of classes but got '"
         ^ num_classes_str ^ "'")
    in

    for _ = 1 to num_classes do
      let class_name = read () in
      (* Read class name *)

      (* Read number of attributes *)
      let num_attrs_str = read () in
      let num_attrs =
        try int_of_string num_attrs_str
        with Failure _ ->
          failwith
            ("Error: Expected integer for number of attributes but got '"
           ^ num_attrs_str ^ "'")
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
                  failwith
                    ("Unexpected attribute type in class " ^ class_name ^ ": "
                   ^ x))
        else
          []
      in
      (* Store class attributes in the hashtable *)
      Hashtbl.add tbl class_name attributes
    done;

    tbl (* Return the populated hashtable *)
  in

  let read_implementation_map () =
    (* debug reader for parsing debugging  *)
    (*let debug_read msg =*)
    (*  let token = read () in*)
    (*  Printf.printf "[DEBUG] %s: '%s'\n" msg token;*)
    (*  token*)
    (*in*)
    let tbl = Hashtbl.create 10 in
    let section_name = read () in
    (*debug_read "Reading section name" in*)
    if section_name <> "implementation_map" then
      failwith ("Expected 'implementation_map' but got " ^ section_name);

    let num_classes_str = read () in
    (*debug_read "Reading num_classes" in*)
    let num_classes =
      try int_of_string num_classes_str
      with Failure _ ->
        failwith ("Error: Expected integer but got '" ^ num_classes_str ^ "'")
    in

    let class_list = ref [] in
    (* Store class names for sorting *)
    if num_classes > 0 then
      for i = 1 to num_classes do
        let class_name = read () in
        (* Validate that the class name is not a numeric value *)
        if
          String.length class_name > 0
          && class_name.[0] >= '0'
          && class_name.[0] <= '9'
        then
          failwith
            (Printf.sprintf
               "Invalid class name: '%s' (expected non-numeric name)" class_name);

        (*printf "[CLASS] Class Name Read = %s\n" class_name;*)
        class_list := class_name :: !class_list;

        let num_methods_str = read () in
        (*debug_read (Printf.sprintf "Reading num_methods for %s" class_name) *)
        let num_methods =
          try int_of_string num_methods_str
          with Failure _ ->
            failwith
              ("Error: expected int in num methods but got " ^ num_methods_str)
        in

        (*Printf.printf "[DEBUG] Processing %d methods for class %s\n" num_methods class name;*)
        if num_methods > 0 then
          for j = 1 to num_methods do
            let method_name = read () in
            (*debug_read (Printf.sprintf "Reading method #%d (%s)" j class_name)*)
            (*Printf.printf "[DEBUG] Processing method: %s.%s\n" class_name method_name *)
            let num_formals_str = read () in
            let num_formals = int_of_string num_formals_str in

            (*Printf.printf "[DEBUG] Reading %d formal parameters\n" num_formals;*)
            let formals =
              List.init num_formals (fun k -> read ())
              (*debug_read (Printf.sprintf "Reading formal param #%d" (k + 1)))*)
            in

            let defining_class = read () in
            (*debug_read "Reading defining_class" in*)
            (*printf "Defining class: %s\n" defining_class;*)

            let method_body = read_exp () in
            Hashtbl.add tbl (class_name, method_name)
              (formals, defining_class, method_body)
            (*Printf.printf "[DEBUG] Finished processing method %s.%s\n"*)
            (*class_name method_name*)
          done
        (*Printf.printf "[DEBUG] Finished processing class %s\n" class_name*)
      done;

    (*Printf.printf "[DEBUG] Completed reading implementation map\n";*)
    tbl
    (* Return the populated hashtable *)
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
    done
  in

  (* Read class map, stopping at the next section *)
  let _class_map = read_class_map () in
  let impl_map = read_implementation_map () in
  let _parent_map = read_parent_map () in
  let _ast = read_ast () in

  (* TODO*)
  close_in fin;

  Hashtbl.iter
    (fun (class_name, method_name) (formals, defining_class, method_body) ->
      (*convert main body to TAC*)
      let tac_instrs, _ = convert method_body in

      (* Emit the cl-tac program *)
      let tacname = Filename.chop_extension fname ^ ".cl-tac" in
      let fout = open_out tacname in
      List.iter
        (fun tac ->
          match tac with
          | TAC_Comment text -> fprintf fout "comment %s\n" text
          | TAC_Assign (target, expr) ->
              fprintf fout "%s <- %s\n" target (tac_expr_to_string expr)
          | TAC_Assign_Default (target, type_name) ->
              fprintf fout "%s <- default %s\n" target type_name
          | TAC_Assign_Int (x, i) -> fprintf fout "%s <- int %d\n" x i
          | TAC_Assign_String (x, s) -> fprintf fout "%s <- string %s\n" x s
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
          | TAC_Assign_IsVoid (x, y) ->
              fprintf fout "%s <- isvoid %s\n" x (tac_expr_to_string y)
          | TAC_Assign_New (x, y) ->
              fprintf fout "%s <- new %s\n" x (tac_expr_to_string y)
          | TAC_Assign_Bool (x, b) -> fprintf fout "%s <- bool %b\n" x b
          | TAC_Label lbl -> fprintf fout "label %s\n" lbl
          | TAC_Jump lbl -> fprintf fout "jmp %s\n" lbl
          | TAC_ConditionalJump (x, lbl) -> fprintf fout "bt %s %s\n" x lbl
          | TAC_Return x -> fprintf fout "return %s\n" x
          | TAC_Call (result, method_name, args) ->
              fprintf fout "%s <- call %s(%s)\n" result method_name
                (String.concat ", " args)
          | TAC_Assign_StaticCall (result, obj, method_name, args) ->
              fprintf fout "%s <- static_call %s.%s(%s)\n" result obj
                method_name (String.concat ", " args)
          | x ->
              fprintf fout "ERROR: unhandled TAC Instruction: %s\n"
                (tac_instr_to_str x))
        tac_instrs)
    impl_map;


;;

main ()
