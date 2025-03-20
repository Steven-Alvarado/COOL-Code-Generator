(* 
   Steven Alvarado & 
   PA3c2

   Produce "three-address-code" TAC intermediate representation for (some) cool
   programs
*)
open Printf

type loc = string (* "really an integer "*)
and id = loc * string
and cool_type = id

(* class name -> (attribute list, method list with parameter types) *)
type class_map = (string, string list * (string * string) list) Hashtbl.t
(* <- UNSURE on data struct *)

(* (class_name, method_name) -> defining class *)
type impl_map = (string * string, string) Hashtbl.t

(* class name -> parent class *)
type parent_map = (string, string) Hashtbl.t

type ast =
  | AST_Attribute of string * string * ast option (* UNSURE*)
  | AST_Method of string * (string * string) list * string * ast (* UNSURE*)
  | AST_Assign of string * ast
  | AST_DynamicDispatch of ast * string * ast list (* Unsure*)
  | AST_StaticDispatch of ast * string * string * ast list (* UNSURE*)
  | AST_SelfDispatch of string * ast list (*UNSURE*)
  | AST_If of ast * ast * ast
  | AST_While of ast * ast
  | AST_Block of ast list
  | AST_New of string
  | AST_IsVoid of ast
  | AST_Plus of (ast * ast)
  | AST_Minus of ast * ast
  | AST_Times of ast * ast
  | AST_Divide of ast * ast
  | AST_Lt of ast * ast
  | AST_Le of ast * ast
  | AST_Eq of ast * ast
  | AST_Not of ast
  | AST_Negate of ast
  | AST_Int of int
  | AST_String of string
  | AST_True
  | AST_False
  | AST_Let of (ast * ast * ast option) list * ast
  | AST_Case of ast * (ast * ast * ast) list
  | AST_Variable of string
  | AST_Identifier of string

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
  | TAC_Assignment of string * tac_expr
  | TAC_Call of string * string * string list
  | TAC_StaticCall of string * string * string * string list
  | TAC_New of string * string
  | TAC_IsVoid of string * string
  | TAC_Compare of string * string * string * string
  | TAC_Not of string * string
  | TAC_Negate of string * string
| TAC_Assign_StaticCall of string * string * string * string list

let ast_to_string x = 
match x with 
  | AST_Attribute _ -> " Attirute"
  | AST_Method _ -> "Method"
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
  | AST_Int _ -> "int"
  | AST_String _ -> "string"
  | AST_True -> "true"
  | AST_False -> "false"
  | AST_Let _ -> "let"
  | AST_Case _ -> "case"
  | AST_Variable _ -> "variable"
  | AST_Identifier _ -> "identifier"


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
  let v = "temp" ^ string_of_int !temp_var_counter in
  temp_var_counter := !temp_var_counter + 1;
  v

let label_counter = ref 0

let fresh_label () =
  let l = "label" ^ string_of_int !label_counter in
  label_counter := !label_counter + 1;
  l
(* The traditional approach to converting expressions to three-address 
   code involves a recursive descent traversal of the abstract syntax tree. 
   The recursive descent traversal returns both a three-address code 
   instruction as well as a list of additional instructions that should be 
   prepended to the output.
*)
 (* Main logic for parsing ast and converting to tac *)
