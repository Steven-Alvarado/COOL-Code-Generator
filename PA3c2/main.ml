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
  | AST_New of ast
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

type tac_expr =
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
  | TAC_Binary of string * string * string * string
  | TAC_Label of string (* label L1 *)
  | TAC_Jump of string (* jmp L1 *)
  | TAC_ConditionalJump of string * string (* bt x L2 *)
  | TAC_Return of string

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

(* The traditional approach to converting expressions to three-address 
   code involves a recursive descent traversal of the abstract syntax tree. 
   The recursive descent traversal returns both a three-address code 
   instruction as well as a list of additional instructions that should be 
   prepended to the output.
*)

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
          let cname = read_id () in
          AST_New (AST_Identifier (snd cname))
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
  and class_map = read_class_map () in
  let implementation_map = read_implementation_map () in
  let parent_map = read_parent_map () in
  let ast = read_ast () in

  (* TODO*)

  (* Main logic for parsing ast and converting to tac *)
  let rec convert (a : ast) : tac_instr list * tac_expr =
    match a with
    | AST_Variable v -> ([], TAC_Variable v)
    | AST_Int i ->
        let new_var = fresh_variable () in
        ([ TAC_Assign_Int (new_var, i) ], TAC_Variable new_var)
    | AST_Plus (a1, a2) ->
        let i1, ta1 = convert a1 in
        let i2, ta2 = convert a2 in
        let new_var = fresh_variable () in
        let to_output = TAC_Assign_Plus (new_var, ta1, ta2) in
        (i1 @ i2 @ [ to_output ], TAC_Variable new_var)
  in

  close_in fin;

  (* Emit the cl-tac program *)
  let tacname = Filename.chop_extension fname ^ ".cl-tac" in
  let fout = open_out tacname in

  let tac_instrs, _ = convert ast in

  List.iter
    (fun tac ->
      match tac with
      | TAC_Assign_Int (x, i) -> fprintf fout "%s <- int %d\n" x i
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
      | TAC_Assign_Bool (x, b) -> fprintf fout "%s <- bool %b\n" x b
      | TAC_Label lbl -> fprintf fout "label %s\n" lbl
      | TAC_Jump lbl -> fprintf fout "jmp %s\n" lbl
      | TAC_ConditionalJump (x, lbl) -> fprintf fout "bt %s %s\n" x lbl
      | TAC_Return x -> fprintf fout "return %s\n" x
      (* TODO *))
    tac_instrs;

  close_out fout
;;

main ()
