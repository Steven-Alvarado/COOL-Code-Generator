(* 
   Steven Alvarado & 
   PA3c2

   Produce "three-address-code" TAC intermediate representation for (some) cool
   programs
*)
open Printf

(* class name -> (attribute list, method list with parameter types) *)
type class_map = (string, string list * (string * string) list) Hashtbl.t (* <- UNSURE on data struct *)

(* (class_name, method_name) -> defining class *)
type impl_map = (string * string, string) Hashtbl.t

(* class name -> parent class *)
type parent_map = (string, string) Hashtbl.t

type ast =
  | AST_Variable of string
  | AST_Int of int
  | AST_Plus of (ast * ast)
  | AST_Minus of ast * ast
  | AST_Times of ast * ast
  | AST_Divide of ast * ast
  | AST_Assign of string * ast
  | AST_While of ast * ast
  | AST_Block of ast list
  | AST_SelfDispatch of string * ast list
  | AST_If of ast * ast * ast
  | AST_Let of (ast * ast * ast option) list * ast
  | AST_Case of ast * (ast * ast * ast) list
  | AST_New of ast
  | AST_IsVoid of ast
  | AST_Negate of ast
  | AST_Not of ast

and tac_expr =
  | TAC_Variable of string
  | TAC_Constant of int
  | TAC_BinaryOp of string * tac_expr * tac_expr
  | TAC_UnaryOp of string * tac_expr
  | TAC_FunctionCall of string * tac_expr list
(*TODO*)

type tac_instr =
  | TAC_Assign of string * string
  | TAC_Binary of string * string * string * string
  | TAC_Label of string
  | TAC_Jump of string
  | TAC_ConditionalJump of string * string
  | TAC_Return of string
(*TODO*)

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
    match read_string () with
    | "Int" ->
        let _ = read_string () in
        (* Consume "integer" *)
        AST_Int (read_int ())
    | "identifier" -> AST_Variable (read_string ())
    | "assign" ->
        let var = read_string () in
        let expr = read_ast () in
        AST_Assign (var, expr)
    | "plus" ->
        let left = read_ast () in
        let right = read_ast () in
        AST_Plus (left, right)
    | "while" ->
        let cond = read_ast () in
        let body = read_ast () in
        AST_While (cond, body)
    | "block" ->
        let size = read_int () in
        let rec read_block n acc =
          if n = 0 then
            List.rev acc
          else
            read_block (n - 1) (read_ast () :: acc)
        in
        AST_Block (read_block size [])
    | "self_dispatch" ->
        let method_name = read_string () in
        let size = read_int () in
        let rec read_args n acc =
          if n = 0 then
            List.rev acc
          else
            read_args (n - 1) (read_ast () :: acc)
        in
        AST_SelfDispatch (method_name, read_args size [])
    | _ -> failwith "Unexpected AST token"
    (* TODO*)
  in

let rec convert (a : ast) : (tac_instr list * tac_expr) =
                match a with
                | AST_Variable(v) -> [], TAC_Variable(v)
                | AST_Int(i) -> 
                        let new_var = fresh_variable () in
                        [TAC_Assign_Int(new_var, i)], (TAC_Variable(new_var)
                | AST_Plus(a1,a2) ->
                        let i1, ta1 = convert a1 in 
                        let i2, ta2 = convert a2 in 
                        let new_var = fresh_variable () in
                        let to_output = TAC_Assign_Plus(new_var, ta1, ta2) in
                        (i1 @ i2 @ [to_output]), (TAC_Variable(new_var))


  (* Many mutually recursive procedures to read in the cl-type file *)

  close_in fin;

  (* Emit the cl-tac program *)
  let tacname = Filename.chop_extension fname ^ ".cl-tac" in
  let fout = open_out tacname in
  (*TODO*)
  close_out fout
;;

main ()