let rec convert (a : ast) : tac_instr list * tac_expr =
    match a with
    | AST_Identifier v -> ([], TAC_Variable v)
    | AST_Variable v -> ([], TAC_Variable v)
    | AST_Int i ->
        let new_var = fresh_variable () in
        ([TAC_Assign_Int (new_var, i)], TAC_Variable new_var)
    | AST_String s ->
        let new_var = fresh_variable () in
        ([TAC_Assign_String (new_var, s)], TAC_Variable new_var)
    | AST_True ->
        let new_var = fresh_variable () in
        ([TAC_Assign_Bool (new_var, true)], TAC_Variable new_var)
    | AST_False ->
        let new_var = fresh_variable () in
        ([TAC_Assign_Bool (new_var, false)], TAC_Variable new_var)
    | AST_Plus (a1, a2) ->
        let i1, ta1 = convert a1 in
        let i2, ta2 = convert a2 in
        let new_var = fresh_variable () in
        let to_output = TAC_Assign_Plus (new_var, ta1, ta2) in
        (i1 @ i2 @ [to_output], TAC_Variable new_var)
    | AST_Minus (a1, a2) ->
        let i1, ta1 = convert a1 in
        let i2, ta2 = convert a2 in
        let new_var = fresh_variable () in
        let to_output = TAC_Assign_Minus (new_var, ta1, ta2) in
        (i1 @ i2 @ [to_output], TAC_Variable new_var)
    | AST_Times (a1, a2) ->
        let i1, ta1 = convert a1 in
        let i2, ta2 = convert a2 in
        let new_var = fresh_variable () in
        let to_output = TAC_Assign_Times (new_var, ta1, ta2) in
        (i1 @ i2 @ [to_output], TAC_Variable new_var)
    | AST_Divide (a1, a2) ->
        let i1, ta1 = convert a1 in
        let i2, ta2 = convert a2 in
        let new_var = fresh_variable () in
        let to_output = TAC_Assign_Divide (new_var, ta1, ta2) in
        (i1 @ i2 @ [to_output], TAC_Variable new_var)
    | AST_Lt (a1, a2) ->
        let i1, ta1 = convert a1 in
        let i2, ta2 = convert a2 in
        let new_var = fresh_variable () in
        let to_output = TAC_Assign_Lt (new_var, ta1, ta2) in
        (i1 @ i2 @ [to_output], TAC_Variable new_var)
    | AST_Le (a1, a2) ->
        let i1, ta1 = convert a1 in
        let i2, ta2 = convert a2 in
        let new_var = fresh_variable () in
        let to_output = TAC_Assign_Le (new_var, ta1, ta2) in
        (i1 @ i2 @ [to_output], TAC_Variable new_var)
    | AST_Eq (a1, a2) ->
        let i1, ta1 = convert a1 in
        let i2, ta2 = convert a2 in
        let new_var = fresh_variable () in
        let to_output = TAC_Assign_Eq (new_var, ta1, ta2) in
        (i1 @ i2 @ [to_output], TAC_Variable new_var)
    | AST_Not a1 ->
        let i1, ta1 = convert a1 in
        let new_var = fresh_variable () in
        let to_output = TAC_Assign_Not (new_var, ta1) in
        (i1 @ [to_output], TAC_Variable new_var)
    | AST_Negate a1 ->
        let i1, ta1 = convert a1 in
        let new_var = fresh_variable () in
        let to_output = TAC_Assign_Negate (new_var, ta1) in
        (i1 @ [to_output], TAC_Variable new_var)
    | AST_IsVoid a1 ->
        let i1, ta1 = convert a1 in
        let new_var = fresh_variable () in
        let to_output = TAC_Assign_IsVoid (new_var, ta1) in
        (i1 @ [to_output], TAC_Variable new_var)
    | AST_New type_name ->
        let new_var = fresh_variable () in
        ([TAC_Assign_New (new_var, TAC_Variable type_name)], TAC_Variable new_var) (* Variable might cause problems*)
    | AST_New _ -> 
        failwith "New with non-identifier type not supported"
    | AST_Assign (var_name, expr) ->
        let instrs, var_expr = convert expr in
        (instrs @ [TAC_Assign_Variable (var_name, tac_expr_to_string var_expr)], TAC_Variable var_name)
    | AST_Block exprs ->
        (* For blocks, evaluate each expression sequentially and return the last one *)
        let rec process_block exprs =
          match exprs with
          | [] -> ([], TAC_Variable "void") (* Empty block returns void *)
          | [last] -> convert last (* Last expression determines the block's value *)
          | first :: rest ->
              let first_instrs, _ = convert first in
              let rest_instrs, rest_expr = process_block rest in
              (first_instrs @ rest_instrs, rest_expr)
        in
        process_block exprs
    | AST_If (cond, then_branch, else_branch) ->
        let cond_instrs, cond_expr = convert cond in
        let then_instrs, then_expr = convert then_branch in
        let else_instrs, else_expr = convert else_branch in
        
        let result_var = fresh_variable () in
        let then_label = fresh_label () in
        let else_label = fresh_label () in
        let end_label = fresh_label () in
        
        let cond_var = match cond_expr with
          | TAC_Variable v -> v
          | _ -> 
              let temp = fresh_variable () in
              tac_expr_to_string cond_expr
        in
        
        let tac_instrs = cond_instrs @
          [TAC_ConditionalJump (cond_var, then_label);
           TAC_Jump else_label;
           TAC_Label then_label] @
          then_instrs @
          [TAC_Assign_Variable (result_var, tac_expr_to_string then_expr);
           TAC_Jump end_label;
           TAC_Label else_label] @
          else_instrs @
          [TAC_Assign_Variable (result_var, tac_expr_to_string else_expr);
           TAC_Label end_label]
        in
        (tac_instrs, TAC_Variable result_var)
    | AST_While (cond, body) ->
        let cond_label = fresh_label () in
        let body_label = fresh_label () in
        let end_label = fresh_label () in
        
        let cond_instrs, cond_expr = convert cond in
        let body_instrs, _ = convert body in
        
        let cond_var = match cond_expr with
          | TAC_Variable v -> v
          | _ -> tac_expr_to_string cond_expr
        in
        
        let tac_instrs = 
          [TAC_Label cond_label] @
          cond_instrs @
          [TAC_ConditionalJump (cond_var, body_label);
           TAC_Jump end_label;
           TAC_Label body_label] @
          body_instrs @
          [TAC_Jump cond_label;
           TAC_Label end_label]
        in
        (* While loops in COOL return void *)
        let void_var = fresh_variable () in
        (tac_instrs @ [TAC_Assign_Variable (void_var, "void")], TAC_Variable void_var)
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
    let call_instr = TAC_Call (result_var, method_name, List.map tac_expr_to_string arg_exprs) in

    (obj_instrs @ arg_instrs @ [call_instr], TAC_Variable result_var)
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
    let call_instr = TAC_Assign_StaticCall (result_var, obj_var, method_name, List.map tac_expr_to_string arg_exprs) in

    (obj_instrs @ arg_instrs @ [call_instr], TAC_Variable result_var)
    | AST_SelfDispatch (method_name, args) ->
        (* This is equivalent to a dynamic dispatch with "self" as the object *)
        convert (AST_DynamicDispatch (AST_Identifier "self", method_name, args))
    | AST_Let (bindings, body) ->
        (* Process each binding in order *)
        let rec process_bindings bindings acc_instrs =
          match bindings with
          | [] -> acc_instrs
          | (AST_Identifier var_name, AST_Identifier _, None) :: rest ->
              (* A binding without initialization *)
              process_bindings rest acc_instrs
          | (AST_Identifier var_name, AST_Identifier _, Some init) :: rest ->
              (* A binding with initialization *)
              let init_instrs, init_expr = convert init in
              let assign_instr = TAC_Assign_Variable (var_name, tac_expr_to_string init_expr) in
              process_bindings rest (acc_instrs @ init_instrs @ [assign_instr])
          | _ -> failwith "Invalid let binding format"
        in
        
        let binding_instrs = process_bindings bindings [] in
        let body_instrs, body_expr = convert body in
        
        (binding_instrs @ body_instrs, body_expr)
    | x -> failwith ("Unimplemented AST Node: " ^ (ast_to_string x));

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

  let read_int () = int_of_string (read ()) in
  let read_string () = read () in

  let read_list worker =
    let k = int_of_string (read ()) in
    let lst = range k in
    List.map (fun _ -> worker ()) lst
  in

  (* Many mutually recursive procedures to read in the cl-type file *)
  let read_class_map () =
    let tbl = Hashtbl.create 10 in
    let num_classes = read_int () in
    for _ = 1 to num_classes do
      let class_name = read_string () in
      let attrs = read_list read_string in
      let num_methods = read_int () in
      let methods =
        read_list (fun () ->
            let method_name = read_string () in
            let params = read_list read_string in
            (method_name, params))
      in
      Hashtbl.add tbl class_name (attrs, methods)
    done;
    tbl
  in

  let read_implementation_map () =
    let tbl = Hashtbl.create 10 in
    let num_entries = read_int () in
    for _ = 1 to num_entries do
      let class_name = read_string () in
      let num_methods = read_int () in
      for _ = 1 to num_methods do
        let method_name = read_string () in
        let _ = read_int () in
        (* Number of parameters, unused *)
        let defined_in = read_string () in
        Hashtbl.add tbl (class_name, method_name) defined_in
      done
    done;
    tbl
  in

  let read_parent_map () =
    let tbl = Hashtbl.create 10 in
    let num_entries = read_int () in
    for _ = 1 to num_entries do
      let class_name = read_string () in
      let parent_name = read_string () in
      Hashtbl.add tbl class_name parent_name
    done;
    tbl
  in

  let rec read_ast () =
    let classes = read_list read_cool_class in
    let rec find_main_method features =
      match features with
      | AST_Method ("main", _, _, body) :: _ -> body
      | _ :: rest -> find_main_method rest
      | [] -> failwith "Error: no 'main' method found in Main class"
    in
    let _, _, features =
      List.find (fun (class_name, _, _) -> class_name = "Main") classes
    in
    find_main_method features
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
    (snd cname, inherits, features)
  and read_feature () =
    match read () with
    | "attribute_no_init" ->
        let fname = read_id () in
        let ftype = read_id () in
        AST_Attribute (snd fname, snd ftype, None)
    | "attribute_init" ->
        let fname = read_id () in
        let ftype = read_id () in
        let finit = read_exp () in
        AST_Attribute (snd fname, snd ftype, Some finit)
    | "method" ->
        let mname = read_id () in
        let formals = read_list read_formal in
        let mtype = read_id () in
        let mbody = read_exp () in
        AST_Method (snd mname, formals, snd mtype, mbody)
    | x -> failwith ("cannot happen: " ^ x)
  and read_formal () =
    let fname = read_id () in
    let ftype = read_id () in
    (snd fname, snd ftype)
  and read_exp () =
    let eloc = read () in
    let ekind =
      match read () with
      | "assign" ->
          let var = read_id () in
          let rhs = read_exp () in
          AST_Assign (snd var, rhs)
      | "dynamic_dispatch" ->
          let e = read_exp () in
          let mname = read_id () in
          let args = read_list read_exp in
          AST_DynamicDispatch (e, snd mname, args)
      | "static_dispatch" ->
          let e = read_exp () in
          let tname = read_id () in
          let mname = read_id () in
          let args = read_list read_exp in
          AST_StaticDispatch (e, snd tname, snd mname, args)
      | "self_dispatch" ->
          let mname = read_id () in
          let args = read_list read_exp in
          AST_SelfDispatch (snd mname, args)
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
          let (_, cname) = read_id () in
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
          let ival = int_of_string (read ()) in
          AST_Int ival
      | "string" ->
          let sval = read () in
          AST_String sval
      | "identifier" ->
          let _, variable = read_id () in
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
                    ( AST_Identifier (snd var),
                      AST_Identifier (snd var_type),
                      None )
                | "let_binding_init" ->
                    let var = read_id () in
                    let var_type = read_id () in
                    let value = read_exp () in
                    ( AST_Identifier (snd var),
                      AST_Identifier (snd var_type),
                      Some value )
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
                (AST_Identifier (snd var), AST_Identifier (snd var_type), body))
          in
          AST_Case (expr, case_elements)
    | x -> failwith (" expression kind unhandled: " ^ x) 
