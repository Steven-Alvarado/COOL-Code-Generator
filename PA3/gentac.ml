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
let rec convert (current_class : string) (current_method : string ) (a : exp) : tac_instr list * tac_expr =
    match a.exp_kind with
    | AST_Identifier var_name ->
        if snd var_name = "self" then 
            ([], TAC_Variable "self")    
        else
            let temp = fresh_variable () in 
            ([ TAC_Assign_Variable (temp, snd var_name)], TAC_Variable temp)
    | AST_Integer i ->
        let new_var = fresh_variable () in
        [TAC_Assign_Int (new_var , int_of_string i)], TAC_Variable(new_var)
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
        let then_instrs, then_expr = convert current_class current_method then_branch in
        let then_code =
            [ TAC_Comment "then branch";
                TAC_Label label_then ]
            @ then_instrs
            @ [ TAC_Jump label_join ]
        in

        (* Convert the else branch *)
        let else_instrs, else_expr = convert current_class current_method else_branch in
        let else_code =
            [ TAC_Comment "else branch";
                TAC_Label label_else ]
            @ else_instrs
            @ [ TAC_Assign_Variable ("t$0", tac_expr_to_string else_expr);
                TAC_Jump label_join ]
        in

        let if_instrs =
            cond_instrs @
            [ not_instr;
                TAC_ConditionalJump (not_temp, label_else);
                TAC_ConditionalJump (tac_expr_to_string cond_expr, label_then) ]
            @ then_code
            @ else_code
            @ [ TAC_Comment "if-join";
                TAC_Label label_join;
            ]
        in
        (if_instrs, TAC_Variable "t$0")
    | AST_Assign (var_name, expr) ->
        let instrs, expr_val = convert current_class current_method expr in
        let assign_instr = TAC_Assign_Variable (snd var_name, tac_expr_to_string expr_val) in
        let final_copy = TAC_Assign_Variable ("t$0", snd var_name) in
        (instrs @ [ assign_instr; final_copy ], TAC_Variable "t$0")  | AST_Block exprs ->
        (* For blocks, evaluate each expression sequentially and return the last one *)
        let rec process_block exprs =
            match exprs with
            | [] -> ([], TAC_Variable "void") (* Empty block returns void *)
            | [ last ] ->
                convert current_class current_method last (* Last expression determines the block's value *)
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
        let while_start = fresh_label current_class current_method  in
        let while_pred = fresh_label current_class current_method  in
        let while_join = fresh_label current_class current_method  in
        let while_body = fresh_label current_class current_method  in
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
        let args_data = List.map (fun arg -> convert current_class current_method arg) args in
        let arg_instrs = List.concat (List.map fst args_data) in
        let arg_exprs = List.map snd args_data in

        (* Generate function call instruction, storing result in t$0 *)
        let call_instr =
            TAC_Call
                ("t$0", snd method_name, List.map tac_expr_to_string arg_exprs)
        in

        (obj_instrs @ arg_instrs @ [ call_instr ], TAC_Variable "t$0")
    | AST_StaticDispatch (obj, type_name, method_name, args) ->
        (* Convert object expression *)
        let obj_instrs, obj_expr = convert current_class current_method obj in

        (* Convert each argument *)
        let args_data = List.map (fun arg -> convert current_class current_method arg) args in
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
                let init_instrs, init_expr = convert current_class current_method init in
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


