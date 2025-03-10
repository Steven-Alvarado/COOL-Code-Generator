(* Steven Alvarado & 
   PA3c2
*)

(* The traditional approach to converting expressions to three-address 
   code involves a recursive descent traversal of the abstract syntax tree. 
   The recursive descent traversal returns both a three-address code instruction as well as a list of additional instructions that should be prepended to the output.


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
                | ... 

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

  let read_list worker =
    let k = int_of_string (read ()) in
    let lst = range k in
    List.map (fun _ -> worker ()) lst
  in
  (* Many mutually recursive procedures to read in the cl-type file *)
  (*TODO*)
  close_in fin;

  (* Emit the cl-tac program *)
  let tacname = Filename.chop_extension fname ^ ".cl-tac" in
  let fout = open_out tacname in
    (*TODO*)
  close_out fout
;;

main ()