in 
ekind 
in


  let class_map = read_class_map () in
  let implementation_map = read_implementation_map () in
  let parent_map = read_parent_map () in
  let ast = read_ast () in

  (* TODO*)

  close_in fin;

    (*convert AST to TAC*)
  let tac_instrs, _ = convert ast in

   (* Emit the cl-tac program *)
  let tacname = Filename.chop_extension fname ^ ".cl-tac" in
  let fout = open_out tacname in 
  List.iter
    (fun tac ->
     match tac with
    | TAC_Assign_Int (x, i) -> fprintf fout "%s <- int %d\n" x i
    | TAC_Assign_String (x, s) -> fprintf fout "%s <- string %s\n" x s
    | TAC_Assign_Variable (x, y) -> fprintf fout "%s <- %s\n" x y
    | TAC_Assign_Plus (x, y, z) ->
        fprintf fout "%s <- + %s %s\n" x (tac_expr_to_string y)
          (tac_expr_to_string z)
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
    | TAC_Assign_Bool (x, b) -> 
        fprintf fout "%s <- bool %b\n" x b
    | TAC_Label lbl -> 
        fprintf fout "label %s\n" lbl
    | TAC_Jump lbl -> 
        fprintf fout "jmp %s\n" lbl
    | TAC_ConditionalJump (x, lbl) -> 
        fprintf fout "bt %s %s\n" x lbl
    | TAC_Return x -> 
        fprintf fout "return %s\n" x
    | TAC_Call (result, method_name, args) ->
        fprintf fout "%s <- call %s(%s)\n" result method_name (String.concat ", " args)
    | TAC_Assign_StaticCall (result, obj, method_name, args) ->
        fprintf fout "%s <- static_call %s.%s(%s)\n" result obj method_name (String.concat ", " args)
    | _ -> fprintf fout "ERROR unhadled TAC Instruciton\n" 
  )
    tac_instrs;

close_out fout;

;;

main ()






