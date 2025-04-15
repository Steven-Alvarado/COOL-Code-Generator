(* 
   Steven Alvarado & 
   PA3c2

   Produce "three-address-code" TAC intermediate representation for (some) cool
   programs
*)

open Printf

(* Global structure to track explicitly initialized fields *)
let explicitly_initialized_fields = Hashtbl.create 50

(* Helper function to record an explicitly initialized field *)
let record_explicit_initializer class_name field_name =
  let fields = 
    try Hashtbl.find explicitly_initialized_fields class_name
    with Not_found -> Hashtbl.create 10
  in
  Hashtbl.replace fields field_name true;
  Hashtbl.replace explicitly_initialized_fields class_name fields

(* Helper function to check if a field was explicitly initialized *)
let is_explicitly_initialized class_name field_name =
  try 
    let fields = Hashtbl.find explicitly_initialized_fields class_name in
    Hashtbl.mem fields field_name
  with Not_found -> false

type static_type = Class of string | SELF_TYPE of string

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
  | AST_Integer of string
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

and tac_expr =
  | TAC_Variable of string (* Named variables and temporaries *)
  | TAC_Int of int (* Integer constants*)
  | TAC_Bool of bool (* Boolean constants *)
  | TAC_String of string
  | TAC_BinaryOp of string * tac_expr * tac_expr
  | TAC_UnaryOp of string * tac_expr
  | TAC_FunctionCall of string * tac_expr list

(* (class_name, method_name) -> formals, defining_class, method_body *)
type impl_map =
  (string * string, string list * string list * string * exp) Hashtbl.t

(* class name -> (attribute name, type, expr option for initilize  *)
type class_map =
  ( string,
    (string * string * exp option) list * (string * string) list )
  Hashtbl.t

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
  | TAC_Comment of string
  | TAC_Assign_Default of string * string

let rec tac_expr_to_string expr =
  match expr with
  | TAC_Variable v -> v (* Just return the variable name *)
  | TAC_Int i -> string_of_int i
  | TAC_Bool b -> string_of_bool b
  | TAC_String s -> "\"" ^ s ^ "\""
  | TAC_BinaryOp (op, e1, e2) ->
      Printf.sprintf "(%s %s %s)" (tac_expr_to_string e1) op
        (tac_expr_to_string e2)
  | TAC_UnaryOp (op, e) -> Printf.sprintf "(%s %s)" op (tac_expr_to_string e)
  | TAC_FunctionCall (f, args) ->
      let args_str = String.concat ", " (List.map tac_expr_to_string args) in
      Printf.sprintf "%s(%s)" f args_str

let tac_instr_to_str x =
  match x with
  | TAC_Comment text -> "comment " ^ text ^ "\n"
  | TAC_Assign (target, expr) ->
      target ^ " <- " ^ tac_expr_to_string expr ^ "\n"
  | TAC_Assign_Default (target, type_name) ->
      target ^ " <- default " ^ type_name ^ "\n"
  | TAC_Assign_Int (x, i) -> Printf.sprintf "%s <- int %d\n" x i
  | TAC_Assign_String (x, s) -> x ^ " <- string\n" ^ s ^ "\n"
  | TAC_Assign_Variable (x, y) -> x ^ " <- " ^ y ^ "\n"
  | TAC_Assign_Plus (x, y, z) ->
      let op1 = tac_expr_to_string y in
      let op2 = tac_expr_to_string z in
      Printf.sprintf "%s <- + %s %s\n" x op1 op2
  | TAC_Assign_Minus (x, y, z) ->
      Printf.sprintf "%s <- - %s %s\n" x (tac_expr_to_string y)
        (tac_expr_to_string z)
  | TAC_Assign_Times (x, y, z) ->
      Printf.sprintf "%s <- * %s %s\n" x (tac_expr_to_string y)
        (tac_expr_to_string z)
  | TAC_Assign_Divide (x, y, z) ->
      Printf.sprintf "%s <- / %s %s\n" x (tac_expr_to_string y)
        (tac_expr_to_string z)
  | TAC_Assign_Lt (x, y, z) ->
      Printf.sprintf "%s <- < %s %s\n" x (tac_expr_to_string y)
        (tac_expr_to_string z)
  | TAC_Assign_Le (x, y, z) ->
      Printf.sprintf "%s <- <= %s %s\n" x (tac_expr_to_string y)
        (tac_expr_to_string z)
  | TAC_Assign_Eq (x, y, z) ->
      Printf.sprintf "%s <- = %s %s\n" x (tac_expr_to_string y)
        (tac_expr_to_string z)
  | TAC_Assign_Not (x, y) ->
      Printf.sprintf "%s <- not %s\n" x (tac_expr_to_string y)
  | TAC_Assign_Negate (x, y) ->
      Printf.sprintf "%s <- ~ %s\n" x (tac_expr_to_string y)
  | TAC_Assign_New (x, y) ->
      Printf.sprintf "%s <- new %s\n" x (tac_expr_to_string y)
  | TAC_Assign_Bool (x, b) -> Printf.sprintf "%s <- bool %b\n" x b
  | TAC_Label lbl -> "label " ^ lbl ^ "\n"
  | TAC_Jump lbl -> "jmp " ^ lbl ^ "\n"
  | TAC_ConditionalJump (x, lbl) -> "bt " ^ x ^ " " ^ lbl ^ "\n"
  | TAC_Return x -> "return " ^ x ^ "\n"
  | TAC_Call (result, method_name, args) ->
      result ^ " <- call " ^ method_name ^ " " ^ String.concat ", " args ^ "\n"
  | _ -> "ERROR: unhandled TAC Instruction\n"

    let tac_instr_name instr =
  match instr with
  | TAC_Comment _ -> "TAC_Comment"
  | TAC_Assign (_, _) -> "TAC_Assign"
  | TAC_Assign_Default (_, _) -> "TAC_Assign_Default"
  | TAC_Assign_Int (_, _) -> "TAC_Assign_Int"
  | TAC_Assign_String (_, _) -> "TAC_Assign_String"
  | TAC_Assign_Variable (_, _) -> "TAC_Assign_Variable"
  | TAC_Assign_Plus (_, _, _) -> "TAC_Assign_Plus"
  | TAC_Assign_Minus (_, _, _) -> "TAC_Assign_Minus"
  | TAC_Assign_Times (_, _, _) -> "TAC_Assign_Times"
  | TAC_Assign_Divide (_, _, _) -> "TAC_Assign_Divide"
  | TAC_Assign_Lt (_, _, _) -> "TAC_Assign_Lt"
  | TAC_Assign_Le (_, _, _) -> "TAC_Assign_Le"
  | TAC_Assign_Eq (_, _, _) -> "TAC_Assign_Eq"
  | TAC_Assign_Not (_, _) -> "TAC_Assign_Not"
  | TAC_Assign_Negate (_, _) -> "TAC_Assign_Negate"
  | TAC_Assign_New (_, _) -> "TAC_Assign_New"
  | TAC_Assign_Bool (_, _) -> "TAC_Assign_Bool"
  | TAC_Label _ -> "TAC_Label"
  | TAC_Jump _ -> "TAC_Jump" 
  | TAC_ConditionalJump (_, _) -> "TAC_ConditionalJump"
  | TAC_Return _ -> "TAC_Return"
  | TAC_Call (_, _, _) -> "TAC_Call"
  | _ -> "Unknown_TAC_Instruction"

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

type value =
  | Int of int
  | Bool of bool
  | String of string
  | Object of object_data
  | Null

and object_data = {
  type_tag : string;
  fields : (string, int) Hashtbl.t; (* maybe vtable pointer *)
}

type env = (string, int) Hashtbl.t (*variable -> location *)
type store = (int, value) Hashtbl.t (*location -> value *)

(* Collects strings from an expression.*)
let rec collect_strings_from_exp (e : exp) =
  match e.exp_kind with
  | AST_String s -> [ s ]
  | AST_Assign (_, e') -> collect_strings_from_exp e'
  | AST_DynamicDispatch (obj, _mname, args) ->
      collect_strings_from_exp obj
      @ List.concat (List.map collect_strings_from_exp args)
  | AST_StaticDispatch (obj, _tname, _mname, args) ->
      collect_strings_from_exp obj
      @ List.concat (List.map collect_strings_from_exp args)
  | AST_SelfDispatch (_mname, args) ->
      List.concat (List.map collect_strings_from_exp args)
  | AST_If (predicate, then_branch, else_branch) ->
      collect_strings_from_exp predicate
      @ collect_strings_from_exp then_branch
      @ collect_strings_from_exp else_branch
  | AST_While (predicate, body) ->
      collect_strings_from_exp predicate @ collect_strings_from_exp body
  | AST_Block exprs -> List.concat (List.map collect_strings_from_exp exprs)
  | AST_New _ -> [] (* no subexpressions to check *)
  | AST_IsVoid e1 -> collect_strings_from_exp e1
  | AST_Plus (e1, e2)
  | AST_Minus (e1, e2)
  | AST_Times (e1, e2)
  | AST_Divide (e1, e2)
  | AST_Lt (e1, e2)
  | AST_Le (e1, e2)
  | AST_Eq (e1, e2) ->
      collect_strings_from_exp e1 @ collect_strings_from_exp e2
  | AST_Not e1 | AST_Negate e1 -> collect_strings_from_exp e1
  | AST_Integer _ -> []
  | AST_Identifier _ -> [] (* not a string *)
  | AST_True | AST_False -> []
  | AST_Let (bindings, body) ->
      let strings_from_bindings =
        List.concat
          (List.map
             (fun (_var, _type, maybe_init) ->
               match maybe_init with
               | Some e -> collect_strings_from_exp e
               | None -> [])
             bindings)
      in
      strings_from_bindings @ collect_strings_from_exp body
  | AST_Case (expr, case_elements) ->
      let strings_in_expr = collect_strings_from_exp expr in
      let strings_in_cases =
        List.concat
          (List.map
             (fun (_id, _type, e) -> collect_strings_from_exp e)
             case_elements)
      in
      strings_in_expr @ strings_in_cases
  | AST_Internal _ -> []

(* Collect strings from a list of attributes.*)
let collect_strings_from_attrs attrs =
  List.fold_left
    (fun acc (_, _, init) ->
      match init with Some e -> acc @ collect_strings_from_exp e | None -> acc)
    [] attrs

(* basic block struct for cfg*)
type basic_block = {
  id : string;
  instructions : tac_instr list;
  mutable successors : string list;
  mutable predecessors : string list;
}

(* map from label to basic block *)
type cfg = (string, basic_block) Hashtbl.t

(* count variables*)
let temp_var_counter = ref 0

(* Keep track of temporaries needed for stack*)
let fresh_variable () =
  let v = "t$" ^ string_of_int !temp_var_counter in
  temp_var_counter := !temp_var_counter + 1;
  v

let reset_temp_var_counter () = temp_var_counter := 0
let get_temp_var_count () = !temp_var_counter

(* Count labals *)
let label_counter = ref 1

let fresh_label class_name method_name =
  let l = class_name ^ "_" ^ method_name ^ "_" ^ string_of_int !label_counter in
  label_counter := !label_counter + 1;
  l

let reset_label_counter () = label_counter := 0
(* “annotates” a variable name with its location*)

(* The traditional approach to converting expressions to three-address 
   code involves a recursive descent traversal of the abstract syntax tree. 
   The recursive descent traversal returns both a three-address code 
   instruction as well as a list of additional instructions that should be 
   prepended to the output.
*)

(* Main logic for parsing ast and converting to tac *)
(* keep track of ordering location: *)
let newloc_counter = ref 2

let newloc () =
  incr newloc_counter;
  !newloc_counter

let reset_newloc_counter () = newloc_counter := 2

let rec convert (current_class : string) (current_method : string) (env : env)
    (a : exp) : tac_instr list * tac_expr * env =
  match a.exp_kind with
  | AST_Identifier var_name ->
    if snd var_name = "self" then
      ([], TAC_Variable "self", env)
    else
      let temp = fresh_variable () in
      (* Lookup the variable in the environment; if not found, allocate a new location *)
      let _ =
        try Hashtbl.find env (snd var_name)
        with Not_found ->
          let new_loc = newloc () in
          Hashtbl.add env (snd var_name) new_loc;
          new_loc
      in
      ( [ TAC_Assign_Variable (temp, snd var_name) ],
        TAC_Variable temp,
        env )
  | AST_Integer i ->
      let new_var = fresh_variable () in
      ([ TAC_Assign_Int (new_var, int_of_string i) ], TAC_Variable new_var, env)
  | AST_String s ->
      let new_var = fresh_variable () in
      ([ TAC_Assign_String (new_var, s) ], TAC_Variable new_var, env)
  | AST_True ->
      let new_var = fresh_variable () in
      ([ TAC_Assign_Bool (new_var, true) ], TAC_Variable new_var, env)
  | AST_False ->
      let new_var = fresh_variable () in
      ([ TAC_Assign_Bool (new_var, false) ], TAC_Variable new_var, env)
  | AST_Plus (a1, a2) ->
      let i1, ta1, env1 = convert current_class current_method env a1 in
      let i2, ta2, env2 = convert current_class current_method env1 a2 in
      let new_var = fresh_variable () in
      let to_output = TAC_Assign_Plus (new_var, ta1, ta2) in
      (i1 @ i2 @ [ to_output ], TAC_Variable new_var, env2)
  | AST_Minus (a1, a2) ->
      let i1, ta1, env1 = convert current_class current_method env a1 in
      let i2, ta2, env2 = convert current_class current_method env1 a2 in
      let new_var = fresh_variable () in
      let to_output = TAC_Assign_Minus (new_var, ta1, ta2) in
      (i1 @ i2 @ [ to_output ], TAC_Variable new_var, env2)
  | AST_Times (a1, a2) ->
      let i1, ta1, env1 = convert current_class current_method env a1 in
      let i2, ta2, env2 = convert current_class current_method env1 a2 in
      let new_var = fresh_variable () in
      let to_output = TAC_Assign_Times (new_var, ta1, ta2) in
      (i1 @ i2 @ [ to_output ], TAC_Variable new_var, env2)
  | AST_Divide (a1, a2) ->
      let i1, ta1, env1 = convert current_class current_method env a1 in
      let i2, ta2, env2 = convert current_class current_method env1 a2 in
      let new_var = fresh_variable () in
      let to_output = TAC_Assign_Divide (new_var, ta1, ta2) in
      (i1 @ i2 @ [ to_output ], TAC_Variable new_var, env2)
  | AST_Lt (a1, a2) ->
      let i1, ta1, env1 = convert current_class current_method env a1 in
      let i2, ta2, env2 = convert current_class current_method env1 a2 in
      let new_var = fresh_variable () in
      let to_output = TAC_Assign_Lt (new_var, ta1, ta2) in
      (i1 @ i2 @ [ to_output ], TAC_Variable new_var, env2)
  | AST_Le (a1, a2) ->
      let i1, ta1, env1 = convert current_class current_method env a1 in
      let i2, ta2, env2 = convert current_class current_method env1 a2 in
      let new_var = fresh_variable () in
      let to_output = TAC_Assign_Le (new_var, ta1, ta2) in
      (i1 @ i2 @ [ to_output ], TAC_Variable new_var, env2)
  | AST_Eq (a1, a2) ->
      let i1, ta1, env1 = convert current_class current_method env a1 in
      let i2, ta2, env2 = convert current_class current_method env1 a2 in
      let new_var = fresh_variable () in
      let to_output = TAC_Assign_Eq (new_var, ta1, ta2) in
      (i1 @ i2 @ [ to_output ], TAC_Variable new_var, env2)
  | AST_Not a1 ->
      let i1, ta1, env1 = convert current_class current_method env a1 in
      let new_var = fresh_variable () in
      let to_output = TAC_Assign_Not (new_var, ta1) in
      (i1 @ [ to_output ], TAC_Variable new_var, env1)
  | AST_Negate a1 ->
      let i1, ta1, env1 = convert current_class current_method env a1 in
      let new_var = fresh_variable () in
      let to_output = TAC_Assign_Negate (new_var, ta1) in
      (i1 @ [ to_output ], TAC_Variable new_var, env1)
  | AST_IsVoid a1 ->
      let i1, ta1, env1 = convert current_class current_method env a1 in
      let new_var = fresh_variable () in
      let to_output = TAC_Assign_IsVoid (new_var, ta1) in
      (i1 @ [ to_output ], TAC_Variable new_var, env1)
  | AST_New type_name ->
      let new_var = fresh_variable () in
      ( [ TAC_Assign_New (new_var, TAC_Variable (snd type_name)) ],
        TAC_Variable new_var,
        env )
  | AST_If (cond, then_branch, else_branch) ->
      let cond_instrs, cond_expr, env1 =
        convert current_class current_method env cond
      in
      let not_temp = fresh_variable () in
      let not_instr = TAC_Assign_Not (not_temp, cond_expr) in
      let label_then = fresh_label current_class current_method in
      let label_else = fresh_label current_class current_method in
      let label_join = fresh_label current_class current_method in
      let then_instrs, then_expr, env2 =
        convert current_class current_method env1 then_branch
      in
      let then_code =
        [ TAC_Comment "then branch"; TAC_Label label_then ]
        @ then_instrs @ [ TAC_Jump label_join ]
      in
      let else_instrs, else_expr, env3 =
        convert current_class current_method env2 else_branch
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
      (if_instrs, TAC_Variable "t$0", env3)
  | AST_Assign (var_name, expr) ->
      let instrs, expr_val, env1 =
        convert current_class current_method env expr
      in
      (* Here we assume var_name is already bound in env.
         In a complete implementation, you might check for unbound variables. *)
      let assign_instr =
        TAC_Assign_Variable (snd var_name, tac_expr_to_string expr_val)
      in
      let final_copy = TAC_Assign_Variable ("t$0", snd var_name) in
      (instrs @ [ assign_instr; final_copy ], TAC_Variable "t$0", env1)
  | AST_Block exprs ->
      let rec process_block exprs env_acc =
        match exprs with
        | [] -> ([], TAC_Variable "void", env_acc)
        | [ last ] -> convert current_class current_method env_acc last
        | first :: rest ->
            let first_instrs, _, env_updated =
              convert current_class current_method env_acc first
            in
            let rest_instrs, rest_expr, env_final =
              process_block rest env_updated
            in
            (first_instrs @ rest_instrs, rest_expr, env_final)
      in
      process_block exprs env
  | AST_While (cond, body) ->
      label_counter := 0;
      let while_start = fresh_label current_class current_method in
      let while_pred = fresh_label current_class current_method in
      let while_join = fresh_label current_class current_method in
      let while_body = fresh_label current_class current_method in
      let cond_instrs, cond_expr, env1 =
        convert current_class current_method env cond
      in
      let body_instrs, body_expr, env2 =
        convert current_class current_method env1 body
      in
      let cond_var = fresh_variable () in
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
      let result_var = fresh_variable () in
      (tac_instrs, TAC_Variable result_var, env2)
  | AST_DynamicDispatch (obj, method_name, args) ->
      let obj_instrs, obj_expr, env1 =
        convert current_class current_method env obj
      in
      let args_data =
        List.map (fun arg -> convert current_class current_method env1 arg) args
      in
      let arg_instrs = List.concat (List.map (fun (i, _, _) -> i) args_data) in
      let arg_exprs =
        List.map (fun (_, e, _) -> tac_expr_to_string e) args_data
      in
      let call_instr = TAC_Call ("t$0", snd method_name, arg_exprs) in
      (obj_instrs @ arg_instrs @ [ call_instr ], TAC_Variable "t$0", env1)
  | AST_StaticDispatch (obj, type_name, method_name, args) ->
      (* Convert the object expression *)
      let obj_instrs, obj_expr, env1 =
        convert current_class current_method env obj
      in
      (* Convert each argument *)
      let args_data =
        List.map (fun arg -> convert current_class current_method env1 arg) args
      in
      let arg_instrs = List.concat (List.map (fun (i, _, _) -> i) args_data) in
      let arg_exprs =
        List.map (fun (_, e, _) -> tac_expr_to_string e) args_data
      in
      let result_var = fresh_variable () in
      let obj_var = tac_expr_to_string obj_expr in
      (* Instead of TAC_Assign_StaticCall, we now use TAC_Call for static dispatch *)
      let call_instr = TAC_Call (result_var, snd method_name, arg_exprs) in
      (obj_instrs @ arg_instrs @ [ call_instr ], TAC_Variable result_var, env1)
  | AST_SelfDispatch (method_name, args) ->
      let self_exp =
        {
          loc = "0";
          exp_kind = AST_Identifier ("0", "self");
          static_type = None;
        }
      in
      let dispatch_exp =
        {
          loc = a.loc;
          exp_kind = AST_DynamicDispatch (self_exp, method_name, args);
          static_type = None;
        }
      in
      convert current_class current_method env dispatch_exp
  | AST_Case (expr, case_elements) ->
      let expr_instrs, expr_temp, env1 =
        convert current_class current_method env expr
      in
      let result_var = fresh_variable () in
      let case_instrs, _ =
        List.fold_left
          (fun (instrs, idx) (id, type_name, body) ->
            let case_label = fresh_label current_class current_method in
            let next_label = fresh_label current_class current_method in
            let body_instrs, body_temp, env_updated =
              convert current_class current_method env1 body
            in
            let branch_instrs =
              body_instrs
              @ [
                  TAC_Assign_Variable (result_var, tac_expr_to_string body_temp);
                ]
            in
            (instrs @ branch_instrs, idx + 1))
          ([], 0) case_elements
      in
      (expr_instrs @ case_instrs, TAC_Variable result_var, env1)
  | AST_Internal s ->
      let new_var = fresh_variable () in
      ([ TAC_Call (new_var, s, []) ], TAC_Variable new_var, env)
 | AST_Let (bindings, body_exp) ->
    (* Process each binding in sequence, building up the environment *)
    let rec process_bindings remaining_bindings current_env acc_instrs =
      match remaining_bindings with
      | [] ->
          (* No more bindings, process the body with the final environment *)
          let body_instrs, body_expr, _ =
            convert current_class current_method current_env body_exp
          in
          (acc_instrs @ body_instrs, body_expr, current_env)
      | (var_id, type_id, init_opt) :: rest ->
          (* Process the initialization expression if it exists *)
          let init_instrs, init_expr, env_after_init =
            match init_opt with
            | Some exp -> convert current_class current_method current_env exp
            | None ->
                (* If no initialization, use default value based on type *)
                (match snd type_id with
                 | "Int" ->
                     let temp = fresh_variable () in
                     ([ TAC_Assign_Int (temp, 0) ], TAC_Variable temp, current_env)
                 | "Bool" ->
                     let temp = fresh_variable () in
                     ([ TAC_Assign_Bool (temp, false) ], TAC_Variable temp, current_env)
                 | "String" ->
                     let temp = fresh_variable () in
                     ([ TAC_Assign_String (temp, "") ], TAC_Variable temp, current_env)
                 | _ ->
                     (* For other types, create a new object *)
                     let temp = fresh_variable () in
                     let class_name_var = fresh_variable () in
                     let class_name_instrs =
                       [ TAC_Assign_String (class_name_var, snd type_id) ]
                     in
                     ( class_name_instrs @ [ TAC_Assign_New (temp, TAC_Variable class_name_var) ],
                       TAC_Variable temp,
                       current_env))
          in

          (* Allocate a new location for the let-bound variable *)
          let var_loc = newloc () in
          let updated_env = Hashtbl.copy env_after_init in
          Hashtbl.add updated_env (snd var_id) var_loc;

          (* Create TAC instruction to store the initializer value in the let-bound variable.
             Instead of annotate_var, we simply use the plain variable name. *)
          let store_instr =
            match init_expr with
            | TAC_Variable var_name ->
                [ TAC_Assign_Variable (snd var_id, var_name) ]
            | _ -> []
          in

          (* Process the remaining bindings with the updated environment *)
          process_bindings rest updated_env (acc_instrs @ init_instrs @ store_instr)
    in
    process_bindings bindings env []

let identify_leaders (instructions : tac_instr list) : int list =
  let rec find_leaders acc index instrs =
    match instrs with
    | [] -> List.rev acc
    | first_instr :: rest ->
        (* The first instruction is always a leader *)
        let acc' =
          if index = 0 then
            index :: acc
          else
            match first_instr with
            | TAC_Label _ ->
                index :: acc (* Instructions following labels are leaders *)
            | _ -> (
                match List.nth_opt instructions (index - 1) with
                | Some (TAC_Jump _)
                | Some (TAC_ConditionalJump _)
                | Some (TAC_Return _) ->
                    index :: acc (* Instructions following jumps are leaders *)
                | _ -> acc)
        in
        find_leaders acc' (index + 1) rest
  in
  find_leaders [] 0 instructions

(* Create basic blocks from leaders *)
let create_basic_blocks (instructions : tac_instr list) (leaders : int list) :
    basic_block list =
  (* sort the leaders to ensure correct block creation *)
  let sorted_leaders = List.sort compare leaders in

  (* Helper function to extract instructions for a block *)
  let get_block_instructions start_idx end_idx =
    let rec extract acc i =
      if i >= end_idx || i >= List.length instructions then
        List.rev acc
      else
        extract (List.nth instructions i :: acc) (i + 1)
    in
    extract [] start_idx
  in

  (* Create blocks from each leader to the next leader (or end) *)
  let rec create_blocks acc = function
    | [] -> List.rev acc
    | [ leader_idx ] ->
        (* Last leader - block continues to the end of instructions *)
        let block_instrs =
          get_block_instructions leader_idx (List.length instructions)
        in
        let block_id = "BB" ^ string_of_int (List.length acc) in
        let block =
          {
            id = block_id;
            instructions = block_instrs;
            successors = [];
            predecessors = [];
          }
        in
        List.rev (block :: acc)
    | leader_idx :: next_leader :: rest ->
        (* Create block from this leader to the next one *)
        let block_instrs = get_block_instructions leader_idx next_leader in
        let block_id = "BB" ^ string_of_int (List.length acc) in
        let block =
          {
            id = block_id;
            instructions = block_instrs;
            successors = [];
            predecessors = [];
          }
        in
        create_blocks (block :: acc) (next_leader :: rest)
  in

  create_blocks [] sorted_leaders

(* Map from TAC labels to basic block IDs *)
let create_label_to_block_map (blocks : basic_block list) :
    (string, string) Hashtbl.t =
  let label_map = Hashtbl.create 50 in

  List.iter
    (fun block ->
      List.iter
        (function
          | TAC_Label label -> Hashtbl.add label_map label block.id | _ -> ())
        block.instructions)
    blocks;

  label_map

(* Connect basic blocks to create control flow *)
let build_cfg (blocks : basic_block list) : cfg =
  let cfg_map = Hashtbl.create (List.length blocks) in
  let label_to_block = create_label_to_block_map blocks in

  (* Add all blocks to the hashtable first *)
  List.iter (fun block -> Hashtbl.add cfg_map block.id block) blocks;

  (* Helper function to find the next block in sequence *)
  let find_next_block current_block =
    let rec find_next = function
      | [] -> None
      | [ _ ] -> None (* Last block has no next *)
      | b1 :: b2 :: rest ->
          if b1.id = current_block.id then
            Some b2
          else
            find_next (b2 :: rest)
    in
    find_next blocks
  in

  (* Update successors and predecessors *)
  List.iter
    (fun block ->
      (* Check the last instruction for jumps *)
      let targets =
        match List.rev block.instructions with
        | TAC_Jump label :: _ -> (
            match Hashtbl.find_opt label_to_block label with
            | Some target_block -> [ target_block ]
            | None -> [])
        | TAC_ConditionalJump (_, label) :: rest -> (
            let jump_target =
              match Hashtbl.find_opt label_to_block label with
              | Some target_block -> [ target_block ]
              | None -> []
            in
            (* For conditional jumps, add fallthrough unless there's an unconditional jump after *)
            match rest with
            | TAC_Jump fallthrough_label :: _ -> (
                match Hashtbl.find_opt label_to_block fallthrough_label with
                | Some target_block -> target_block :: jump_target
                | None -> jump_target)
            | _ -> (
                (* If no explicit jump after conditional, fallthrough to next block *)
                match find_next_block block with
                | Some next_block -> next_block.id :: jump_target
                | None -> jump_target))
        | TAC_Return _ :: _ ->
            [] (* Return has no successors within the function *)
        | _ -> (
            (* If there's no jump at the end, fallthrough to the next block *)
            match find_next_block block with
            | Some next_block -> [ next_block.id ]
            | None -> [])
      in

      (* Update current block's successors *)
      let block = Hashtbl.find cfg_map block.id in
      block.successors <- targets;

      (* Update each target's predecessors *)
      List.iter
        (fun target ->
          match Hashtbl.find_opt cfg_map target with
          | Some target_block ->
              target_block.predecessors <- block.id :: target_block.predecessors
          | None -> () (* Target might be outside the current function *))
        targets)
    blocks;

  cfg_map

(*  debugging *)
let print_cfg cfg =
  Printf.printf "Control Flow Graph:\n";
  Hashtbl.iter
    (fun _ block ->
      Printf.printf "Block %s:\n" block.id;
      Printf.printf "  Predecessors: %s\n"
        (String.concat ", " block.predecessors);
      Printf.printf "  Instructions:\n";
      List.iter
        (fun instr -> Printf.printf "    %s" (tac_instr_to_str instr))
        block.instructions;
        List.iter
        (fun instr -> Printf.printf "    %s" (tac_instr_name instr))
        block.instructions;
     
      Printf.printf "  Successors: %s\n\n" (String.concat ", " block.successors))
    cfg

(* Helper function for existing code *)
let rec get_all_methods parent_map method_order class_name =
  (* Get parent's methods first, if any *)
  let parent_methods =
    match Hashtbl.find_opt parent_map class_name with
    | Some parent -> get_all_methods parent_map method_order parent
    | None -> []
  in
  (* Get methods defined directly in this class from method_order, excluding "new" *)
  let own_methods =
    List.filter (fun (c, m) -> c = class_name && m <> "new") method_order
    |> List.map snd
  in

  (* Combine parent's methods and then append any new methods defined in this class *)
  parent_methods
  @ List.filter (fun m -> not (List.mem m parent_methods)) own_methods

(* Function to convert a method to CFG *)
let method_to_cfg class_name method_name body_exp : cfg =
  let initial_env = Hashtbl.create 10 in
  let tac_instructions, _tac_expr, _final_env =
    convert class_name method_name initial_env body_exp
  in
  let leaders = identify_leaders tac_instructions in
  let basic_blocks = create_basic_blocks tac_instructions leaders in
  build_cfg basic_blocks

(* Create a mapping from string literals to their labels *)
let string_label_map = Hashtbl.create 100

(* global counter for string literals throughout program*)
let string_literal_counter = ref 0

(* List to keep track of strings in registration order *)
let string_literal_list = ref []

(* Base strings that are always included *)
let base_strings =
  [ ("the.empty.string", ""); ("percent.d", "%ld"); ("percent.ld", " %ld") ]

let init_string_literal_counter n =
  string_literal_counter := n;
  Hashtbl.clear string_label_map;

  (* Add base strings to the hashtable but not to the list yet *)
  List.iter
    (fun (label, str) -> Hashtbl.add string_label_map str label)
    base_strings;

  string_literal_list := []

(* Register a string literal and return a unique label *)
let register_string_literal literal =
  (* If already registered, return the label *)
  match Hashtbl.find_opt string_label_map literal with
  | Some label -> label
  | None ->
      let label = "string" ^ string_of_int !string_literal_counter in
      incr string_literal_counter;
      Hashtbl.add string_label_map literal label;
      string_literal_list := (label, literal) :: !string_literal_list;
      label

let get_string_label str =
  match Hashtbl.find_opt string_label_map str with
  | Some label -> label
  | None ->
      (* Automatically register it if it's not already in the map *)
      register_string_literal str

(* This function collects all strings but doesn't generate code yet *)
let collect_all_strings class_map class_order impl_map =
  init_string_literal_counter 1;

  (* Register class names *)
  List.iter (fun cls -> ignore (register_string_literal cls)) class_order;

  (* Attributes *)
  Hashtbl.iter
    (fun _ (attrs, _) ->
      let strings = collect_strings_from_attrs attrs in
      List.iter (fun s -> ignore (register_string_literal s)) strings)
    class_map;

  ignore (register_string_literal "abort\\n");

  (* Method bodies *)
  Hashtbl.iter
    (fun _ (_, _, _, body) ->
      let strings = collect_strings_from_exp body in
      List.iter (fun s -> ignore (register_string_literal s)) strings)
    impl_map;

  (* Add default exception messages *)
  ignore
    (register_string_literal
       "ERROR: 0: Exception: String.substr out of range\\n");

  !string_literal_list

let print_string_label_map () =
  Printf.printf "---- String Label Map ----\n";
  Hashtbl.iter
    (fun literal label -> Printf.printf "  \"%s\" -> %s\n" literal label)
    string_label_map;
  Printf.printf "--------------------------\n"

let generate_object_abort_method () =
  let error_str = "abort\\n" in
  let error_label = get_string_label error_str in

  [
    "                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;";
    ".globl Object.abort";
    "Object.abort:           ## method definition";
    "                        pushq %rbp";
    "                        movq %rsp, %rbp";
    "                        movq 16(%rbp), %r12";
    "                        ## stack room for temporaries: 2";
    "                        movq $16, %r14";
    "                        subq %r14, %rsp";
    "                        ## return address handling";
    "                        ## method body begins";
    "                        movq $" ^ error_label ^ ", %r13";
    "                        ## guarantee 16-byte alignment before call";
    "\t\t\tandq $0xFFFFFFFFFFFFFFF0, %rsp";
    "\t\t\tmovq %r13, %rdi";
    "\t\t\tcall cooloutstr";
    "                        ## guarantee 16-byte alignment before call";
    "\t\t\tandq $0xFFFFFFFFFFFFFFF0, %rsp";
    "\t\t\tmovl $0, %edi";
    "\t\t\tcall exit";
    ".globl Object.abort.end";
    "Object.abort.end:       ## method body ends";
    "                        ## return address handling";
    "                        movq %rbp, %rsp";
    "                        popq %rbp";
    "                        ret";
  ]

let generate_object_copy_method () =
  [
    "                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;";
    ".globl Object.copy";
    "Object.copy:            ## method definition";
    "                        pushq %rbp";
    "                        movq %rsp, %rbp";
    "                        movq 16(%rbp), %r12";
    "                        ## stack room for temporaries: 2";
    "                        movq $16, %r14";
    "                        subq %r14, %rsp";
    "                        ## return address handling";
    "                        ## method body begins";
    "                        movq 8(%r12), %r14";
    "                        ## guarantee 16-byte alignment before call";
    "\t\t\tandq $0xFFFFFFFFFFFFFFF0, %rsp";
    "\t\t\tmovq $8, %rsi";
    "\t\t\tmovq %r14, %rdi";
    "\t\t\tcall calloc";
    "\t\t\tmovq %rax, %r13";
    "                        pushq %r13";
    ".globl l1";
    "l1:                     cmpq $0, %r14";
    "\t\t\tje l2";
    "                        movq 0(%r12), %r15";
    "                        movq %r15, 0(%r13)";
    "                        movq $8, %r15";
    "                        addq %r15, %r12";
    "                        addq %r15, %r13";
    "                        movq $1, %r15";
    "                        subq %r15, %r14";
    "                        jmp l1";
    ".globl l2";
    "l2:                     ## done with Object.copy loop";
    "                        popq %r13";
    ".globl Object.copy.end";
    "Object.copy.end:        ## method body ends";
    "                        ## return address handling";
    "                        movq %rbp, %rsp";
    "                        popq %rbp";
    "                        ret";
  ]

let generate_object_type_name_method () =
  [
    "                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;";
    ".globl Object.type_name";
    "Object.type_name:       ## method definition";
    "                        pushq %rbp";
    "                        movq %rsp, %rbp";
    "                        movq 16(%rbp), %r12";
    "                        ## stack room for temporaries: 2";
    "                        movq $16, %r14";
    "                        subq %r14, %rsp";
    "                        ## return address handling";
    "                        ## method body begins";
    "                        ## new String";
    "                        pushq %rbp";
    "                        pushq %r12";
    "                        movq $String..new, %r14";
    "                        call *%r14";
    "                        popq %r12";
    "                        popq %rbp";
    "                        ## obtain vtable for self object";
    "                        movq 16(%r12), %r14";
    "                        ## look up type name at offset 0 in vtable";
    "                        movq 0(%r14), %r14";
    "                        movq %r14, 24(%r13)";
    ".globl Object.type_name.end";
    "Object.type_name.end:   ## method body ends";
    "                        ## return address handling";
    "                        movq %rbp, %rsp";
    "                        popq %rbp";
    "                        ret";
  ]

let generate_io_in_int_method () =
  [
    "                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;";
    ".globl IO.in_int";
    "IO.in_int:              ## method definition";
    "                        pushq %rbp";
    "                        movq %rsp, %rbp";
    "                        movq 16(%rbp), %r12";
    "                        ## stack room for temporaries: 2";
    "                        movq $16, %r14";
    "                        subq %r14, %rsp";
    "                        ## return address handling";
    "                        ## method body begins";
    "                        ## new Int";
    "                        pushq %rbp";
    "                        pushq %r12";
    "                        movq $Int..new, %r14";
    "                        call *%r14";
    "                        popq %r12";
    "                        popq %rbp";
    "                        movq %r13, %r14";
    "                        \t\t\tmovl\t$1, %esi";
    "\t\t\tmovl $4096, %edi";
    "\t\t\tcall calloc";
    "\t\t\tpushq %rax";
    "\t\t\tmovq %rax, %rdi";
    "\t\t\tmovq $4096, %rsi ";
    "\t\t\tmovq stdin(%rip), %rdx";
    "\t\t\tcall fgets ";
    "\t\t\tpopq %rdi ";
    "\t\t\tmovl $0, %eax";
    "\t\t\tpushq %rax";
    "\t\t\tmovq %rsp, %rdx";
    "\t\t\tmovq $percent.ld, %rsi";
    "\t\t\tcall sscanf";
    "\t\t\tpopq %rax";
    "\t\t\tmovq $0, %rsi ";
    "\t\t\tcmpq $2147483647, %rax ";
    "\t\t\tcmovg %rsi, %rax";
    "\t\t\tcmpq $-2147483648, %rax ";
    "\t\t\tcmovl %rsi, %rax";
    "\t\t\tmovq %rax, %r13";
    "                        movq %r13, 24(%r14)";
    "                        movq %r14, %r13";
    ".globl IO.in_int.end";
    "IO.in_int.end:          ## method body ends";
    "                        ## return address handling";
    "                        movq %rbp, %rsp";
    "                        popq %rbp";
    "                        ret";
  ]

let generate_io_in_string_method () =
  [
    "                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;";
    ".globl IO.in_string";
    "IO.in_string:           ## method definition";
    "                        pushq %rbp";
    "                        movq %rsp, %rbp";
    "                        movq 16(%rbp), %r12";
    "                        ## stack room for temporaries: 2";
    "                        movq $16, %r14";
    "                        subq %r14, %rsp";
    "                        ## return address handling";
    "                        ## method body begins";
    "                        ## new String";
    "                        pushq %rbp";
    "                        pushq %r12";
    "                        movq $String..new, %r14";
    "                        call *%r14";
    "                        popq %r12";
    "                        popq %rbp";
    "                        movq %r13, %r14";
    "                        ## guarantee 16-byte alignment before call";
    "\t\t\tandq $0xFFFFFFFFFFFFFFF0, %rsp";
    "\t\t\tcall coolgetstr ";
    "\t\t\tmovq %rax, %r13";
    "                        movq %r13, 24(%r14)";
    "                        movq %r14, %r13";
    ".globl IO.in_string.end";
    "IO.in_string.end:       ## method body ends";
    "                        ## return address handling";
    "                        movq %rbp, %rsp";
    "                        popq %rbp";
    "                        ret";
  ]

let generate_io_out_int_method () =
  [
    (* IO.out_int implementation - similar structure *)
    "                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;";
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

let generate_io_out_string_method () =
  [
    (* IO.out_string implementation *)
    "                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;";
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
  ]

let generate_string_concat_method () =
  [
    "                         ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;";
    ".globl String.concat";
    "String.concat:          ## method definition";
    "                        pushq %rbp";
    "                        movq %rsp, %rbp";
    "                        movq 16(%rbp), %r12";
    "                        ## stack room for temporaries: 2";
    "                        movq $16, %r14";
    "                        subq %r14, %rsp";
    "                        ## return address handling";
    "                        ## fp[3] holds argument s (String)";
    "                        ## method body begins";
    "                        ## new String";
    "                        pushq %rbp";
    "                        pushq %r12";
    "                        movq $String..new, %r14";
    "                        call *%r14";
    "                        popq %r12";
    "                        popq %rbp";
    "                        movq %r13, %r15";
    "                        movq 24(%rbp), %r14";
    "                        movq 24(%r14), %r14";
    "                        movq 24(%r12), %r13";
    "                        ## guarantee 16-byte alignment before call";
    "\t\t\tandq $0xFFFFFFFFFFFFFFF0, %rsp";
    "\t\t\tmovq %r13, %rdi";
    "\t\t\tmovq %r14, %rsi";
    "\t\t\tcall coolstrcat";
    "\t\t\tmovq %rax, %r13";
    "                        movq %r13, 24(%r15)";
    "                        movq %r15, %r13";
    ".globl String.concat.end";
    "String.concat.end:      ## method body ends";
    "                        ## return address handling";
    "                        movq %rbp, %rsp";
    "                        popq %rbp";
    "                        ret";
  ]

let generate_string_length_method () =
  [
    "                            ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;";
    ".globl String.length";
    "String.length:          ## method definition";
    "                        pushq %rbp";
    "                        movq %rsp, %rbp";
    "                        movq 16(%rbp), %r12";
    "                        ## stack room for temporaries: 2";
    "                        movq $16, %r14";
    "                        subq %r14, %rsp";
    "                        ## return address handling";
    "                        ## method body begins";
    "                        ## new Int";
    "                        pushq %rbp";
    "                        pushq %r12";
    "                        movq $Int..new, %r14";
    "                        call *%r14";
    "                        popq %r12";
    "                        popq %rbp";
    "                        movq %r13, %r14";
    "                        movq 24(%r12), %r13";
    "                        ## guarantee 16-byte alignment before call";
    "\t\t\tandq $0xFFFFFFFFFFFFFFF0, %rsp";
    "\t\t\tmovq %r13, %rdi";
    "\t\t\tmovl $0, %eax";
    "\t\t\tcall coolstrlen";
    "\t\t\tmovq %rax, %r13";
    "                        movq %r13, 24(%r14)";
    "                        movq %r14, %r13";
    ".globl String.length.end";
    "String.length.end:      ## method body ends";
    "                        ## return address handling";
    "                        movq %rbp, %rsp";
    "                        popq %rbp";
    "                        ret";
  ]

let generate_string_substr_method () =
  let error_str = "ERROR: 0: Exception: String.substr out of range\\n" in
  let error_label = get_string_label error_str in
  [
    "                            ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;";
    ".globl String.substr";
    "String.substr:          ## method definition";
    "                        pushq %rbp";
    "                        movq %rsp, %rbp";
    "                        movq 16(%rbp), %r12";
    "                        ## stack room for temporaries: 2";
    "                        movq $16, %r14";
    "                        subq %r14, %rsp";
    "                        ## return address handling";
    "                        ## fp[4] holds argument i (Int)";
    "                        ## fp[3] holds argument l (Int)";
    "                        ## method body begins";
    "                        ## new String";
    "                        pushq %rbp";
    "                        pushq %r12";
    "                        movq $String..new, %r14";
    "                        call *%r14";
    "                        popq %r12";
    "                        popq %rbp";
    "                        movq %r13, %r15";
    "                        movq 24(%rbp), %r14";
    "                        movq 24(%r14), %r14";
    "                        movq 32(%rbp), %r13";
    "                        movq 24(%r13), %r13";
    "                        movq 24(%r12), %r12";
    "                        ## guarantee 16-byte alignment before call";
    "\t\t\tandq $0xFFFFFFFFFFFFFFF0, %rsp";
    "\t\t\tmovq %r12, %rdi";
    "\t\t\tmovq %r13, %rsi";
    "\t\t\tmovq %r14, %rdx";
    "\t\t\tcall coolsubstr";
    "\t\t\tmovq %rax, %r13";
    "                        cmpq $0, %r13";
    "\t\t\tjne l3";
    "                        movq $" ^ error_label ^ ", %r13";
    "                        ## guarantee 16-byte alignment before call";
    "\t\t\tandq $0xFFFFFFFFFFFFFFF0, %rsp";
    "\t\t\tmovq %r13, %rdi";
    "\t\t\tcall cooloutstr";
    "                        ## guarantee 16-byte alignment before call";
    "\t\t\tandq $0xFFFFFFFFFFFFFFF0, %rsp";
    "\t\t\tmovl $0,  %edi";
    "\t\t\tcall exit";
    ".globl l3";
    "l3:                     movq %r13, 24(%r15)";
    "                        movq %r15, %r13";
    ".globl String.substr.end";
    "String.substr.end:      ## method body ends";
    "                        ## return address handling";
    "                        movq %rbp, %rsp";
    "                        popq %rbp";
    "                        ret";
  ]

type vtable_mapping = (string * string, int) Hashtbl.t

let vtable_offsets : vtable_mapping = Hashtbl.create 100

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
    let parent_methods =
      match Hashtbl.find_opt parent_map class_name with
      | Some parent -> get_all_methods parent
      | None -> []
    in
    let own_methods =
      List.filter (fun (c, m) -> c = class_name && m <> "new") method_order
      |> List.map snd
    in
    parent_methods
    @ List.filter (fun m -> not (List.mem m parent_methods)) own_methods
  in

  (* Generate VTable for a single class *)
  let generate_class_vtable class_name =
    let string_num = Hashtbl.find string_numbers class_name in
    let methods = get_all_methods class_name in

    (* Always include "new" as the constructor *)
    let all_methods = "new" :: methods in

    (* 8 bytes per pointer *)
    let word_size = 8 in

    (* For each method, compute the offset and populate vtable_offsets  off by one pointer
       for .quad string *)
    List.iteri
      (fun i method_name ->
        let offset = 8 + (i * word_size) in
        Hashtbl.add vtable_offsets (class_name, method_name) offset)
      all_methods;

    (* Generate the method entries assembly code *)
    let method_entries =
      List.map
        (fun method_name ->
          let label =
            if method_name = "new" then
              class_name ^ "..new"
            else
              match Hashtbl.find_opt impl_map (class_name, method_name) with
              | Some (_, _, defining_class, _) ->
                  defining_class ^ "." ^ method_name
              | None ->
                  let rec find_definer cls =
                    match Hashtbl.find_opt impl_map (cls, method_name) with
                    | Some (_, _, defining_class, _) -> defining_class
                    | None -> (
                        match Hashtbl.find_opt parent_map cls with
                        | Some parent -> find_definer parent
                        | None -> "Object")
                  in
                  let defining_class = find_definer class_name in
                  defining_class ^ "." ^ method_name
          in
          "\t\t\t\t\t\t.quad " ^ label)
        all_methods
    in

    (* Build the VTable assembly for this class *)
    [
      "                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;";
      ".globl " ^ class_name ^ "..vtable";
      class_name ^ "..vtable:\t\t\t## virtual function table for " ^ class_name;
      "\t\t\t\t\t\t.quad string" ^ string_of_int string_num;
    ]
    @ method_entries
  in

  (* Generate VTables for all classes in the specified order *)
  List.concat_map generate_class_vtable all_classes

let generate_vtable_offsets (class_map : class_map) (impl_map : impl_map)
    (parent_map : parent_map) (class_order : string list)
    (method_order : (string * string) list) : (string * string, int) Hashtbl.t =
  let vtable_offsets = Hashtbl.create 50 in
  let word_size = 8 in

  (* Helper to get all methods for a class*)
  let rec get_all_methods class_name =
    let parent_methods =
      match Hashtbl.find_opt parent_map class_name with
      | Some parent -> get_all_methods parent
      | None -> []
    in
    let own_methods =
      List.filter (fun (c, m) -> c = class_name && m <> "new") method_order
      |> List.map snd
    in
    parent_methods
    @ List.filter (fun m -> not (List.mem m parent_methods)) own_methods
  in

  (* Iterate through each class to build its method list and record offsets *)
  List.iter
    (fun class_name ->
      (* Get the ordered list of methods for this class *)
      let methods = get_all_methods class_name in
      (* Prepend the constructor "new" *)
      let all_methods = "new" :: methods in
      (* For each method, compute its offset and store in the hash table *)
      List.iteri
        (fun i method_name ->
          let offset = i * word_size in
          Hashtbl.add vtable_offsets (class_name, method_name) offset)
        all_methods)
    class_order;
  vtable_offsets

(* Store assigned class tags *)
let class_tag_table = Hashtbl.create 50

let () =
  List.iter
    (fun (cls, tag) -> Hashtbl.add class_tag_table cls tag)
    [
      ("Bool", 0);
      ("Int", 1);
      ("String", 3);
      ("IO", 10);
      ("Main", 11);
      ("Object", 12);
    ]

let next_class_tag = ref 13

let get_class_tag class_name =
  try Hashtbl.find class_tag_table class_name
  with Not_found ->
    let tag = !next_class_tag in
    incr next_class_tag;
    Hashtbl.add class_tag_table class_name tag;
    tag

let get_object_size class_name class_map =
  let base_size = 3 in
  (* 3 words 24 bytes for tag, size, and vtable pointer *)
  let num_attrs =
    try
      let attrs, _ = Hashtbl.find class_map class_name in
      List.length attrs
    with Not_found -> 0
  in
  base_size + num_attrs

(* Generate constructors for internal classes taken from reference compiler*)
let generate_internal_constructor class_name =
  match class_name with
  | "Bool" ->
      [
        "                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;";
        ".globl Bool..new";
        "Bool..new:              ## constructor for Bool";
        "                        pushq %rbp";
        "                        movq %rsp, %rbp";
        "                        ## stack room for temporaries: 2";
        "                        movq $16, %r14";
        "                        subq %r14, %rsp";
        "                        ## return address handling";
        "                        movq $4, %r12";
        "                        ## guarantee 16-byte alignment before call";
        "\t\t\tandq $0xFFFFFFFFFFFFFFF0, %rsp";
        "\t\t\tmovq $8, %rsi";
        "\t\t\tmovq %r12, %rdi";
        "\t\t\tcall calloc";
        "\t\t\tmovq %rax, %r12";
        "                        ## store class tag, object size and vtable \
         pointer";
        "                        movq $0, %r14";
        "                        movq %r14, 0(%r12)";
        "                        movq $4, %r14";
        "                        movq %r14, 8(%r12)";
        "                        movq $Bool..vtable, %r14";
        "                        movq %r14, 16(%r12)";
        "                        ## initialize attributes";
        "                        ## self[3] holds field (raw content) (Int)";
        "                        movq $0, %r13";
        "                        movq %r13, 24(%r12)";
        "                        ## self[3] (raw content) initializer -- none ";
        "                        movq %r12, %r13";
        "                        ## return address handling";
        "                        movq %rbp, %rsp";
        "                        popq %rbp";
        "                        ret";
      ]
  | "Int" ->
      [
        "                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;";
        ".globl Int..new";
        "Int..new:               ## constructor for Int";
        "                        pushq %rbp";
        "                        movq %rsp, %rbp";
        "                        ## stack room for temporaries: 2";
        "                        movq $16, %r14";
        "                        subq %r14, %rsp";
        "                        ## return address handling";
        "                        movq $4, %r12";
        "                        ## guarantee 16-byte alignment before call";
        "\t\t\tandq $0xFFFFFFFFFFFFFFF0, %rsp";
        "\t\t\tmovq $8, %rsi";
        "\t\t\tmovq %r12, %rdi";
        "\t\t\tcall calloc";
        "\t\t\tmovq %rax, %r12";
        "                        ## store class tag, object size and vtable \
         pointer";
        "                        movq $1, %r14";
        "                        movq %r14, 0(%r12)";
        "                        movq $4, %r14";
        "                        movq %r14, 8(%r12)";
        "                        movq $Int..vtable, %r14";
        "                        movq %r14, 16(%r12)";
        "                        ## initialize attributes";
        "                        ## self[3] holds field (raw content) (Int)";
        "                        movq $0, %r13";
        "                        movq %r13, 24(%r12)";
        "                        ## self[3] (raw content) initializer -- none ";
        "                        movq %r12, %r13";
        "                        ## return address handling";
        "                        movq %rbp, %rsp";
        "                        popq %rbp";
        "                        ret";
      ]
  | "IO" ->
      [
        "                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;";
        ".globl IO..new";
        "IO..new:                ## constructor for IO";
        "                        pushq %rbp";
        "                        movq %rsp, %rbp";
        "                        ## stack room for temporaries: 2";
        "                        movq $16, %r14";
        "                        subq %r14, %rsp";
        "                        ## return address handling";
        "                        movq $3, %r12";
        "                        ## guarantee 16-byte alignment before call";
        "\t\t\tandq $0xFFFFFFFFFFFFFFF0, %rsp";
        "\t\t\tmovq $8, %rsi";
        "\t\t\tmovq %r12, %rdi";
        "\t\t\tcall calloc";
        "\t\t\tmovq %rax, %r12";
        "                        ## store class tag, object size and vtable \
         pointer";
        "                        movq $10, %r14";
        "                        movq %r14, 0(%r12)";
        "                        movq $3, %r14";
        "                        movq %r14, 8(%r12)";
        "                        movq $IO..vtable, %r14";
        "                        movq %r14, 16(%r12)";
        "                        movq %r12, %r13";
        "                        ## return address handling";
        "                        movq %rbp, %rsp";
        "                        popq %rbp";
        "                        ret";
      ]
  | "Object" ->
      [
        "                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;";
        ".globl Object..new";
        "Object..new:            ## constructor for Object";
        "                        pushq %rbp";
        "                        movq %rsp, %rbp";
        "                        ## stack room for temporaries: 2";
        "                        movq $16, %r14";
        "                        subq %r14, %rsp";
        "                        ## return address handling";
        "                        movq $3, %r12";
        "                        ## guarantee 16-byte alignment before call";
        "\t\t\tandq $0xFFFFFFFFFFFFFFF0, %rsp";
        "\t\t\tmovq $8, %rsi";
        "\t\t\tmovq %r12, %rdi";
        "\t\t\tcall calloc";
        "\t\t\tmovq %rax, %r12";
        "                        ## store class tag, object size and vtable \
         pointer";
        "                        movq $12, %r14";
        "                        movq %r14, 0(%r12)";
        "                        movq $3, %r14";
        "                        movq %r14, 8(%r12)";
        "                        movq $Object..vtable, %r14";
        "                        movq %r14, 16(%r12)";
        "                        movq %r12, %r13";
        "                        ## return address handling";
        "                        movq %rbp, %rsp";
        "                        popq %rbp";
        "                        ret";
      ]
  | "String" ->
      [
        "                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;";
        ".globl String..new";
        "String..new:            ## constructor for String";
        "                        pushq %rbp";
        "                        movq %rsp, %rbp";
        "                        ## stack room for temporaries: 2";
        "                        movq $16, %r14";
        "                        subq %r14, %rsp";
        "                        ## return address handling";
        "                        movq $4, %r12";
        "                        ## guarantee 16-byte alignment before call";
        "\t\t\tandq $0xFFFFFFFFFFFFFFF0, %rsp";
        "\t\t\tmovq $8, %rsi";
        "\t\t\tmovq %r12, %rdi";
        "\t\t\tcall calloc";
        "\t\t\tmovq %rax, %r12";
        "                        ## store class tag, object size and vtable \
         pointer";
        "                        movq $3, %r14";
        "                        movq %r14, 0(%r12)";
        "                        movq $4, %r14";
        "                        movq %r14, 8(%r12)";
        "                        movq $String..vtable, %r14";
        "                        movq %r14, 16(%r12)";
        "                        ## initialize attributes";
        "                        ## self[3] holds field (raw content) (String)";
        "                        movq $the.empty.string, %r13";
        "                        movq %r13, 24(%r12)";
        "                        ## self[3] (raw content) initializer -- none ";
        "                        movq %r12, %r13";
        "                        ## return address handling";
        "                        movq %rbp, %rsp";
        "                        popq %rbp";
        "                        ret";
      ]
  | _ -> []



(*Functions preserve the registers rbx, rsp, rbp, r12, r13, r14, and r15;
while rax, rdi, rsi, rdx, rcx, r8, r9, r10, r11 are scratch registers. 
The return value is stored in the rax register*)
type codegen_context = {
  class_attributes: (string * string * int) list;  (* field_name, field_type, index *)
  temp_vars: (string * int) list;                  (* var_name, offset *)
  params: (string * int) list;                     (* param_name, loc *)
  class_name: string;
  method_name: string;
}

(* lookup_offset: For variables that are temporaries (names starting with "t$"),
   compute their stack slot offset relative to %rbp.
   Otherwise, look up the variable in the context.params list. *)
let lookup_offset context var =
  if String.length var >= 2 && (String.sub var 0 2) = "t$" then
    let n = int_of_string (String.sub var 2 (String.length var - 2)) in
    ((8 * n) * -1)
  else
    try
      let (_, _, index) = List.find (fun (fname, _, _) -> fname = var) context.class_attributes in
      index * 8
    with Not_found ->
      failwith ("lookup_offset: variable not found: " ^ var)(* lookup_field_offset: Look up a field name in the class_attributes list.
   We assume class_attributes is a list of tuples (field_name, field_type, index).
   This function returns the field’s offset as index * 8. *)
let lookup_field_offset context field =
  try
    let (_, _, index) = List.find (fun (fname, _, _) -> fname = field) context.class_attributes in
    index * 8
  with Not_found ->
    failwith ("lookup_field_offset: field not found: " ^ field)
(* Helper function to check if a variable is a temporary *)
let is_temp_var var =
  String.length var >= 2 && (String.sub var 0 2) = "t$"
(* generate_load: Given a context and a variable name, generate code to load its value
   into the scratch register %r13. For temporaries, simply use the %rbp offset.
   For non-temporary (field) names, load from the self object. *)
(* let generate_load context var = *)
(*   if String.length var >= 2 && (String.sub var 0 2) = "t$" then *)
(*     let offset = lookup_offset context var in *)
(*     "                        movq " ^ string_of_int offset ^ "(%rbp), %r13" *)
(*   else *)
(*     let field_offset = lookup_field_offset context var in *)
(*     (* For a field, we first load from self (in %r12) at the field offset, *)
(*        then dereference the obtained pointer again at the same offset. *) *)
(*     "                        movq " ^ string_of_int field_offset ^ "(%r12), %r13\n" ^ *)
(*     "                        movq " ^ string_of_int field_offset ^ "(%r13), %r13" *)

let codegen context tac =
  let class_name = context.class_name in
  let method_name = context.method_name in
  let class_attrs = context.class_attributes in


  match tac with
  | TAC_Comment text -> [ "                        ## " ^ text ]
  | TAC_Label label -> [ ".globl " ^ label; label ^ ":" ]

 
(* For field assignment from a temporary *)

| TAC_Assign_Variable (dest, src) ->
      let dest_offset = lookup_offset context dest in
      if String.length src >= 2 && (String.sub src 0 2) = "t$" then
        let src_offset = lookup_offset context src in
        [ "                        movq " ^ string_of_int src_offset ^ "(%rbp), %r13";
          "                        movq %r13, " ^ string_of_int dest_offset ^ "(%rbp)" ]
      else
        (* The source is a field name. Look up its offset from the class_attributes,
           then load from the self object in %r12. *)
        let field_offset = lookup_field_offset context src in

        [ "                        ## " ^ src;
          "                        movq " ^ string_of_int field_offset ^ "(%r12), %r13";

          (* "                        movq " ^ string_of_int field_offset ^ "(%r13), %r13"; *)
          "                        movq %r13, " ^ string_of_int dest_offset ^ "(%rbp)" ] 
    | TAC_Assign_Int (dest, value) ->
    let dest_offset = lookup_offset context dest in
    [ "                        ## new Int"
    ; "                        pushq %rbp"
    ; "                        pushq %r12"
    ; "                        movq $Int..new, %r14"
    ; "                        call *%r14"
    ; "                        popq %r12"
    ; "                        popq %rbp"
    ; "                        movq $" ^ string_of_int value ^ ", %r14"
    ; "                        movq %r14, 24(%r13)"   (* Store the integer literal into the new Int object *)
    ; "                        movq 24(%r13), %r13" 
    ; "                        movq %r13," ^ string_of_int dest_offset ^ "(%rbp)"
        ]
| TAC_Assign_String (dest, value) ->
    let string_label = get_string_label value in
    (* Compute where dest should be stored using lookup_offset *)
    let dest_offset = lookup_offset context dest in
    [ "                         ## new String";
      "                         pushq %rbp";
      "                         pushq %r12";
      "                         movq $String..new, %r14";
      "                         call *%r14";
      "                         popq %r12";
      "                         popq %rbp";
      (Printf.sprintf "                         ## %s holds \"%s\"" string_label value);
      (Printf.sprintf "                         movq $%s, %%r14" string_label);
      "                         movq %r14, 24(%r13)";  (* Store string pointer into String object *)
      "                         movq %r13, " ^ string_of_int dest_offset ^ "(%rbp)" (* Store String object in destination *)

    ]
 (* TAC_Assign_Plus: Add two operands and store result in dest *)
| TAC_Assign_Plus (dest, e1, e2) ->
    let op1 = tac_expr_to_string e1 in
    let op2 = tac_expr_to_string e2 in
    let dest_offset = lookup_offset context dest in
        [
            (* Load t$0 from stack into %r13, then unbox its int value *)
            "                        movq " ^ string_of_int (lookup_offset context op1) ^ "(%rbp), %r13";

            (* Load t$1 from stack into %r14, then unbox its int value *)
            "                        movq " ^ string_of_int (lookup_offset context op2) ^ "(%rbp), %r14";

            (* Add: r13 = r13 + r14 *)
            "                        addq %r14, %r13";
            "                        movq %r13, " ^ string_of_int dest_offset ^ "(%rbp)";

            "                        ## new Int";
            "                        pushq %rbp";
            "                        pushq %r12";
            "                        movq $Int..new, %r14";
            "                        call *%r14";
            "                        popq %r12";
            "                        popq %rbp";
            "                        movq "  ^ string_of_int dest_offset ^ "(%rbp), %r14";
            "                        movq %r14, 24(%r13)";
            "                        movq 24(%r13), %r13";
            "                        movq %r13, "  ^ string_of_int dest_offset ^ "(%rbp)";
        ]
    | TAC_Return r ->
        [""]

(* For TAC_Call *)
| TAC_Call (dest, method_name, args) ->
    let call_setup = [
      "                        ## " ^ method_name ^ "(...)";
      "                        pushq %r12";
      "                        pushq %rbp"
    ] in
    
    (* For each argument, directly access the field if it's a field name *)
    let arg_pushes = List.fold_left (fun acc arg ->
      if String.length arg >= 2 && (String.sub arg 0 2) = "t$" then
        let arg_offset = lookup_offset context arg in
        acc @ [
          "                        ## " ^ arg;
          "                        movq " ^ string_of_int arg_offset ^ "(%rbp), %r13";
          "                        pushq %r13"
        ]
      else
        let field_offset = lookup_field_offset context arg in
        acc @ [
          "                        ## " ^ arg;
          "                        movq " ^ string_of_int field_offset ^ "(%r12), %r13";
          "                        pushq %r13"
        ]
    ) [] args in
    
   let call_and_cleanup = 
  (* Look up the method's offset from the vtable_offsets *)
  let method_offset =
    try 
      Hashtbl.find vtable_offsets (class_name, method_name)
    with Not_found ->
      failwith ("Method not found in vtable: " ^ class_name ^ "." ^ method_name)
  in
  [
    "                        pushq %r12";
    "                        ## obtain vtable for self object of type " ^ class_name;
    "                        movq 16(%r12), %r14";
    "                        ## look up " ^ method_name ^ "() at offset " ^ string_of_int (method_offset / 8) ^ " in vtable";
    "                        movq " ^ string_of_int method_offset ^ "(%r14), %r14";
    "                        call *%r14";
    "                        addq $" ^ string_of_int ((List.length args + 1) * 8) ^ ", %rsp";
    "                        popq %rbp";
    "                        popq %r12"
  ]in
    
    (* Store result if needed *)
    let store_result = 
      if dest <> "" then
        let dest_offset = lookup_offset context dest in
        ["                        movq %r13, " ^ string_of_int dest_offset ^ "(%rbp)"]
      else
        []
    in
    
    call_setup @ arg_pushes @ call_and_cleanup @ store_result    (* | TAC_Assign_Minus  *)
  (* | TAC_Assign_Times *)
  (* | TAC_Assign_Divide  *)
  (* | TAC_Assign_Bool *)
  (* | TAC_Assign_Lt *)
  (* | TAC_Assign_Le *)
  (* | TAC_Assign_Not *)
  (* | TAC_Assign_Negate  *)
  (* | TAC_Assign_IsVoid of string * tac_expr *)
  (* | TAC_Assign_New of string * tac_expr *)
  (* | TAC_Assign_Call of string * tac_expr *)
  (* | TAC_Assign_Eq of string * tac_expr * tac_expr *)
  (* | TAC_Label of string (* label L1 *) *)
  (* | TAC_Jump of string (* jmp L1 *) *)
  (* | TAC_ConditionalJump of string * string (* bt x L2 *) *)
  (* | TAC_Return of string *)
  (* | TAC_Assign of string * tac_expr *)
  (* | TAC_Call of string * string * string list *)
  (* | TAC_StaticCall of string * string * string * string list *)
  (* | TAC_New of string * string *)
  (* | TAC_IsVoid of string * string *)
  (* | TAC_Compare of string * string * string * string *)
  (* | TAC_Not of string * string *)
  (* | TAC_Negate of string * string *)
  (* | TAC_Comment of string *)
  (* | TAC_Assign_Default of string * string *)
  (**)

 | x -> failwith ("no asm for tac instr: " ^ tac_instr_to_str tac ^ "\n")

let constructor_codegen tac =
  match tac with
  | TAC_Comment text -> [ "                        ## " ^ text ]
  | TAC_Label label -> [ ".globl " ^ label; label ^ ":" ]
  | TAC_Assign_Int (dest, value) ->
      [
        "                        ## new Int";
        "                        pushq %rbp";
        "                        pushq %r12";
        "                        movq $Int..new, %r14";
        "                        call *%r14";
        "                        popq %r12";
        "                        popq %rbp";
        "                        movq $" ^ string_of_int value ^ ", %r14";
        "                        movq %r14, 24(%r13)";
      ]
  | TAC_Assign_Variable (dest, src) ->
      (* Simply load the source value and store it into the destination. *)
      [
        "                        ## Copy variable " ^ src ^ " to " ^ dest;
        ]
 | TAC_Assign_String (dest, value) ->
      let string_label = get_string_label value in
      [
        "                        ## new String";
        "                        pushq %rbp";
        "                        pushq %r12";
        "                        movq $String..new, %r14";
        "                        call *%r14";
        "                        popq %r12";
        "                        popq %rbp";
        "                        ## " ^ string_label ^ " holds \"" ^ value
        ^ "\"";
        "                        movq $" ^ string_label ^ ", %r14";
        "                        movq %r14, 24(%r13)";
      ]
  
  (* | TAC_Assign_Plus (dest, op1, op2) -> *)
  (*     let op1 = tac_expr_to_string op1 in *)
  (*     let op2 = tac_expr_to_string op2 in *)
  (*     [ *)
  (*       "                        ## Compute " ^ op1 ^ " + " ^ op2 *)
  (*       ^ " and store in " ^ dest; *)
  (*       "                        ## Load first operand (" ^ op1 ^ ")"; *)
  (*     ] *)
  (*     @ [ generate_load op1 ] *)
  (*     @ [ *)
  (*         "                        movq " ^ target_reg ^ ", " ^ temp_reg *)
  (*         ^ "    ## Save operand 1 in " ^ temp_reg; *)
  (*         "                        ## Load second operand (" ^ op2 ^ ")"; *)
  (*       ] *)
  (*     @ [ generate_load op2 ] *)
  (*     @ [ *)
  (*         "                        addq " ^ temp_reg ^ ", " ^ target_reg *)
  (*         ^ "    ## Add the two operands"; *)
  (*         "                        ## Box the raw addition result into a new \ *)
  (*          Int object"; *)
  (*       ] *)
  (*     @ [ *)
  (*         "                        ## Store boxed result into " ^ dest; *)
  (*         generate_store target_reg dest; *)
  (*       ] *)
  (* | TAC_Assign_Minus (dest, op1, op2) -> *)
  (*     let op1 = tac_expr_to_string op1 in *)
  (*     let op2 = tac_expr_to_string op2 in *)
  (**)
  (*     [ *)
  (*       "                        ## Compute " ^ op1 ^ " - " ^ op2 *)
  (*       ^ " and store in " ^ dest; *)
  (*       "                        ## Load first operand (" ^ op1 ^ ")"; *)
  (*     ] *)
  (*     @ [ generate_load op1 ] *)
  (*     @ [ *)
  (*         "                        movq " ^ target_reg ^ ", " ^ temp_reg *)
  (*         ^ "    ## Save operand 1 in " ^ temp_reg; *)
  (*         "                        ## Load second operand (" ^ op2 ^ ")"; *)
  (*       ] *)
  (*     @ [ generate_load op2 ] *)
  (*     @ [ *)
  (*         "                        subq " ^ target_reg ^ ", " ^ temp_reg *)
  (*         ^ "    ## Subtract operand 2 from operand 1"; *)
  (*         "                        movq " ^ temp_reg ^ ", " ^ target_reg *)
  (*         ^ "    ## Move the result into " ^ target_reg; *)
  (*         "                        ## Box the result into a new Int object"; *)
  (*       ] *)
  (*     @ [ *)
  (*         "                        ## Store boxed result into " ^ dest; *)
  (*         generate_store target_reg dest; *)
  (*       ] *)
  (* | TAC_Assign_Times (dest, op1, op2) -> *)
  (*     [ *)
  (*       "                        ## multiplying " ^ tac_expr_to_string op1 *)
  (*       ^ " and " ^ tac_expr_to_string op2; *)
  (*       (* Load first operand *) *)
  (*       generate_load (tac_expr_to_string op1); *)
  (*       "                        movq %r13, -8(%rbp)"; *)
  (*       (* Use explicit stack location *) *)
  (*       (* Load second operand *) *)
  (*       generate_load (tac_expr_to_string op2); *)
  (*       "                        movq -8(%rbp), %rax"; *)
  (*       (* Load from specific location *) *)
  (*       "                        imulq %r13, %rax"; *)
  (*       "                        movq %rax, %r13"; *)
  (*       (* Need to box the result *) *)
  (*       "                        ## Box the multiplication result into a new \ *)
  (*        Int object"; *)
  (*     ] *)
  (*     @ [ *)
  (*         "                        ## Store boxed result into " ^ dest; *)
  (*         generate_store target_reg dest; *)
  (*       ] *)
  (* | TAC_Assign_Divide (dest, op1, op2) -> *)
  (*   let div_ok_label = "l" ^ string_of_int (Random.int 10000) in (* Generate unique label *) *)
  (*   [ *)
  (*     (* Load operands *) *)
  (*     generate_load (tac_expr_to_string op1); *)
  (*     "                        movq %r13, -8(%rbp)"; *)
  (*     generate_load (tac_expr_to_string op2); *)
  (*     "                        movq 24(%r13), %r14"; *)
  (*     "                        cmpq $0, %r14"; *)
  (*     "                        jne " ^ div_ok_label; *)
  (*     (* Division by zero handling *) *)
  (*     "                        movq $string8, %r13"; *)
  (*     "                        andq $0xFFFFFFFFFFFFFFF0, %rsp"; *)
  (*     "                        movq %r13, %rdi"; *)
  (*     "                        call cooloutstr"; *)
  (*     "                        andq $0xFFFFFFFFFFFFFFF0, %rsp"; *)
  (*     "                        movl $0, %edi"; *)
  (*     "                        call exit"; *)
  (*     (* Division code *) *)
  (*     ".globl " ^ div_ok_label; *)
  (*     div_ok_label ^ ":                     ## division is OK"; *)
  (*     "                        movq 24(%r13), %r13"; *)
  (*     "                        movq -8(%rbp), %r14"; *)
  (*     "                        movq $0, %rdx"; *)
  (*     "                        movq %r14, %rax"; *)
  (*     "                        cdq"; *)
  (*     "                        idivl %r13d"; *)
  (*     "                        movq %rax, %r13"; *)
  (*     (* Box the result *) *)
  (*   ] *)
  (*   @ [ *)
  (*       "                        ## Store boxed result into " ^ dest; *)
  (*       generate_store target_reg dest; *)
  (*     ] *)
  | TAC_Assign_Bool (dest, b) ->
      [
        ("                        ## assigning boolean "
        ^
        if b then
          "true"
        else
          "false");
        "                        ## new Bool";
        "                        pushq %rbp";
        "                        pushq %r12";
        "                        pushq %r13";
        "                        pushq %r14";
        "                        movq $Bool..new, %r14";
        "                        call *%r14";
        "                        popq %r14";
        "                        popq %r13";
        "                        popq %r12";
        "                        popq %rbp";
        "                        movq $"
        ^ (if b then
             "1"
           else
             "0")
        ^ ", %r14";
        "                        movq %r14, 24(%r13)";
      ]
   | x -> failwith ("constructor error" ^ tac_instr_to_str x)

(* Helper function to record an explicitly initialized field *)
let record_explicit_initializer class_name field_name =
  let fields = 
    try Hashtbl.find explicitly_initialized_fields class_name
    with Not_found -> Hashtbl.create 10
  in
  Hashtbl.replace fields field_name true;
  Hashtbl.replace explicitly_initialized_fields class_name fields

    (* Debug function to print all explicitly initialized fields *)
let print_explicitly_initialized_fields () =
  print_endline "\n====== EXPLICITLY INITIALIZED FIELDS ======";
  
  (* Extract all class names *)
  let class_names = 
    Hashtbl.fold 
      (fun class_name _ acc -> class_name :: acc) 
      explicitly_initialized_fields 
      []
  in
  
  (* Sort class names for consistent output *)
  let sorted_class_names = List.sort String.compare class_names in
  
  if List.length sorted_class_names = 0 then
    print_endline "  No classes with explicitly initialized fields found."
  else
    List.iter 
      (fun class_name ->
        let fields = Hashtbl.find explicitly_initialized_fields class_name in
        let field_names = 
          Hashtbl.fold 
            (fun field_name _ acc -> field_name :: acc) 
            fields 
            []
        in
        let sorted_field_names = List.sort String.compare field_names in
        
        print_endline ("  Class: " ^ class_name);
        if List.length sorted_field_names = 0 then
          print_endline "    No explicitly initialized fields."
        else
          List.iter 
            (fun field_name ->
              print_endline ("    - " ^ field_name))
            sorted_field_names;
      ) 
      sorted_class_names;
  
  print_endline "============================================\n"

(* Generate constructor for user-defined classes *)
let generate_custom_constructor class_map class_name
    (attributes : (string * string * exp option) list) =
  let constructor_label = class_name ^ "..new" in
  let class_tag = get_class_tag class_name in
  (* object size: 3 words (for tag, size, vtable) plus one word per attribute *)
  let object_size = 3 + List.length attributes in
  let vtable_label = class_name ^ "..vtable" in

  (* Record explicitly initialized fields *)
  List.iter 
    (fun (attr_name, _, init_opt) -> 
      match init_opt with
      | Some _ -> record_explicit_initializer class_name attr_name
      | None -> ())
    attributes;

  let base_lines =
    [
      "                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;";
      ".globl " ^ constructor_label;
      constructor_label ^ ":              ## constructor for " ^ class_name;
      "                        pushq %rbp";
      "                        movq %rsp, %rbp";
      "                        ## stack room for temporaries: 2";
      "                        movq $16, %r14";
      "                        subq %r14, %rsp";
      "                        ## return address handling";
      "                        movq $" ^ string_of_int object_size ^ ", %r12";
      "\t\t\t## guarantee 16-byte alignment before call";
      "\t\t\tandq $0xFFFFFFFFFFFFFFF0, %rsp";
      "\t\t\tmovq $8, %rsi";
      "\t\t\tmovq %r12, %rdi";
      "\t\t\tcall calloc";
      "\t\t\tmovq %rax, %r12";
      "\t\t\t## store class tag, object size and vtable pointer";
      "                        movq $" ^ string_of_int class_tag ^ ", %r14";
      "                        movq %r14, 0(%r12)";
      "                        movq $" ^ string_of_int object_size ^ ", %r14";
      "                        movq %r14, 8(%r12)";
      "                        movq $" ^ vtable_label ^ ", %r14";
      "                        movq %r14, 16(%r12)";
    ]
  in
  (* Generate initialization code for each attribute.
   The first attribute is stored at offset 24, the second at 32, etc.
   For each attribute, if an initializer is provided, generate code to evaluate it;
   otherwise, call the default constructor for the attribute’s type. *)
  (* Step 1: Generate default initialization code for all attributes *)

  let default_init_lines =
    List.mapi
      (fun idx (attr_name, attr_type, _) ->
        let offset = 24 + (idx * 8) in
        [
          "                        ## initialize attributes";
          "                        ## self["
          ^ string_of_int (idx + 3)
          ^ "] holds field " ^ attr_name ^ " (" ^ attr_type ^ ")";
          "                        ## new " ^ attr_type;
          "                        pushq %rbp";
          "                        pushq %r12";
          "                        movq $" ^ attr_type ^ "..new, %r14";
          "                        call *%r14";
          "                        popq %r12";
          "                        popq %rbp";
          "                        movq %r13, " ^ string_of_int offset
          ^ "(%r12)";
        ])
      attributes
    |> List.flatten
  in

  (* Step 2: Generate initialization code for attributes with initializers *)
  let initializer_lines =
    List.mapi
      (fun idx (attr_name, attr_type, init_opt) ->
        let offset = 24 + (idx * 8) in
        (* Generate initializer code only if there's an initializer *)
        match init_opt with
        | None ->
            (* For attributes with no initializer, add a comment *)
            [
              "                        ## self["
              ^ string_of_int (idx + 3)
              ^ "] " ^ attr_name ^ " initializer -- none ";
            ]
        | Some expr ->
            let initial_env = Hashtbl.create 10 in
            let tac_instrs, tac_result, _final_env =
              convert class_name "<init>" initial_env expr
            in

            (* Add comment about initializer *)
            let init_header =
              [
                ("                        ## self["
                ^ string_of_int (idx + 3)
                ^ "] " ^ attr_name ^ " initializer <- "
                ^
                match expr.exp_kind with
                | AST_String s -> "\"" ^ s ^ "\""
                | AST_Integer i -> i
                | AST_True -> "true"
                | AST_False -> "false"
                | _ -> tac_expr_to_string tac_result);
              ]
            in

            (* Generate code for the initializer value *)
            let init_code = List.concat_map constructor_codegen tac_instrs in

            (* Store initialized object in the right field *)
            let store_init =
              [
                "                        movq %r13, " ^ string_of_int offset
                ^ "(%r12)";
              ]
            in

            init_header @ init_code @ store_init)
      attributes
    |> List.flatten
  in

  let footer =
    [
      "                        movq %r12, %r13";
      "                        ## return address handling";
      "                        movq %rbp, %rsp";
      "                        popq %rbp";
      "                        ret";
    ]
  in

  base_lines @ default_init_lines @ initializer_lines @ footer

(* Generate constructors for all classes.
   For internal classes, call a separate internal constructor generator.
   For user-defined classes, extract the full attribute triple list from the class map. *)

let generate_constructors (class_order : string list) (class_map : class_map) =
  List.concat_map
    (fun class_name ->
      match class_name with
      | "Bool" | "Int" | "IO" | "Object" | "String" ->
          generate_internal_constructor class_name
      | _ ->
          let attributes, _ =
            try Hashtbl.find class_map class_name with Not_found -> ([], [])
          in
          generate_custom_constructor class_map class_name attributes)
    class_order

(* Returns a list of (field_name, field_type, index) for the given class,
   merging inherited and direct attributes while avoiding duplicates.
    inherited attributes come first.
*)
let rec get_class_attributes
    (class_map : (string, (string * string * exp option) list * 'a) Hashtbl.t)
    (parent_map : (string, string) Hashtbl.t) (class_name : string) :
    (string * string * int) list =
  (* Get inherited attributes, if any *)
  let inherited =
    match Hashtbl.find_opt parent_map class_name with
    | Some parent -> get_class_attributes class_map parent_map parent
    | None -> []
  in
  (* Build a set/list of inherited attribute names to avoid duplicates *)
  let inherited_names = List.map (fun (name, _, _) -> name) inherited in
  (* For the direct attributes of this class, filter out ones that are inherited *)
  let direct =
    try
      let attrs, _ = Hashtbl.find class_map class_name in
      List.filter
        (fun (attr_name, _attr_type, _init_opt) ->
          not (List.mem attr_name inherited_names))
        attrs
      |> List.mapi (fun i (attr_name, attr_type, _init_opt) ->
             (attr_name, attr_type, List.length inherited + i + 3))
    with Not_found -> []
  in
  inherited @ direct

(* Generate method definition assembly code *)
let generate_method_definition class_name method_name params return_type body
    class_map parent_map =
  let method_label = class_name ^ "." ^ method_name in

      let attributes = get_class_attributes class_map parent_map class_name in
  (* Retrieve the attributes for the class dynamically.
     The get_class_attributes function returns a list of (field_name, field_type, index)
     for the given class (including inherited fields). *)
  let attributes_comments =
    List.map
      (fun (field_name, field_type, index) ->
        "                        ## self[" ^ string_of_int index
        ^ "] holds field " ^ field_name ^ " (" ^ field_type ^ ")")
      attributes
  in 

  reset_temp_var_counter ();
  reset_label_counter ();
  reset_newloc_counter ();

  (* Create an initial environment for the method.
     Here, 'params' is a string list (the first component from impl_map).
     We iterate over this list and allocate a fresh location for each parameter. *)
  let initial_env = Hashtbl.create 10 in
  let param_locs = List.map
    (fun param ->
      let loc = newloc () in
      Hashtbl.add initial_env param loc;
      (param, loc))
    params
  in  (*Convert method body to TAC instructions*)
  let tac_instrs, final_expr, _ =
    convert class_name method_name initial_env body
  in



  let temp_count = get_temp_var_count () in
  (* Calculate the stack space needed (8 bytes per temporary) 
     Ensure it's 16-byte aligned by rounding up to the next multiple of 16 *)
  let stack_space = ((temp_count * 8) + 15) / 16 * 16 in

  (* Build the full header dynamically *)
  let header =
    [
      "                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;";
      ".globl " ^ method_label;
      method_label ^ ":           ## method definition";
      "                        pushq %rbp";
      "                        movq %rsp, %rbp";
      "                        movq 16(%rbp), %r12";
      "                        ## stack room for temporaries: "
      ^ string_of_int temp_count;
      "                        movq $" ^ string_of_int stack_space ^ ", %r14";
      "                        subq %r14, %rsp";
      "                        ## return address handling";
    ]
    @ attributes_comments
    @ [ "                        ## method body begins" ]
  in

  (*     It returns a triple: (TAC instructions, result TAC expression, updated environment). *)
  let return_var = match final_expr with TAC_Variable v -> v | _ -> "t$0" in
  let tac_with_return = tac_instrs @ [ TAC_Return return_var ] in
  (* Translate the generated TAC instructions into assembly instructions *)
  let leaders = identify_leaders tac_instrs in
  let basic_blocks = create_basic_blocks tac_with_return leaders in
  let cfg = build_cfg basic_blocks in

  print_cfg cfg;

(* Create codegen context with all necessary information *)
  let context = {
    class_attributes = attributes;
    temp_vars = [];  (* This would be populated based on variable tracking *)
    params = param_locs;
    class_name = class_name;
    method_name = method_name;
  } in
    let debug_print_context context =
  Printf.printf "=== DEBUG CONTEXT ===\n";
  Printf.printf "Class: %s, Method: %s\n" context.class_name context.method_name;
  
  Printf.printf "Class attributes (%d):\n" (List.length context.class_attributes);
  List.iter (fun (field_name, field_type, index) ->
    Printf.printf "  [%d] %s: %s\n" index field_name field_type
  ) context.class_attributes;
  
  Printf.printf "Parameters (%d):\n" (List.length context.params);
  List.iter (fun (param_name, loc) ->
    Printf.printf "  %s: loc %d\n" param_name loc
  ) context.params;
  
  flush stdout in

let ()= debug_print_context context in

  (* Generate assembly for each basic block *)
  let body_asm =
    Hashtbl.fold
      (fun _ block acc ->
        let block_comment = ["                        ## Basic block: " ^ block.id] in
        let block_code = 
          List.concat (List.map (fun instr -> codegen context instr) block.instructions)
        in
        acc @ block_comment @ block_code)
      cfg []
  in
  (* Method epilogue *)
  let epilogue =
    [
      ".globl " ^ method_label ^ ".end";
      method_label ^ ".end:       ## method body ends";
      "                        ## return address handling";
      "                        movq %rbp, %rsp";
      "                        popq %rbp";
      "                        ret";
      "                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;";
    ]
  in

  header @ body_asm @ epilogue

let generate_all_method_definitions class_map impl_map parent_map defining_order
    =
  (* defined_methods tracks which methods have been generated already *)
  (* List.iter *)
  (*   (fun (cname, mname) -> Printf.printf "Class: %s, Method: %s\n" cname mname) *)
  (*   defining_order; *)
  let defined_methods = Hashtbl.create 100 in
  List.fold_left
    (fun acc (class_name, method_name) ->
      let method_label = class_name ^ "." ^ method_name in
      if Hashtbl.mem defined_methods method_label then
        acc
      (* skip duplicate *)
      else (
        Hashtbl.add defined_methods method_label true;
        let method_def =
          match (class_name, method_name) with
          | "Object", "abort" -> generate_object_abort_method ()
          | "Object", "copy" -> generate_object_copy_method ()
          | "Object", "type_name" -> generate_object_type_name_method ()
          | "IO", "in_int" -> generate_io_in_int_method ()
          | "IO", "in_string" -> generate_io_in_string_method ()
          | "IO", "out_int" -> generate_io_out_int_method ()
          | "IO", "out_string" -> generate_io_out_string_method ()
          | "String", "concat" -> generate_string_concat_method ()
          | "String", "length" -> generate_string_length_method ()
          | "String", "substr" -> generate_string_substr_method ()
          | _ -> (
              (* For non-native methods, retrieve parameters, return type, defining class, and method body *)
              match Hashtbl.find_opt impl_map (class_name, method_name) with
              | Some (params, return_type, defining_class, body_exp) ->
                  if class_name = defining_class then
                    generate_method_definition class_name method_name params
                      return_type body_exp class_map parent_map
                  else
                    []
                    (* skip inherited methods *)
              | None -> [])
        in
        acc @ method_def))
    [] defining_order

(* Function to generate assembly for a single string *)
let generate_string_entry (label, literal) =
  let bytes =
    literal |> String.to_seq
    |> Seq.map (fun c ->
           Printf.sprintf ".byte %d\t# '%s'" (Char.code c) (Char.escaped c))
    |> List.of_seq
  in
  [
    Printf.sprintf ".globl %s" label;
    Printf.sprintf "%s:\t\t\t  # \"%s\"" label literal;
  ]
  @ bytes @ [ ".byte 0\t"; "\n" ]

(* Generate all string literals as assembly *)
let generate_string_literals () =
  (* Header *)
  let lines =
    ref
      [
        "                       ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;";
        "                       ## global string constants";
      ]
  in

  (* Base strings *)
  List.iter
    (fun (label, literal) ->
      lines := !lines @ generate_string_entry (label, literal))
    base_strings;

  (* Get the real list in correct order and process each string *)
  let entries = List.rev !string_literal_list in
  List.iter
    (fun (label, literal) ->
      lines := !lines @ generate_string_entry (label, literal))
    entries;

  !lines

(* Utility function to print the string label map for debugging *)
let print_string_label_map () =
  Printf.printf "---- String Label Map ----\n";
  Hashtbl.iter
    (fun literal label -> Printf.printf "  \"%s\" -> %s\n" literal label)
    string_label_map;
  Printf.printf "--------------------------\n"

(* Utility function to print the string literal list *)
let print_string_literal_list () =
  Printf.printf "---- String Literal List (registration order) ----\n";
  List.iter
    (fun (label, literal) -> Printf.printf "  %s -> \"%s\"\n" label literal)
    (List.rev !string_literal_list);
  Printf.printf "------------------------------------------------\n"

let generate_helper_functions_and_entry () =
  [
    "                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;";
    ".globl eq_handler";
    "eq_handler:             ## helper function for =";
    "                        pushq %rbp";
    "                        movq %rsp, %rbp";
    "                        movq 32(%rbp), %r12";
    "                        ## return address handling";
    "                        movq 32(%rbp), %r13";
    "                        movq 24(%rbp), %r14";
    "                        cmpq %r14, %r13";
    "\t\t\tje eq_true";
    "                        movq $0, %r15";
    "                        cmpq %r15, %r13";
    "\t\t\tje eq_false";
    "                        cmpq %r15, %r14";
    "\t\t\tje eq_false";
    "                        movq 0(%r13), %r13";
    "                        movq 0(%r14), %r14";
    "                        ## place the sum of the type tags in r1";
    "                        addq %r14, %r13";
    "                        movq $0, %r14";
    "                        cmpq %r14, %r13";
    "\t\t\tje eq_bool";
    "                        movq $2, %r14";
    "                        cmpq %r14, %r13";
    "\t\t\tje eq_int";
    "                        movq $6, %r14";
    "                        cmpq %r14, %r13";
    "\t\t\tje eq_string";
    "                        ## otherwise, use pointer comparison";
    "                        movq 32(%rbp), %r13";
    "                        movq 24(%rbp), %r14";
    "                        cmpq %r14, %r13";
    "\t\t\tje eq_true";
    ".globl eq_false";
    "eq_false:               ## not equal";
    "                        ## new Bool";
    "                        pushq %rbp";
    "                        pushq %r12";
    "                        movq $Bool..new, %r14";
    "                        call *%r14";
    "                        popq %r12";
    "                        popq %rbp";
    "                        jmp eq_end";
    ".globl eq_true";
    "eq_true:                ## equal";
    "                        ## new Bool";
    "                        pushq %rbp";
    "                        pushq %r12";
    "                        movq $Bool..new, %r14";
    "                        call *%r14";
    "                        popq %r12";
    "                        popq %rbp";
    "                        movq $1, %r14";
    "                        movq %r14, 24(%r13)";
    "                        jmp eq_end";
    ".globl eq_bool";
    "eq_bool:                ## two Bools";
    ".globl eq_int";
    "eq_int:                 ## two Ints";
    "                        movq 32(%rbp), %r13";
    "                        movq 24(%rbp), %r14";
    "                        movq 24(%r13), %r13";
    "                        movq 24(%r14), %r14";
    "                        cmpq %r14, %r13";
    "\t\t\tje eq_true";
    "                        jmp eq_false";
    ".globl eq_string";
    "eq_string:              ## two Strings";
    "                        movq 32(%rbp), %r13";
    "                        movq 24(%rbp), %r14";
    "                        movq 24(%r13), %r13";
    "                        movq 24(%r14), %r14";
    "                        ## guarantee 16-byte alignment before call";
    "\t\t\tandq $0xFFFFFFFFFFFFFFF0, %rsp";
    "\t\t\tmovq %r13, %rdi";
    "\t\t\tmovq %r14, %rsi";
    "\t\t\tcall strcmp ";
    "\t\t\tcmp $0, %eax";
    "\t\t\tje eq_true";
    "                        jmp eq_false";
    ".globl eq_end";
    "eq_end:                 ## return address handling";
    "                        movq %rbp, %rsp";
    "                        popq %rbp";
    "                        ret";
    "                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;";
    ".globl le_handler";
    "le_handler:             ## helper function for <=";
    "                        pushq %rbp";
    "                        movq %rsp, %rbp";
    "                        movq 32(%rbp), %r12";
    "                        ## return address handling";
    "                        movq 32(%rbp), %r13";
    "                        movq 24(%rbp), %r14";
    "                        cmpq %r14, %r13";
    "\t\t\tje le_true";
    "                        movq $0, %r15";
    "                        cmpq %r15, %r13";
    "\t\t\tje le_false";
    "                        cmpq %r15, %r14";
    "\t\t\tje le_false";
    "                        movq 0(%r13), %r13";
    "                        movq 0(%r14), %r14";
    "                        ## place the sum of the type tags in r1";
    "                        addq %r14, %r13";
    "                        movq $0, %r14";
    "                        cmpq %r14, %r13";
    "\t\t\tje le_bool";
    "                        movq $2, %r14";
    "                        cmpq %r14, %r13";
    "\t\t\tje le_int";
    "                        movq $6, %r14";
    "                        cmpq %r14, %r13";
    "\t\t\tje le_string";
    "                        ## for non-primitives, equality is our only hope";
    "                        movq 32(%rbp), %r13";
    "                        movq 24(%rbp), %r14";
    "                        cmpq %r14, %r13";
    "\t\t\tje le_true";
    ".globl le_false";
    "le_false:               ## not less-than-or-equal";
    "                        ## new Bool";
    "                        pushq %rbp";
    "                        pushq %r12";
    "                        movq $Bool..new, %r14";
    "                        call *%r14";
    "                        popq %r12";
    "                        popq %rbp";
    "                        jmp le_end";
    ".globl le_true";
    "le_true:                ## less-than-or-equal";
    "                        ## new Bool";
    "                        pushq %rbp";
    "                        pushq %r12";
    "                        movq $Bool..new, %r14";
    "                        call *%r14";
    "                        popq %r12";
    "                        popq %rbp";
    "                        movq $1, %r14";
    "                        movq %r14, 24(%r13)";
    "                        jmp le_end";
    ".globl le_bool";
    "le_bool:                ## two Bools";
    ".globl le_int";
    "le_int:                 ## two Ints";
    "                        movq 32(%rbp), %r13";
    "                        movq 24(%rbp), %r14";
    "                        movq 24(%r13), %r13";
    "                        movq 24(%r14), %r14";
    "                        cmpl %r14d, %r13d";
    "\t\t\tjle le_true";
    "                        jmp le_false";
    ".globl le_string";
    "le_string:              ## two Strings";
    "                        movq 32(%rbp), %r13";
    "                        movq 24(%rbp), %r14";
    "                        movq 24(%r13), %r13";
    "                        movq 24(%r14), %r14";
    "                        ## guarantee 16-byte alignment before call";
    "\t\t\tandq $0xFFFFFFFFFFFFFFF0, %rsp";
    "\t\t\tmovq %r13, %rdi";
    "\t\t\tmovq %r14, %rsi";
    "\t\t\tcall strcmp ";
    "\t\t\tcmp $0, %eax";
    "\t\t\tjle le_true";
    "                        jmp le_false";
    ".globl le_end";
    "le_end:                 ## return address handling";
    "                        movq %rbp, %rsp";
    "                        popq %rbp";
    "                        ret";
    "                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;";
    ".globl lt_handler";
    "lt_handler:             ## helper function for <";
    "                        pushq %rbp";
    "                        movq %rsp, %rbp";
    "                        movq 32(%rbp), %r12";
    "                        ## return address handling";
    "                        movq 32(%rbp), %r13";
    "                        movq 24(%rbp), %r14";
    "                        movq $0, %r15";
    "                        cmpq %r15, %r13";
    "\t\t\tje lt_false";
    "                        cmpq %r15, %r14";
    "\t\t\tje lt_false";
    "                        movq 0(%r13), %r13";
    "                        movq 0(%r14), %r14";
    "                        ## place the sum of the type tags in r1";
    "                        addq %r14, %r13";
    "                        movq $0, %r14";
    "                        cmpq %r14, %r13";
    "\t\t\tje lt_bool";
    "                        movq $2, %r14";
    "                        cmpq %r14, %r13";
    "\t\t\tje lt_int";
    "                        movq $6, %r14";
    "                        cmpq %r14, %r13";
    "\t\t\tje lt_string";
    "                        ## for non-primitives, < is always false";
    ".globl lt_false";
    "lt_false:               ## not less than";
    "                        ## new Bool";
    "                        pushq %rbp";
    "                        pushq %r12";
    "                        movq $Bool..new, %r14";
    "                        call *%r14";
    "                        popq %r12";
    "                        popq %rbp";
    "                        jmp lt_end";
    ".globl lt_true";
    "lt_true:                ## less than";
    "                        ## new Bool";
    "                        pushq %rbp";
    "                        pushq %r12";
    "                        movq $Bool..new, %r14";
    "                        call *%r14";
    "                        popq %r12";
    "                        popq %rbp";
    "                        movq $1, %r14";
    "                        movq %r14, 24(%r13)";
    "                        jmp lt_end";
    ".globl lt_bool";
    "lt_bool:                ## two Bools";
    ".globl lt_int";
    "lt_int:                 ## two Ints";
    "                        movq 32(%rbp), %r13";
    "                        movq 24(%rbp), %r14";
    "                        movq 24(%r13), %r13";
    "                        movq 24(%r14), %r14";
    "                        cmpl %r14d, %r13d";
    "\t\t\tjl lt_true";
    "                        jmp lt_false";
    ".globl lt_string";
    "lt_string:              ## two Strings";
    "                        movq 32(%rbp), %r13";
    "                        movq 24(%rbp), %r14";
    "                        movq 24(%r13), %r13";
    "                        movq 24(%r14), %r14";
    "                        ## guarantee 16-byte alignment before call";
    "\t\t\tandq $0xFFFFFFFFFFFFFFF0, %rsp";
    "\t\t\tmovq %r13, %rdi";
    "\t\t\tmovq %r14, %rsi";
    "\t\t\tcall strcmp ";
    "\t\t\tcmp $0, %eax";
    "\t\t\tjl lt_true";
    "                        jmp lt_false";
    ".globl lt_end";
    "lt_end:                 ## return address handling";
    "                        movq %rbp, %rsp";
    "                        popq %rbp";
    "                        ret";
    "                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;";
    ".globl start";
    "start:                  ## program begins here";
    "                        .globl main";
    "\t\t\t.type main, @function";
    "main:";
    "                        movq $Main..new, %r14";
    "                        pushq %rbp";
    "                        call *%r14";
    "                        pushq %rbp";
    "                        pushq %r13";
    "                        movq $Main.main, %r14";
    "                        call *%r14";
    "                        ## guarantee 16-byte alignment before call";
    "\t\t\tandq $0xFFFFFFFFFFFFFFF0, %rsp";
    "\t\t\tmovl $0, %edi";
    "\t\t\tcall exit";
    "                        ";
    "\t.globl\tcooloutstr";
    "\t.type\tcooloutstr, @function";
    "cooloutstr:";
    ".LFB6:";
    "\t.cfi_startproc";
    "\tendbr64";
    "\tpushq\t%rbp";
    "\t.cfi_def_cfa_offset 16";
    "\t.cfi_offset 6, -16";
    "\tmovq\t%rsp, %rbp";
    "\t.cfi_def_cfa_register 6";
    "\tsubq\t$32, %rsp";
    "\tmovq\t%rdi, -24(%rbp)";
    "\tmovl\t$0, -4(%rbp)";
    "\tjmp\t.L2";
    ".L5:";
    "\tmovl\t-4(%rbp), %eax";
    "\tmovslq\t%eax, %rdx";
    "\tmovq\t-24(%rbp), %rax";
    "\taddq\t%rdx, %rax";
    "\tmovzbl\t(%rax), %eax";
    "\tcmpb\t$92, %al";
    "\tjne\t.L3";
    "\tmovl\t-4(%rbp), %eax";
    "\tcltq";
    "\tleaq\t1(%rax), %rdx";
    "\tmovq\t-24(%rbp), %rax";
    "\taddq\t%rdx, %rax";
    "\tmovzbl\t(%rax), %eax";
    "\tcmpb\t$110, %al";
    "\tjne\t.L3";
    "\tmovq\tstdout(%rip), %rax";
    "\tmovq\t%rax, %rsi";
    "\tmovl\t$10, %edi";
    "\tcall\tfputc@PLT";
    "\taddl\t$2, -4(%rbp)";
    "\tjmp\t.L2";
    ".L3:";
    "\tmovl\t-4(%rbp), %eax";
    "\tmovslq\t%eax, %rdx";
    "\tmovq\t-24(%rbp), %rax";
    "\taddq\t%rdx, %rax";
    "\tmovzbl\t(%rax), %eax";
    "\tcmpb\t$92, %al";
    "\tjne\t.L4";
    "\tmovl\t-4(%rbp), %eax";
    "\tcltq";
    "\tleaq\t1(%rax), %rdx";
    "\tmovq\t-24(%rbp), %rax";
    "\taddq\t%rdx, %rax";
    "\tmovzbl\t(%rax), %eax";
    "\tcmpb\t$116, %al";
    "\tjne\t.L4";
    "\tmovq\tstdout(%rip), %rax";
    "\tmovq\t%rax, %rsi";
    "\tmovl\t$9, %edi";
    "\tcall\tfputc@PLT";
    "\taddl\t$2, -4(%rbp)";
    "\tjmp\t.L2";
    ".L4:";
    "\tmovq\tstdout(%rip), %rdx";
    "\tmovl\t-4(%rbp), %eax";
    "\tmovslq\t%eax, %rcx";
    "\tmovq\t-24(%rbp), %rax";
    "\taddq\t%rcx, %rax";
    "\tmovzbl\t(%rax), %eax";
    "\tmovsbl\t%al, %eax";
    "\tmovq\t%rdx, %rsi";
    "\tmovl\t%eax, %edi";
    "\tcall\tfputc@PLT";
    "\taddl\t$1, -4(%rbp)";
    ".L2:";
    "\tmovl\t-4(%rbp), %eax";
    "\tmovslq\t%eax, %rdx";
    "\tmovq\t-24(%rbp), %rax";
    "\taddq\t%rdx, %rax";
    "\tmovzbl\t(%rax), %eax";
    "\ttestb\t%al, %al";
    "\tjne\t.L5";
    "\tmovq\tstdout(%rip), %rax";
    "\tmovq\t%rax, %rdi";
    "\tcall\tfflush@PLT";
    "\tnop";
    "\tleave";
    "\t.cfi_def_cfa 7, 8";
    "\tret";
    "\t.cfi_endproc";
    ".LFE6:";
    "\t.size\tcooloutstr, .-cooloutstr";
    "\t.globl\tcoolstrlen";
    "\t.type\tcoolstrlen, @function";
    "coolstrlen:";
    ".LFB7:";
    "\t.cfi_startproc";
    "\tendbr64";
    "\tpushq\t%rbp";
    "\t.cfi_def_cfa_offset 16";
    "\t.cfi_offset 6, -16";
    "\tmovq\t%rsp, %rbp";
    "\t.cfi_def_cfa_register 6";
    "\tmovq\t%rdi, -24(%rbp)";
    "\tmovl\t$0, -4(%rbp)";
    "\tjmp\t.L7";
    ".L8:";
    "\tmovl\t-4(%rbp), %eax";
    "\taddl\t$1, %eax";
    "\tmovl\t%eax, -4(%rbp)";
    ".L7:";
    "\tmovl\t-4(%rbp), %eax";
    "\tmovl\t%eax, %edx";
    "\tmovq\t-24(%rbp), %rax";
    "\taddq\t%rdx, %rax";
    "\tmovzbl\t(%rax), %eax";
    "\ttestb\t%al, %al";
    "\tjne\t.L8";
    "\tmovl\t-4(%rbp), %eax";
    "\tpopq\t%rbp";
    "\t.cfi_def_cfa 7, 8";
    "\tret";
    "\t.cfi_endproc";
    ".LFE7:";
    "\t.size\tcoolstrlen, .-coolstrlen";
    "\t.section\t.rodata";
    ".LC0:";
    "\t.string\t\"%s%s\"";
    "\t.text";
    "\t.globl\tcoolstrcat";
    "\t.type\tcoolstrcat, @function";
    "coolstrcat:";
    ".LFB8:";
    "\t.cfi_startproc";
    "\tendbr64";
    "\tpushq\t%rbp";
    "\t.cfi_def_cfa_offset 16";
    "\t.cfi_offset 6, -16";
    "\tmovq\t%rsp, %rbp";
    "\t.cfi_def_cfa_register 6";
    "\tpushq\t%rbx";
    "\tsubq\t$40, %rsp";
    "\t.cfi_offset 3, -24";
    "\tmovq\t%rdi, -40(%rbp)";
    "\tmovq\t%rsi, -48(%rbp)";
    "\tcmpq\t$0, -40(%rbp)";
    "\tjne\t.L11";
    "\tmovq\t-48(%rbp), %rax";
    "\tjmp\t.L12";
    ".L11:";
    "\tcmpq\t$0, -48(%rbp)";
    "\tjne\t.L13";
    "\tmovq\t-40(%rbp), %rax";
    "\tjmp\t.L12";
    ".L13:";
    "\tmovq\t-40(%rbp), %rax";
    "\tmovq\t%rax, %rdi";
    "\tcall\tcoolstrlen";
    "\tmovl\t%eax, %ebx";
    "\tmovq\t-48(%rbp), %rax";
    "\tmovq\t%rax, %rdi";
    "\tcall\tcoolstrlen";
    "\taddl\t%ebx, %eax";
    "\taddl\t$1, %eax";
    "\tmovl\t%eax, -28(%rbp)";
    "\tmovl\t-28(%rbp), %eax";
    "\tcltq";
    "\tmovl\t$1, %esi";
    "\tmovq\t%rax, %rdi";
    "\tcall\tcalloc@PLT";
    "\tmovq\t%rax, -24(%rbp)";
    "\tmovl\t-28(%rbp), %eax";
    "\tmovslq\t%eax, %rsi";
    "\tmovq\t-48(%rbp), %rcx";
    "\tmovq\t-40(%rbp), %rdx";
    "\tmovq\t-24(%rbp), %rax";
    "\tmovq\t%rcx, %r8";
    "\tmovq\t%rdx, %rcx";
    "\tleaq\t.LC0(%rip), %rdx";
    "\tmovq\t%rax, %rdi";
    "\tmovl\t$0, %eax";
    "\tcall\tsnprintf@PLT";
    "\tmovq\t-24(%rbp), %rax";
    ".L12:";
    "\tmovq\t-8(%rbp), %rbx";
    "\tleave";
    "\t.cfi_def_cfa 7, 8";
    "\tret";
    "\t.cfi_endproc";
    ".LFE8:";
    "\t.size\tcoolstrcat, .-coolstrcat";
    "\t.section\t.rodata";
    ".LC1:";
    "\t.string\t\"\"";
    "\t.text";
    "\t.globl\tcoolgetstr";
    "\t.type\tcoolgetstr, @function";
    "coolgetstr:";
    ".LFB9:";
    "\t.cfi_startproc";
    "\tendbr64";
    "\tpushq\t%rbp";
    "\t.cfi_def_cfa_offset 16";
    "\t.cfi_offset 6, -16";
    "\tmovq\t%rsp, %rbp";
    "\t.cfi_def_cfa_register 6";
    "\tsubq\t$16, %rsp";
    "\tmovl\t$1, %esi";
    "\tmovl\t$40960, %edi";
    "\tcall\tcalloc@PLT";
    "\tmovq\t%rax, -8(%rbp)";
    "\tmovl\t$0, -16(%rbp)";
    ".L21:";
    "\tmovq\tstdin(%rip), %rax";
    "\tmovq\t%rax, %rdi";
    "\tcall\tfgetc@PLT";
    "\tmovl\t%eax, -12(%rbp)";
    "\tcmpl\t$-1, -12(%rbp)";
    "\tje\t.L15";
    "\tcmpl\t$10, -12(%rbp)";
    "\tjne\t.L16";
    ".L15:";
    "\tcmpl\t$0, -16(%rbp)";
    "\tje\t.L17";
    "\tleaq\t.LC1(%rip), %rax";
    "\tjmp\t.L18";
    ".L17:";
    "\tmovq\t-8(%rbp), %rax";
    "\tjmp\t.L18";
    ".L16:";
    "\tcmpl\t$0, -12(%rbp)";
    "\tjne\t.L19";
    "\tmovl\t$1, -16(%rbp)";
    "\tjmp\t.L21";
    ".L19:";
    "\tmovq\t-8(%rbp), %rax";
    "\tmovq\t%rax, %rdi";
    "\tcall\tcoolstrlen";
    "\tmovl\t%eax, %edx";
    "\tmovq\t-8(%rbp), %rax";
    "\taddq\t%rdx, %rax";
    "\tmovl\t-12(%rbp), %edx";
    "\tmovb\t%dl, (%rax)";
    "\tjmp\t.L21";
    ".L18:";
    "\tleave";
    "\t.cfi_def_cfa 7, 8";
    "\tret";
    "\t.cfi_endproc";
    ".LFE9:";
    "\t.size\tcoolgetstr, .-coolgetstr";
    "\t.globl\tcoolsubstr";
    "\t.type\tcoolsubstr, @function";
    "coolsubstr:";
    ".LFB10:";
    "\t.cfi_startproc";
    "\tendbr64";
    "\tpushq\t%rbp";
    "\t.cfi_def_cfa_offset 16";
    "\t.cfi_offset 6, -16";
    "\tmovq\t%rsp, %rbp";
    "\t.cfi_def_cfa_register 6";
    "\tsubq\t$48, %rsp";
    "\tmovq\t%rdi, -24(%rbp)";
    "\tmovq\t%rsi, -32(%rbp)";
    "\tmovq\t%rdx, -40(%rbp)";
    "\tmovq\t-24(%rbp), %rax";
    "\tmovq\t%rax, %rdi";
    "\tcall\tcoolstrlen";
    "\tmovl\t%eax, -4(%rbp)";
    "\tcmpq\t$0, -32(%rbp)";
    "\tjs\t.L23";
    "\tcmpq\t$0, -40(%rbp)";
    "\tjs\t.L23";
    "\tmovq\t-32(%rbp), %rdx";
    "\tmovq\t-40(%rbp), %rax";
    "\taddq\t%rax, %rdx";
    "\tmovl\t-4(%rbp), %eax";
    "\tcltq";
    "\tcmpq\t%rax, %rdx";
    "\tjle\t.L24";
    ".L23:";
    "\tmovl\t$0, %eax";
    "\tjmp\t.L25";
    ".L24:";
    "\tmovq\t-40(%rbp), %rax";
    "\tmovq\t-32(%rbp), %rcx";
    "\tmovq\t-24(%rbp), %rdx";
    "\taddq\t%rcx, %rdx";
    "\tmovq\t%rax, %rsi";
    "\tmovq\t%rdx, %rdi";
    "\tcall\tstrndup@PLT";
    ".L25:";
    "\tleave";
    "\t.cfi_def_cfa 7, 8";
    "\tret";
    "\t.cfi_endproc";
    ".LFE10:";
    "\t.size\tcoolsubstr, .-coolsubstr";
  ]

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
    let class_order = ref [] in
    (* Track class declaration order *)
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
      (* Add to our ordered list *)
      class_order := !class_order @ [ class_name ];
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
      (* Extract just the attribute names from the variants *)
      let attributes =
        List.map
          (function
            | `NoInitializer (name, attr_type) -> (name, attr_type, None)
            | `Initializer (name, attr_type, init_exp) ->
                (name, attr_type, Some init_exp))
          attributes
      in
      (* Store class attributes as a tuple: (attribute names, empty method list) *)
      Hashtbl.add tbl class_name (attributes, [])
    done;
    (tbl, !class_order)
    (* Return both the hashtable and the ordered list *)
  in

  (* Returns: (impl_map, method_order)  to use in assembly gneration to keep order of 
     methods in the classes as read from the cl.type file*)
  let read_implementation_map () =
    let tbl = Hashtbl.create 10 in
    let method_order = ref [] in
    let defining_order = ref [] in
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
        if
          String.length class_name > 0
          && class_name.[0] >= '0'
          && class_name.[0] <= '9'
        then
          failwith
            (Printf.sprintf
               "Invalid class name: '%s' (expected non-numeric name)" class_name);

        let num_methods_str = read () in
        let num_methods =
          try int_of_string num_methods_str
          with Failure _ ->
            failwith
              ("Error: expected int in num methods but got " ^ num_methods_str)
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
            (* let () = printf "def class: %s\n" defining_class in *)
            let method_body = read_exp () in

            Hashtbl.add tbl (class_name, method_name)
              (formals, formal_types, defining_class, method_body);
            (* Record the method in the order it was read *)
            method_order := !method_order @ [ (class_name, method_name) ];
            defining_order :=
              !defining_order @ [ (defining_class, method_name) ]
          done
      done;
    (tbl, !method_order, !defining_order)
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
  let class_map, class_order = read_class_map () in
  let impl_map, method_order, defining_order = read_implementation_map () in
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
        (* Create an initial environment; maybe pre-populate it with formal parameters *)
        let initial_env = Hashtbl.create 10 in
        (*
              List.iter (fun (param, _) ->
                let loc = newloc () in
                Hashtbl.add initial_env param loc
              ) formals;
         *)

        let tac_instrs, result_expr, _final_env =
          convert class_name method_name initial_env body
        in
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
  List.iter (fun tac -> output_string fout (tac_instr_to_str tac)) tac_program;

  close_out fout;
  (* Main assembly generation function *)
  let generate_assembly (tac_program : tac_instr list) (class_map : class_map)
      (impl_map : impl_map) (parent_map : parent_map)
      (class_order : string list) : string list =
    (* Read the class information from your input files *)
    collect_all_strings class_map class_order impl_map;

    (* print_string_label_map (); *)
    (* print_string_literal_list (); *)
    (* Generate standard vtables first *)
    let vtables =
      generate_vtables class_map impl_map parent_map class_order method_order
    in

    (* for string literal count*)
    (* Generate method definitions *)
    let methods =
      generate_all_method_definitions class_map impl_map parent_map
        defining_order
    in
    let constructors = generate_constructors class_order class_map in

  print_explicitly_initialized_fields ();
    let string_literals = generate_string_literals () in

    let helper_functions_and_entry = generate_helper_functions_and_entry () in

    (* Combine everything with proper ordering *)
    vtables @ constructors @ methods @ string_literals
    @ helper_functions_and_entry
  in

  let assembly =
    generate_assembly tac_program class_map impl_map parent_map class_order
  in
  let asmname = Filename.chop_extension fname ^ ".s" in
  write_assembly_file asmname assembly;

  Printf.printf "Generated TAC file: %s\n" tacname;
  Printf.printf "Generated assembly file: %s\n" asmname
;;

main ()
