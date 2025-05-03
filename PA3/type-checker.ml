(* 
   Steven Alvarado sra23
   PA2 Semantic Analyzer
*)

open Printf

type static_type = Class of string | SELF_TYPE of string

let type_to_str t = match t with Class x -> x | SELF_TYPE c -> "SELF_TYPE"
let parent_map : (string, string) Hashtbl.t ref = ref (Hashtbl.create 10)
let method_loc_table : (string * string, string) Hashtbl.t = Hashtbl.create 100

type object_environment = (string, static_type) Hashtbl.t

type method_environment =
  ((string * string) * (static_type list * static_type)) list

type containing_class = string (*Check*)

let empty_object_environment () = Hashtbl.create 255

(* type definitions *)
type cool_program = cool_class list
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
  | Integer of string (* "really an integer"*)
  | Assign of id * exp
  | DynamicDispatch of exp * id * exp list
  | StaticDispatch of exp * id * id * exp list
  | SelfDispatch of id * exp list
  | If of exp * exp * exp
  | While of exp * exp
  | Block of exp list
  | New of id
  | IsVoid of exp
  | Plus of exp * exp
  | Minus of exp * exp
  | Times of exp * exp
  | Divide of exp * exp
  | Lt of exp * exp
  | Le of exp * exp
  | Eq of exp * exp
  | Not of exp
  | Negate of exp
  | String of string
  | Identifier of id
  | True
  | False
  | Let of (id * id * exp option) list * exp
  | Case of exp * (id * id * exp) list

let exp_to_str t =
  match t with
  | Integer _ -> "Int"
  | Assign _ -> "assign"
  | DynamicDispatch _ -> "dd"
  | StaticDispatch _ -> "static dispatch"
  | SelfDispatch _ -> "self dispatch"
  | If _ -> "if "
  | While _ -> "while"
  | Block _ -> "block"
  | New _ -> "new"
  | IsVoid _ -> "isvoid"
  | Plus _ -> "plus"
  | Minus _ -> "minus"
  | Times _ -> "times"
  | Divide _ -> "divide"
  | Lt _ -> "lt"
  | Le _ -> "less equal"
  | Eq _ -> "equal"
  | Not _ -> "not"
  | Negate _ -> "negate"
  | String _ -> "string"
  | Identifier _ -> "identifier"
  | True -> "true"
  | False -> "false"
  | Let _ -> "let"
  | Case _ -> "Case"

(* Inheritable base classes*)
let base_classes = [ "Object"; "IO" ]

let predefined_methods =
  [
    (("Object", "abort"), [], "Object", None);
    (("Object", "copy"), [], "SELF_TYPE", None);
    (("Object", "type_name"), [], "String", None);
    (("IO", "out_string"), [ ("x", "String") ], "SELF_TYPE", None);
    (("IO", "out_int"), [ ("x", "Int") ], "SELF_TYPE", None);
    (("IO", "in_string"), [], "String", None);
    (("IO", "in_int"), [], "Int", None);
    (("String", "length"), [], "Int", None);
    (("String", "concat"), [ ("s", "String") ], "String", None);
    (("String", "substr"), [ ("i", "Int"); ("l", "Int") ], "String", None);
  ]

let build_inheritance_graph (ast : cool_program) :
    (string, string list) Hashtbl.t
    * (string, int) Hashtbl.t
    * (string, string) Hashtbl.t =
  let graph = Hashtbl.create (List.length ast) in
  let dependency_count = Hashtbl.create (List.length ast) in
  let parent_map = Hashtbl.create (List.length ast) in

  (* Base classes always inherit from Object (except Object itself) *)
  let base_classes = [ "Object"; "IO"; "Int"; "String"; "Bool" ] in
  List.iter
    (fun bclass ->
      if not (Hashtbl.mem graph bclass) then (
        Hashtbl.add graph bclass [];
        Hashtbl.add dependency_count bclass 0);
      if bclass <> "Object" then
        Hashtbl.add parent_map bclass "Object")
    base_classes;

  (* Initialize graph and dependency count *)
  List.iter
    (fun ((_, cname), _, _) ->
      Hashtbl.add graph cname [];
      Hashtbl.add dependency_count cname 0)
    ast;

  (* Populate graph with inheritance relationships and store parent references *)
  List.iter
    (fun ((_, cname), inherits, _) ->
      let parent =
        match inherits with
        | Some (_, parent) -> parent
        | None -> "Object" (* Default to Object if no parent is specified *)
      in

      let children =
        Hashtbl.find_opt graph parent |> Option.value ~default:[]
      in
      Hashtbl.replace graph parent (cname :: children);

      (* Increment dependency count for the child *)
      let count =
        Hashtbl.find_opt dependency_count cname |> Option.value ~default:0
      in
      Hashtbl.replace dependency_count cname (count + 1);

      (* Store the parent class reference *)
      Hashtbl.add parent_map cname parent)
    ast;

  (graph, dependency_count, parent_map)

let topological_sort (graph : (string, string list) Hashtbl.t)
    (dependency_count : (string, int) Hashtbl.t) : string list option =
  let sorted_order = ref [] in
  let queue = ref [] in
  let visited = Hashtbl.create (Hashtbl.length graph) in
  let visiting = Hashtbl.create (Hashtbl.length graph) in
  (* Track active nodes *)

  (* Add all classes with no dependencies to the queue *)
  Hashtbl.iter
    (fun cname count ->
      if count = 0 then
        queue := cname :: !queue)
    dependency_count;

  (* Recursive DFS function to detect cycles *)
  let rec dfs cname path =
    if Hashtbl.mem visiting cname then (
      (* If the node is already being visited, we found a cycle *)
      let cycle = String.concat " " (List.rev (cname :: path)) in
      Printf.printf "ERROR: 0: Type-Check: inheritance cycle detected: %s\n"
        cycle;
      exit 1)
    else if not (Hashtbl.mem visited cname) then (
      Hashtbl.add visiting cname true;
      List.iter
        (fun child -> dfs child (cname :: path))
        (Hashtbl.find_opt graph cname |> Option.value ~default:[]);
      Hashtbl.remove visiting cname;
      Hashtbl.add visited cname true;
      sorted_order := cname :: !sorted_order)
  in

  (* Start DFS from all nodes with no dependencies *)
  Hashtbl.iter
    (fun cname _ ->
      if (not (Hashtbl.mem visited cname)) && not (List.mem cname base_classes)
      then
        dfs cname [])
    dependency_count;

  (* Ensure all user-defined classes were visited *)
  let all_classes =
    Hashtbl.fold (fun cname _ acc -> cname :: acc) dependency_count []
  in
  let unvisited_classes =
    List.filter
      (fun cname ->
        (not (Hashtbl.mem visited cname)) && not (List.mem cname base_classes))
      all_classes
  in

  if unvisited_classes = [] then
    Some (List.rev !sorted_order)
  else
    None

(* Helper to checik if two types are the same*)
let rec equivalent_types (t1 : cool_type) (t2 : cool_type)
    (parent_map : (string, string) Hashtbl.t) current_class =
  let _, name1 = t1 in
  let _, name2 = t2 in
  if name1 = name2 then
    true
    (* Exact type match *)
  else if name1 = "SELF_TYPE" && name2 = current_class then
    true
  else if name2 = "SELF_TYPE" && name1 = current_class then
    true
  else
    match
      (Hashtbl.find_opt parent_map name1, Hashtbl.find_opt parent_map name2)
    with
    | Some p1, Some p2 when p1 = p2 ->
        true (* Both types inherit from the same parent *)
    | _ -> false

let rec collect_methods cname ast parent_map =
  (* Get the parent class methods first *)
  let parent_methods =
    match Hashtbl.find_opt parent_map cname with
    | Some parent -> collect_methods parent ast parent_map
    | None -> []
  in

  (* Get methods defined in the current class *)
  let current_class_methods =
    match List.find_opt (fun ((_, name), _, _) -> name = cname) ast with
    | Some (_, _, features) ->
        List.filter_map
          (fun feature ->
            match feature with
            | Method ((mloc, mname), formals, (_, ret_type), body) ->
                let formatted_formals =
                  List.map
                    (fun ((_, fname), (_, ftype)) -> (fname, ftype))
                    formals
                in
                Hashtbl.replace method_loc_table (cname, mname) mloc;
                Some ((cname, mname), formatted_formals, ret_type, Some body)
            | _ -> None)
          features
    | None -> []
  in

  (* Get predefined methods that belong to this class *)
  let predefined_for_class =
    List.filter (fun ((c, _), _, _, _) -> c = cname) predefined_methods
  in

  (* Filter out predefined methods that are already defined in current_class_methods *)
  let missing_predefined =
    List.filter
      (fun ((_, pname), _, _, _) ->
        not
          (List.exists
             (fun ((_, m), _, _, _) -> m = pname)
             current_class_methods))
      predefined_for_class
  in

  (* Override parent methods with current class methods *)
  let overridden_parent_methods =
    List.filter
      (fun ((_, parent_method), _, _, _) ->
        not
          (List.exists
             (fun ((_, curr_method), _, _, _) -> curr_method = parent_method)
             current_class_methods))
      parent_methods
  in

  (* Combine parent methods (that aren't overridden) with current class methods *)
  overridden_parent_methods @ current_class_methods @ missing_predefined

let check_method_overrides cname ast parent_map =
  (* Get methods defined in or inherited by this class *)
  let class_methods = collect_methods cname ast parent_map in

  (* Proceed only if class has a parent *)
  match Hashtbl.find_opt parent_map cname with
  | Some parent ->
      (* Get methods from parent class *)
      let parent_methods = collect_methods parent ast parent_map in

      (* Extract only methods defined in this class, not inherited ones *)
      let local_methods =
        List.filter
          (fun ((def_class, _), _, _, _) -> def_class = cname)
          class_methods
      in

      (* Check each local method against parent methods *)
      List.iter
        (fun ((mloc, mname), formals, ret_type, body) ->
          match
            List.find_opt
              (fun ((_, pmname), _, _, _) -> pmname = mname)
              parent_methods
          with
          | Some ((_, _), p_formals, p_ret_type, _) ->
              (* Parse the string type into static_type *)
              let parse_type type_str =
                if type_str = "SELF_TYPE" then
                  SELF_TYPE cname
                else
                  Class type_str
              in

              let ret_type_obj = parse_type ret_type in
              let p_ret_type_obj = parse_type p_ret_type in

              (* Helper function to check if child type conforms/is_subtype to parent type *)
              let rec is_conformant child_type parent_type =
                match (child_type, parent_type) with
                | Class c1, Class c2 when c1 = c2 -> true
                | Class "SELF_TYPE", Class "SELF_TYPE" -> true
                | SELF_TYPE c1, SELF_TYPE c2 when c1 = c2 -> true
                | Class c1, Class c2 -> (
                    (* Check if c1 is a subclass of c2 by traversing the inheritance hierarchy *)
                    match Hashtbl.find_opt parent_map c1 with
                    | Some parent_of_c1 when parent_of_c1 = c2 -> true
                    | Some parent_of_c1 ->
                        is_conformant (Class parent_of_c1) (Class c2)
                    | None -> false)
                | SELF_TYPE c1, Class c2 ->
                    (* SELF_TYPE conforms to its class and all superclasses *)
                    is_conformant (Class c1) (Class c2)
                | _ -> false
              in

              (* Validate return type conformity - child return type must be same or subtype of parent *)
              if not (is_conformant ret_type_obj p_ret_type_obj) then (
                let mloc =
                  match Hashtbl.find_opt method_loc_table (cname, mname) with
                  | Some loc -> loc
                  | None -> "UNKNOWN" (* Fallback if somehow not found *)
                in
                Printf.printf
                  "ERROR: %s: Type-Check: class %s redefines method %s and \
                   changes return type (from %s to %s)\n"
                  mloc cname mname p_ret_type ret_type;
                exit 1);

              (* Validate number of parameters *)
              if List.length formals <> List.length p_formals then (
                let mloc =
                  match Hashtbl.find_opt method_loc_table (cname, mname) with
                  | Some loc -> loc
                  | None -> "UNKNOWN" (* Fallback if somehow not found *)
                in

                Printf.printf
                  "ERROR: %s: Type-Check: class %s redefines method %s with a \
                   different number of parameters\n"
                  mloc cname mname;
                exit 1);

              (* Validate parameter types exactly match (COOL requires exact matches, not conformance) *)
              List.iter2
                (fun (fname1, ftype1) (_, ftype2) ->
                  let mloc =
                    match Hashtbl.find_opt method_loc_table (cname, mname) with
                    | Some loc -> loc
                    | None -> "UNKNOWN" (* Fallback if somehow not found *)
                  in

                  if ftype1 <> ftype2 then (
                    Printf.printf
                      "ERROR: %s: Type-Check: class %s redefines method %s and \
                       changes type of formal parameter %s from %s to %s\n"
                      mloc cname mname fname1 ftype2 ftype1;
                    exit 1))
                formals p_formals
          | None -> ())
        local_methods
  | None -> ()

let rec conforms_to (child : string) (parent : string)
    (parent_map : (string, string) Hashtbl.t) current_class =
  let child_actual =
    if child = "SELF_TYPE" then
      current_class
    else
      child
  in
  let parent_actual =
    if parent = "SELF_TYPE" then
      current_class
    else
      parent
  in
  if child_actual = parent_actual then
    true
  else
    match Hashtbl.find_opt parent_map child_actual with
    | Some super -> conforms_to super parent_actual parent_map current_class
    | None -> false

let typecheck_program (ast : cool_program) =
  let graph, dependency_count, parent_map = build_inheritance_graph ast in
  match topological_sort graph dependency_count with
  | None ->
      Printf.printf "ERROR: 0: Type-Check: inheritance cycle detected";
      exit 1
  | Some sorted_classes ->
      List.iter
        (fun cname -> check_method_overrides cname ast parent_map)
        sorted_classes

let main () =
  (* De-Serialize the cl-ast file *)
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
  let rec read_cool_program () = read_list read_cool_class
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
    let ekind =
      match read () with
      | "assign" ->
          let var = read_id () in
          let rhs = read_exp () in
          Assign (var, rhs)
      | "dynamic_dispatch" ->
          let e = read_exp () in
          let mname = read_id () in
          let args = read_list read_exp in
          DynamicDispatch (e, mname, args)
      | "static_dispatch" ->
          let e = read_exp () in
          let tname = read_id () in
          let mname = read_id () in
          let args = read_list read_exp in
          StaticDispatch (e, tname, mname, args)
      | "self_dispatch" ->
          let mname = read_id () in
          let args = read_list read_exp in
          SelfDispatch (mname, args)
      | "if" ->
          let predicate = read_exp () in
          let then_branch = read_exp () in
          let else_branch = read_exp () in
          If (predicate, then_branch, else_branch)
      | "while" ->
          let predicate = read_exp () in
          let body = read_exp () in
          While (predicate, body)
      | "block" ->
          let body = read_list read_exp in
          Block body
      | "new" ->
          let cname = read_id () in
          New cname
      | "isvoid" ->
          let e = read_exp () in
          IsVoid e
      | "plus" ->
          let x = read_exp () in
          let y = read_exp () in
          Plus (x, y)
      | "minus" ->
          let x = read_exp () in
          let y = read_exp () in
          Minus (x, y)
      | "times" ->
          let x = read_exp () in
          let y = read_exp () in
          Times (x, y)
      | "divide" ->
          let x = read_exp () in
          let y = read_exp () in
          Divide (x, y)
      | "lt" ->
          let x = read_exp () in
          let y = read_exp () in
          Lt (x, y)
      | "le" ->
          let x = read_exp () in
          let y = read_exp () in
          Le (x, y)
      | "eq" ->
          let x = read_exp () in
          let y = read_exp () in
          Eq (x, y)
      | "not" ->
          let x = read_exp () in
          Not x
      | "negate" ->
          let x = read_exp () in
          Negate x
      | "integer" ->
          let ival = read () in
          Integer ival
      | "string" ->
          let sval = read () in
          String sval
      | "identifier" ->
          let variable = read_id () in
          Identifier variable
      | "true" -> True
      | "false" -> False
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
          Let (bindings, body)
      | "case" ->
          let expr = read_exp () in
          let case_elements =
            read_list (fun () ->
                let var = read_id () in
                let var_type = read_id () in
                let body = read_exp () in
                (var, var_type, body))
          in
          Case (expr, case_elements)
      | x -> failwith (" expression kind unhandled: " ^ x)
    in
    { loc = eloc; exp_kind = ekind; static_type = None }
    (* not annotated yet*)
  in

  let ast = read_cool_program () in
  close_in fin;

  (*
      debug
      printf "cl-ast De-Serialized, %d classes\n" (List.length ast); 
      *)

  (* Check for class-related errors *)
  let base_classes = [ "Int"; "String"; "Bool"; "IO"; "Object" ] in
  let user_classes = List.map (fun ((_, cname), _, _) -> cname) ast in
  let all_classes = base_classes @ user_classes in
  let all_classes = List.sort compare all_classes in
  (*let user_methods = List.map (fun ((_, cname), ))*)

  (* Make internal data structures to hold helpful information to 
       perform check more easily *)

  (* Call main typecheck helper function to implement remaining
           Type Checks *)

  typecheck_program ast;

  (* Check for inheritance cycles*)
  List.iter
    (fun ((cloc, cname), inherits, features) ->
      (* checking for redefinition of base classes*)
      if List.mem cname base_classes then (
        printf "ERROR: %s: Type-Check: class %s redefined\n" cloc cname;
        exit 1);

      (*Inheritance errors*)
      match inherits with
      | None -> ()
      | Some (iloc, iname) ->
          if iname = "Int" || iname = "Bool" || iname = "String" then (
            printf "ERROR: %s: Type-Check: inheriting from forbidden class %s\n"
              iloc iname;
            exit 1);

          if not (List.mem iname all_classes) then (
            printf "ERROR: %s: Type-Check: inheriting from undefined class %s\n"
              iloc iname;
            exit 1))
    ast;

  (* Check if Main class exists and has a parameter-less main method *)
  let main_class =
    List.find_opt (fun ((_, cname), _, _) -> cname = "Main") ast
  in
  match main_class with
  | None ->
      printf "ERROR: 0: Type-Check: class Main not found\n";
      exit 1
  | Some (_, _, features) -> (
      (let main_method =
         List.find_opt
           (fun feature ->
             match feature with
             | Method ((_, mname), _, _, _) -> mname = "main"
             | _ -> false)
           features
       in
       match main_method with
       | None ->
           printf "ERROR: 0: Type-Check: class Main method main not found\n";
           exit 1
       | Some (Method ((mloc, _), formals, _, _)) ->
           (* Check if main method has no parameters *)
           if List.length formals > 0 then (
             printf
               "ERROR: 0: Type-Check: class Main method main with 0 parameters \
                not found\n";
             exit 1)
       | _ -> ());

      (* DONE WITH ERROR CHECKING*)
      (* Initialize method environment with built-in methods *)
      let graph, dependency_count, parent_map = build_inheritance_graph ast in

      (* Initialize method environment with built-in methods *)
      let m =
        ref
          [
            (* Object methods *)
            (("Object", "abort"), ([], Class "Object"));
            (("Object", "type_name"), ([], Class "String"));
            (("Object", "copy"), ([], SELF_TYPE "Object"));
            (* IO methods *)
            (("IO", "out_string"), ([ Class "String" ], SELF_TYPE "IO"));
            (("IO", "out_int"), ([ Class "Int" ], SELF_TYPE "IO"));
            (("IO", "in_string"), ([], Class "String"));
            (("IO", "in_int"), ([], Class "Int"));
            (* String methods *)
            (("String", "length"), ([], Class "Int"));
            (("String", "concat"), ([ Class "String" ], Class "String"));
            ( ("String", "substr"),
              ([ Class "Int"; Class "Int" ], Class "String") );
          ]
      in

      (* First pass: Collect all methods from each class (without inheritance) *)
      List.iter
        (fun ((cloc, cname), _, features) ->
          List.iter
            (fun feat ->
              match feat with
              | Method ((mloc, mname), formals, (_, ret_type), _) ->
                  let parameter_types =
                    List.map (fun (_, (_, typ)) -> Class typ) formals
                  in
                  (* Handle SELF_TYPE in return type *)
                  let return_type =
                    if ret_type = "SELF_TYPE" then
                      SELF_TYPE cname
                    else
                      Class ret_type
                  in
                  let signature = (parameter_types, return_type) in
                  (* Add method to environment *)
                  m := ((cname, mname), signature) :: !m
              | _ -> ())
            features)
        ast;

      (* Second pass: Process inheritance using parent_map *)
      List.iter
        (fun ((_, child), _, _) ->
          let rec inherit_methods current_class =
            match Hashtbl.find_opt parent_map current_class with
            | Some parent ->
                (* Get all methods from parent *)
                let parent_methods =
                  List.filter
                    (fun ((class_name, _), _) -> class_name = parent)
                    !m
                in
                (* Add parent methods to child if not already defined *)
                List.iter
                  (fun ((_, method_name), signature) ->
                    if not (List.mem_assoc (child, method_name) !m) then
                      m := ((child, method_name), signature) :: !m)
                  parent_methods;
                (* Continue up the inheritance chain *)
                inherit_methods parent
            | None -> ()
          in
          inherit_methods child)
        ast;

      (* Initialize the object environment as a reference *)
      let o = ref (empty_object_environment ()) in

      (* populate the object environment *)
      List.iter
        (fun ((cloc, cname), inherits, features) ->
          (* Inherit attributes from parent first *)
          (match inherits with
          | Some (parent_loc, parent_name) ->
              (* Find the parent class in the AST *)
              let rec get_parent_attributes (class_name : string) :
                  object_environment =
                match
                  List.find_opt (fun ((_, name), _, _) -> name = class_name) ast
                with
                | Some (_, parent_inherits, parent_features) ->
                    let parent_o = empty_object_environment () in
                    (* Recursively inherit attributes from the parent's parent *)
                    (match parent_inherits with
                    | Some (_, grandparent_name) ->
                        Hashtbl.iter
                          (fun key value -> Hashtbl.add parent_o key value)
                          (get_parent_attributes grandparent_name)
                    | None -> ());
                    (* Add the parent's own attributes *)
                    List.iter
                      (fun feat ->
                        match feat with
                        | Attribute ((_, name), (_, declared_type), _) ->
                            if not (Hashtbl.mem parent_o name) then
                              Hashtbl.add parent_o name (Class declared_type)
                        | _ -> ())
                      parent_features;
                    parent_o
                | None ->
                    if List.mem class_name [ "Object"; "IO" ] then
                      empty_object_environment ()
                    else (
                      (* If the parent class is not found, report an error *)
                      printf
                        "ERROR %s: Type-Check Parent class %s not found in the \
                         AST\n"
                        parent_loc class_name;
                      exit 1)
              in
              (* Copy attributes from the parent into the current class environment *)
              Hashtbl.iter
                (fun key value ->
                  if not (Hashtbl.mem !o key) then
                    (* Avoid overriding existing attributes *)
                    Hashtbl.add !o key value)
                (get_parent_attributes parent_name)
          | None -> ());

          (*Add class’s own attributes *)
          List.iter
            (fun feat ->
              match feat with
              | Attribute ((_, name), (_, declared_type), _) ->
                  (* Add the attribute without initialization or type-checking *)
                  if not (Hashtbl.mem !o name) then
                    Hashtbl.add !o name (Class declared_type)
              | _ -> ())
            features)
        ast;

      (* Build the inheritance graph and extract parent_map *)
      let graph, dependency_count, parent_map = build_inheritance_graph ast in

      let rec is_subtype t1 t2 =
        match (t1, t2) with
        | Class x, Class y when x = y -> true
        | Class x, Class "Object" -> true
        | Class x, Class y -> (
            (*check parent map*)
            match Hashtbl.find_opt parent_map x with
            | Some parent -> is_subtype (Class parent) (Class y)
            | None -> false (* cannot be subtype no parent*))
        | SELF_TYPE c1, SELF_TYPE c2 -> c1 = c2 (* SELF_TYPE c <= SELF_TYPE c*)
        | SELF_TYPE c, Class x -> is_subtype (Class c) (Class x)
        | _, _ -> false
      in
      let parent_of class_name = Hashtbl.find_opt parent_map class_name in

      let rec least_upper_bound t1 t2 =
        let class_name t =
          match t with
          | Class name -> name
          | SELF_TYPE name -> name (* Treat SELF_TYPE similarly to Class *)
        in
        let t1_name = class_name t1 in
        let t2_name = class_name t2 in

        if is_subtype t1 t2 then
          t2
        else if is_subtype t2 t1 then
          t1
        else
          match (parent_of t1_name, parent_of t2_name) with
          | Some p1, Some p2 -> least_upper_bound (Class p1) (Class p2)
          | _ -> Class "Object"
      in

      (* Expression type checking*)
      let rec typecheck (o : object_environment) (m : method_environment)
          (c : containing_class) (exp : exp) : static_type =
        flush stdout;
        let static_type =
          match exp.exp_kind with
          | Integer i -> Class "Int"
          | String s -> Class "String"
          | True -> Class "Bool"
          | False -> Class "Bool"
          | Plus (e1, e2) ->
              let t1 = typecheck o m c e1 in
              if t1 <> Class "Int" then (
                printf "ERROR: %s: Type-Check: adding %s instead of Int\n"
                  exp.loc (type_to_str t1);
                exit 1);
              let t2 = typecheck o m c e2 in
              if t2 <> Class "Int" then (
                printf "ERROR: %s: Type-Check: adding %s instead of Int\n"
                  exp.loc (type_to_str t2);
                exit 1);
              Class "Int"
          | Minus (e1, e2) ->
              let t1 = typecheck o m c e1 in
              if t1 <> Class "Int" then (
                printf "ERROR: %s: Type-Check: subtracting %s instead of Int\n"
                  exp.loc (type_to_str t1);
                exit 1);
              let t2 = typecheck o m c e2 in
              if t2 <> Class "Int" then (
                printf "ERROR: %s: Type-Check: subtracting %s instead of Int\n"
                  exp.loc (type_to_str t2);
                exit 1);
              Class "Int"
          | Times (e1, e2) ->
              let t1 = typecheck o m c e1 in
              if t1 <> Class "Int" then (
                printf "ERROR: %s: Type-Check: multiplying %s instead of Int\n"
                  exp.loc (type_to_str t1);
                exit 1);
              let t2 = typecheck o m c e2 in
              if t2 <> Class "Int" then (
                printf "ERROR: %s: Type-Check: multiplying %s instead of Int\n"
                  exp.loc (type_to_str t2);
                exit 1);
              Class "Int"
          | Divide (e1, e2) ->
              let t1 = typecheck o m c e1 in
              if t1 <> Class "Int" then (
                printf "ERROR: %s: Type-Check: dividing %s instead of Int\n"
                  exp.loc (type_to_str t1);
                exit 1);
              let t2 = typecheck o m c e2 in
              if t2 <> Class "Int" then (
                printf "ERROR: %s: Type-Check: dividing %s instead of Int\n"
                  exp.loc (type_to_str t2);
                exit 1);
              Class "Int"
          | Identifier (vloc, vname) ->
              if vname = "self" then
                SELF_TYPE c
                (* self always has SELF_TYPE corresponding to current class *)
              else if Hashtbl.mem o vname then
                Hashtbl.find o vname (* Lookup variable *)
              else (
                printf "ERROR: %s: Type-Check: undeclared variable %s\n" vloc
                  vname;
                exit 1)
          | Block body -> (
              let t = List.map (fun exp -> typecheck o m c exp) body in
              match List.rev t with
              | [] -> Class "Object" (* Default type for an empty block *)
              | last_type :: _ ->
                  last_type (* Extract the first element after reversing *))
          | Assign ((vloc, vname), e1) ->
              (* Double check *)
              let t1 = typecheck o m c e1 in
              (if Hashtbl.mem o vname then
                 let declared_type = Hashtbl.find o vname in
                 if not (is_subtype t1 declared_type) then (
                   printf
                     "ERROR: %s: Type-Check: %s does not conform to %s in \
                      assignment\n"
                     exp.loc (type_to_str t1)
                     (type_to_str declared_type);
                   exit 1));
              t1
          | Not e1 ->
              let t1 = typecheck o m c e1 in
              if t1 <> Class "Bool" then (
                printf
                  "ERROR: %s: Type-Check: not operation on %s instead of Bool\n"
                  exp.loc (type_to_str t1);
                exit 1);
              Class "Bool"
          | Negate e1 ->
              let t1 = typecheck o m c e1 in
              if t1 <> Class "Int" then (
                printf
                  "ERROR: %s: Type-Check: negate operation on %s instead of Int\n"
                  exp.loc (type_to_str t1);
                exit 1);
              Class "Int"
          | Eq (e1, e2) | Le (e1, e2) | Lt (e1, e2) ->
              let t1 = typecheck o m c e1 in
              let t2 = typecheck o m c e2 in
              if
                (t1 = Class "Int" || t1 = Class "String" || t1 = Class "Bool"
               || t2 = Class "Int" || t2 = Class "String" || t2 = Class "Bool")
                && t1 <> t2
              then (
                printf "ERROR: %s: Type-Check: comparison between %s and %s\n"
                  exp.loc (type_to_str t1) (type_to_str t2);
                exit 1);
              Class "Bool"
          | IsVoid e1 ->
              let _t = typecheck o m c e1 in
              Class "Bool"
          | While (cond, body) ->
              let t1 = typecheck o m c cond in
              let _t2 = typecheck o m c body in
              if t1 <> Class "Bool" then (
                printf
                  "ERROR: %s: Type-Check: while condition is %s instead of Bool\n"
                  exp.loc (type_to_str t1);
                exit 1);
              Class "Object"
          | If (predicate, then_branch, else_branch) ->
              let t1 = typecheck o m c predicate in
              let t2 = typecheck o m c then_branch in
              let t3 = typecheck o m c else_branch in
              if t1 <> Class "Bool" then (
                printf
                  "ERROR: %s: Type-Check: if condition is %s instead of Bool\n"
                  exp.loc (type_to_str t1);
                exit 1);
              let lub = least_upper_bound t2 t3 in
              (*printf " lub: %s\n" (type_to_str lub) ;*)
              lub
          | New (cloc, cname) ->
              (* Check if class exists*)
              if cname <> "Object" && (not (Hashtbl.mem parent_map cname)) && cname <> "SELF_TYPE"
              then (
                printf
                  "ERROR: %s: Type-Check: cannot create new instance of \
                   unknown class %s\n"
                  exp.loc cname;
                exit 1);
              if cname = "SELF_TYPE" then
                SELF_TYPE c
              else
                Class cname
          | DynamicDispatch (e0, (mloc, mname), args) -> (
              let t0 = typecheck o m c e0 in
              let t'0 =
                match t0 with
                | SELF_TYPE _ ->
                    Class c (* SELF_TYPE resolves to current class *)
                | _ -> t0
              in

              let class_name =
                match t'0 with
                | Class cname -> cname
                | _ -> failwith "Unexpected type"
              in

              (* Recursive method lookup (to check inherited methods) *)
              let rec lookup_method cname =
                match List.assoc_opt (cname, mname) m with
                | Some signature -> Some signature
                | None -> (
                    match Hashtbl.find_opt parent_map cname with
                    | Some parent_name ->
                        lookup_method parent_name (* Recursive lookup *)
                    | None -> None)
              in

              (*Ensure method exists in class_name or its ancestors *)
              match lookup_method class_name with
              | None ->
                  Printf.printf
                    "ERROR: %s: Type-Check: unknown method %s in dispatch on %s\n"
                    mloc mname class_name;
                  exit 1
              | Some (param_types, return_type) -> (
                  (* Type-check argument expressions *)
                  let arg_types =
                    List.map (fun arg -> typecheck o m c arg) args
                  in

                  (* Ensure argument count matches *)
                  let expected_count = List.length param_types in
                  let actual_count = List.length arg_types in
                  if expected_count <> actual_count then (
                    Printf.printf
                      "ERROR: %s: Type-Check: method %s expected %d arguments \
                       but got %d\n"
                      mloc mname expected_count actual_count;
                    exit 1);

                  (* Ensure argument types conform *)
                  List.iter2
                    (fun arg_type expected_type ->
                      if not (is_subtype arg_type expected_type) then (
                        Printf.printf
                          "ERROR: %s: Type-Check: argument type %s does not \
                           conform to expected %s\n"
                          mloc (type_to_str arg_type)
                          (type_to_str expected_type);
                        exit 1))
                    arg_types param_types;

                  (* Handle SELF_TYPE return type *)
                  match return_type with
                  | SELF_TYPE _ ->
                      t0 (* SELF_TYPE returns the type of the caller *)
                  | _ -> return_type))
          | StaticDispatch (e0, (cloc, cname), (mloc, mname), args) -> (
              let t0 = typecheck o m c e0 in
              if not (is_subtype t0 (Class cname)) then (
                Printf.printf
                  "ERROR: %s: Type-Check: expression type %s does not conform \
                   to static dispatch class %s\n"
                  cloc (type_to_str t0) cname;
                exit 1);

              (*Find the method signature in M *)
              match List.assoc_opt (cname, mname) m with
              | None ->
                  Printf.printf
                    "ERROR: %s: Type-Check: method %s not found in class %s\n"
                    mloc mname cname;
                  exit 1
              | Some (param_types, return_type) -> (
                  (*Type-Check args*)
                  let arg_types =
                    List.map (fun arg -> typecheck o m c arg) args
                  in

                  (* Check that argument types conform *)
                  List.iter2
                    (fun arg_type expected_type ->
                      if not (is_subtype arg_type expected_type) then (
                        Printf.printf
                          "ERROR: %s: Type-Check: argument type %s does not \
                           conform to expected %s\n"
                          mloc (type_to_str arg_type)
                          (type_to_str expected_type);
                        exit 1))
                    arg_types param_types;

                  (*Handle SELF_TYPE*)
                  match return_type with
                  | SELF_TYPE _ -> t0
                  | _ -> return_type))
          | SelfDispatch ((mloc, mname), args) -> (
              (* Find the method in the current class or its ancestors *)
              let rec lookup_method cname =
                match List.assoc_opt (cname, mname) m with
                | Some signature -> Some signature
                | None -> (
                    match Hashtbl.find_opt parent_map cname with
                    | Some parent_name ->
                        lookup_method parent_name (* Recur up the hierarchy *)
                    | None -> None)
              in

              (* Ensure method exists in current class or parent classes *)
              match lookup_method c with
              | None ->
                  Printf.printf
                    "ERROR: %s: Type-Check: unknown method %s in self-dispatch \
                     on class %s\n"
                    mloc mname c;
                  exit 1
              | Some (param_types, return_type) -> (
                  (* Typecheck args *)
                  let arg_types =
                    List.map (fun arg -> typecheck o m c arg) args
                  in

                  (* Check count matches *)
                  let expected_count = List.length param_types in
                  let actual_count = List.length arg_types in
                  if expected_count <> actual_count then (
                    Printf.printf
                      "ERROR: %s: Type-Check: method %s expected %d arguments \
                       but got %d\n"
                      mloc mname expected_count actual_count;
                    exit 1);

                  (* Check types conform *)
                  List.iter2
                    (fun arg_type expected_type ->
                      if not (is_subtype arg_type expected_type) then (
                        Printf.printf
                          "ERROR: %s: Type-Check: argument type %s does not \
                           conform to expected %s\n"
                          mloc (type_to_str arg_type)
                          (type_to_str expected_type);
                        exit 1))
                    arg_types param_types;

                  (* Handle SELF_TYPE correctly *)
                  match return_type with
                  | SELF_TYPE _ ->
                      SELF_TYPE c (* SELF_TYPE resolves to current class *)
                  | _ -> return_type))
          | Let (bindings, let_body) ->
              (* Store old environment to restore after let *)
              let old_o = Hashtbl.copy o in

              List.iter
                (fun ((vloc, vname), (typeloc, typename), init_exp_opt) ->
                  let declared_type =
                    if typename = "SELF_TYPE" then
                      SELF_TYPE c
                    else
                      Class typename
                  in

                  (* If initialization exists, type check it first *)
                  let stored_type =
                    match init_exp_opt with
                    | Some init_exp ->
                        let init_type = typecheck o m c init_exp in
                        (*Ensure the initialization conforms to the declared type *)
                        if not (is_subtype init_type declared_type) then (
                          Printf.printf
                            "ERROR: %s: Type-Check: let binding for %s has \
                             type %s, expected %s\n"
                            vloc vname (type_to_str init_type)
                            (type_to_str declared_type);
                          exit 1);
                        init_type
                    | None -> declared_type
                  in

                  (*Add variable to environment*)
                  Hashtbl.add o vname stored_type)
                bindings;

              (*Type check the let body*)
              let body_type = typecheck o m c let_body in

              (* Restore old environment (remove `let` variables) *)
              Hashtbl.iter (fun key _ -> Hashtbl.remove o key) o;
              Hashtbl.iter (fun key value -> Hashtbl.replace o key value) old_o;

              body_type
          | Case (e0, cases) ->
              let _t0 = typecheck o m c e0 in
              let seen_types = Hashtbl.create 10 in

              let branch_types =
                List.map
                  (fun ((vloc, vname), (tloc, tname), e_i) ->
                    let declared_type = Class tname in

                    (* Check if type is already in seen_types *)
                    if Hashtbl.mem seen_types tname then (
                      Printf.printf
                        "ERROR: %s: Type-Check: case branch type %s is bound \
                         twice\n"
                        tloc tname;
                      exit 1);

                    (* Mark this type as seen *)
                    Hashtbl.add seen_types tname true;

                    if tname <> "Object" && not (Hashtbl.mem parent_map tname) then (
                      printf
                        "ERROR: %s: Type-Check: case branch of type %s is \
                         undefined\n"
                        tloc tname;
                      exit 1);
                    (* Extend the object environment with xi : Ti *)
                    Hashtbl.add o vname declared_type;

                    (* Type-check ei with the new environment *)
                    let branch_type = typecheck o m c e_i in

                    (* Remove xi from the environment after checking *)
                    Hashtbl.remove o vname;

                    branch_type)
                  cases
              in
              (* Compute lub of all branch types *)
              List.fold_left least_upper_bound (List.hd branch_types)
                (List.tl branch_types)
          (*| x -> failwith ("exp kind not implemented: " ^ exp_to_str x)*)
        in
        (* Annotate the AST with new found static type*)
        exp.static_type <- Some static_type;
        static_type
      in

      (* Iterate over every class and typecheck all features*)
      List.iter
        (fun ((cloc, cname), inherits, features) ->
          List.iter
            (fun feat ->
              match feat with
              | Attribute
                  ((nameloc, name), (dtloc, declared_type), Some init_exp) ->
                  let init_type = typecheck !o !m cname init_exp in
                  if is_subtype init_type (Class declared_type) then
                    ()
                    (* happy happy!*)
                  else (
                    printf
                      "ERROR: %s: Type-Check: initializer for %s was %s, did \
                       not match declared %s\n"
                      nameloc name (type_to_str init_type) declared_type;
                    exit 1);
                  Hashtbl.add !o name (Class declared_type)
              | Attribute ((nameloc, name), (dtloc, declared_type), None) ->
                  Hashtbl.add !o name (Class declared_type)
              | Method ((mloc, mname), formals, (dtloc, declared_type), mbody)
                ->
                  (* Ensure SELF_TYPE is only in allowed places *)
                  if
                    List.exists
                      (fun (_, (_, ftype)) -> ftype = "SELF_TYPE")
                      formals
                  then (
                    Printf.printf
                      "ERROR: %s: Type-Check: method %s cannot have parameters \
                       of type SELF_TYPE\n"
                      mloc mname;
                    exit 1);

                  let local_o = Hashtbl.copy !o in

                  (* Add self to local obj env*)
                  Hashtbl.add local_o "self" (SELF_TYPE cname);
                  List.iter
                    (fun ((floc, fname), (_, ftype)) ->
                      Hashtbl.add local_o fname
                        (if ftype = "SELF_TYPE" then
                           SELF_TYPE cname
                         else
                           Class ftype))
                    formals;
                  (* Typechecking method body*)
                  let body_type = typecheck local_o !m cname mbody in

                  let expected_type =
                    if declared_type = "SELF_TYPE" then
                      SELF_TYPE cname
                    else
                      Class declared_type
                  in
                  if is_subtype body_type expected_type then
                    ()
                  else (
                    printf
                      "ERROR: %s: Type-Check: initializer for %s was %s, did \
                       not match declared %s\n"
                      dtloc mname (type_to_str body_type)
                      (type_to_str expected_type);
                    exit 1))
            features)
        ast;

      (* Emit the cl-type file *)
      (* only class map for PA2c2
         Improve this is bad*)
      let cmname = Filename.chop_extension fname ^ ".cl-type" in
      let fout = open_out cmname in

      let rec output_annotated_exp e =
        fprintf fout "%s\n" e.loc;

        (*
         * TYPE ANNOTATION for Annotated AST
         *)
        (match e.static_type with
        | None -> failwith "forgot to typecheck"
        | Some (Class c) -> fprintf fout "%s\n" c
        | Some (SELF_TYPE c) -> fprintf fout "SELF_TYPE\n");

        match e.exp_kind with
        | Assign ((varloc, varname), rhs) ->
            fprintf fout "assign\n%s\n%s\n" varloc varname;
            output_annotated_exp rhs
        | DynamicDispatch (e, (mloc, mname), args) ->
            fprintf fout "dynamic_dispatch\n";
            output_annotated_exp e;
            fprintf fout "%s\n%s\n%d\n" mloc mname (List.length args);
            List.iter output_annotated_exp args
        | StaticDispatch (e, (cloc, cname), (mloc, mname), args) ->
            fprintf fout "static_dispatch\n";
            output_annotated_exp e;
            fprintf fout "%s\n%s\n%s\n%s\n%d\n" cloc cname mloc mname
              (List.length args);
            List.iter output_annotated_exp args
        | SelfDispatch ((mloc, mname), args) ->
            fprintf fout "self_dispatch\n";
            fprintf fout "%s\n%s\n%d\n" mloc mname (List.length args);
            List.iter output_annotated_exp args
        | If (cond, then_branch, else_branch) ->
            fprintf fout "if\n";
            output_annotated_exp cond;
            output_annotated_exp then_branch;
            output_annotated_exp else_branch
        | While (cond, body) ->
            fprintf fout "while\n";
            output_annotated_exp cond;
            output_annotated_exp body
        | Block exprs ->
            fprintf fout "block\n%d\n" (List.length exprs);
            List.iter output_annotated_exp exprs
        | New (cloc, cname) -> fprintf fout "new\n%s\n%s\n" cloc cname
        | IsVoid e ->
            fprintf fout "isvoid\n";
            output_annotated_exp e
        | Plus (x, y) ->
            fprintf fout "plus\n";
            output_annotated_exp x;
            output_annotated_exp y
        | Minus (x, y) ->
            fprintf fout "minus\n";
            output_annotated_exp x;
            output_annotated_exp y
        | Times (x, y) ->
            fprintf fout "times\n";
            output_annotated_exp x;
            output_annotated_exp y
        | Divide (x, y) ->
            fprintf fout "divide\n";
            output_annotated_exp x;
            output_annotated_exp y
        | Lt (x, y) ->
            fprintf fout "lt\n";
            output_annotated_exp x;
            output_annotated_exp y
        | Le (x, y) ->
            fprintf fout "le\n";
            output_annotated_exp x;
            output_annotated_exp y
        | Eq (x, y) ->
            fprintf fout "eq\n";
            output_annotated_exp x;
            output_annotated_exp y
        | Not e ->
            fprintf fout "not\n";
            output_annotated_exp e
        | Negate e ->
            fprintf fout "negate\n";
            output_annotated_exp e
        | Integer ival -> fprintf fout "integer\n%s\n" ival
        | String sval -> fprintf fout "string\n%s\n" sval
        | Identifier (iloc, id) -> fprintf fout "identifier\n%s\n%s\n" iloc id
        | True -> fprintf fout "true\n"
        | False -> fprintf fout "false\n"
        | Let (bindings, body) ->
            fprintf fout "let\n%d\n" (List.length bindings);
            List.iter
              (fun ((vloc, var), (tloc, typ), init) ->
                (match init with
                | None -> fprintf fout "let_binding_no_init\n"
                | Some init_exp -> fprintf fout "let_binding_init\n");
                fprintf fout "%s\n%s\n%s\n%s\n" vloc var tloc typ;
                match init with
                | None -> ()
                | Some init_exp -> output_annotated_exp init_exp)
              bindings;
            output_annotated_exp body
        | Case (e, cases) ->
            fprintf fout "case\n";
            output_annotated_exp e;
            fprintf fout "%d\n" (List.length cases);
            List.iter
              (fun ((iloc, id), (tloc, type_), body) ->
                fprintf fout "%s\n%s\n%s\n%s\n" iloc id tloc type_;
                output_annotated_exp body)
              cases
      in

      (* Build inheritance graph *)
      let graph, dependency_count, parent_map = build_inheritance_graph ast in

      (* Perform topological sort to detect cycles and ensure valid inheritance order *)
      match topological_sort graph dependency_count with
      | None ->
          Printf.printf "ERROR: 0: Type-check: inheritance cycle detected\n";
          exit 1
      | Some sorted_classes ->
          (* Output class map header with correct count *)
          fprintf fout "class_map\n%d\n" (List.length all_classes);

          List.iter
            (fun cname ->
              fprintf fout "%s\n" cname;

              (* Collect inherited attributes first, then local attributes *)
              let rec get_attributes cname acc =
                match
                  List.find_opt (fun ((_, name), _, _) -> name = cname) ast
                with
                | Some (_, inherits, features) ->
                    let parent_attributes =
                      match inherits with
                      | Some (_, parent) -> get_attributes parent acc
                      | None -> acc
                    in
                    let current_attributes =
                      List.filter_map
                        (fun feature ->
                          match feature with
                          | Attribute (id, typ, init) -> Some (id, typ, init)
                          | _ -> None)
                        features
                    in
                    parent_attributes @ current_attributes
                | None -> acc
              in

              let attributes = get_attributes cname [] in

              (* Detect illegal attribute overrides *)
              let rec detect_override attrs seen =
                match attrs with
                | [] -> ()
                | ((loc, aname), _, _) :: rest ->
                    if
                      List.exists (fun ((_, pname), _, _) -> pname = aname) seen
                    then (
                      Printf.printf
                        "ERROR: %s: Type-Check: class %s redefines attribute %s\n"
                        loc cname aname;
                      exit 1);
                    detect_override rest (seen @ [ ((loc, aname), "", None) ])
              in

              detect_override attributes [];

              (* Print number of attributes *)
              fprintf fout "%d\n" (List.length attributes);

              (* Print attributes in correct order *)
              List.iter
                (fun (id, typ, init) ->
                  let _, aname = id in
                  let _, atype = typ in
                  match init with
                  | None -> fprintf fout "no_initializer\n%s\n%s\n" aname atype
                  | Some init_exp ->
                      fprintf fout "initializer\n%s\n%s\n" aname atype;
                      output_annotated_exp init_exp)
                attributes)
            all_classes;

          (* Output the implementation map *)
          fprintf fout "implementation_map\n";
          fprintf fout "%d\n" (List.length all_classes);

          (* Define base class methods with correct inheritance order *)
          let graph, dependency_count, parent_map =
            build_inheritance_graph ast
          in
          (* Iterate over sorted classes *)
          let rec find_original_class mname current_class =
            (* First check if the method is defined in this class *)
            let is_defined_in_current =
              let current_methods =
                collect_methods current_class ast parent_map
              in
              List.exists
                (fun ((defining_class, pname), _, _, _) ->
                  defining_class = current_class && pname = mname)
                current_methods
            in

            if is_defined_in_current then
              current_class
            else
              (* If not defined here, check parent *)
              match Hashtbl.find_opt parent_map current_class with
              | Some parent -> find_original_class mname parent
              | None -> current_class
            (* No parent and not defined? Return current as fallback *)
          in

          List.iter
            (fun cname ->
              fprintf fout "%s\n" cname;

              (* Collect methods for the class *)
              let methods = collect_methods cname ast parent_map in

              (* First, collect all methods for the class, including missing predefined methods *)
              let missing_predefined_methods =
                List.filter
                  (fun ((pclass, pname), _, _, _) ->
                    pclass = cname
                    && not
                         (List.exists
                            (fun ((_, m), _, _, _) -> m = pname)
                            methods))
                  predefined_methods
              in
              let all_methods = methods @ missing_predefined_methods in

              (* Strictly separate inherited methods from methods defined in this class *)
              let inherited_methods, current_class_methods =
                List.partition
                  (fun ((defining_class, _), _, _, _) ->
                    defining_class <> cname)
                  all_methods
              in

              (* Further separate predefined internal methods from explicitly defined methods *)
              let internal_methods, explicit_methods =
                List.partition
                  (fun ((_, method_name), _, _, _) ->
                    List.exists
                      (fun ((c, m), _, _, _) -> c = cname && m = method_name)
                      predefined_methods)
                  current_class_methods
              in

              (* Sort inherited methods first by inheritance depth of their defining class, then alphabetically *)
              let rec inheritance_depth class_name =
                match Hashtbl.find_opt parent_map class_name with
                | None -> 0 (* Object has depth 0 *)
                | Some parent -> 1 + inheritance_depth parent
              in

              let sorted_inherited_methods =
                List.sort
                  (fun ((class1, name1), _, _, _) ((class2, name2), _, _, _) ->
                    let depth_diff =
                      inheritance_depth class1 - inheritance_depth class2
                    in
                    if depth_diff <> 0 then
                      depth_diff
                    else
                      compare name1 name2)
                  inherited_methods
              in

              (* Sort internal methods alphabetically *)
              let sorted_internal_methods =
                List.sort
                  (fun ((_, m1), _, _, _) ((_, m2), _, _, _) -> compare m1 m2)
                  internal_methods
              in

              (* The final correct order: inherited methods, then explicit methods, then internal methods *)
              let ordered_methods =
                sorted_inherited_methods @ explicit_methods
                @ sorted_internal_methods
              in
              fprintf fout "%d\n" (List.length ordered_methods);

              (* Iterate over methods *)
              List.iter
                (fun ((_, mname), formals, ret_type, body) ->
                  fprintf fout "%s\n" mname;
                  fprintf fout "%d\n" (List.length formals);

                  (* Output formal names *)
                  List.iter
                    (fun (fname, _) -> fprintf fout "%s\n" fname)
                    formals;

                  (* Determine if the method is inherited and not overridden *)
                  let defining_class = find_original_class mname cname in
                  fprintf fout "%s\n" defining_class;

                  (* Ensure internal methods use the correct predefined return type *)
                  let correct_return_type =
                    match
                      List.find_opt
                        (fun ((cname', mname'), _, _, _) ->
                          cname' = defining_class && mname' = mname)
                        predefined_methods
                    with
                    | Some (_, _, predefined_ret_type, _) -> predefined_ret_type
                    | None -> ret_type
                  in

                  (* Output method body expression *)
                  match body with
                  | Some exp -> output_annotated_exp exp
                  | None ->
                      fprintf fout "0\n%s\ninternal\n%s.%s\n"
                        correct_return_type defining_class mname)
                ordered_methods)
            all_classes;

          (* Output the parent map*)
          let graph, dependency_count, parent_map =
            build_inheritance_graph ast
          in
          fprintf fout "parent_map\n";
          let parent_child_pairs =
            List.fold_left
              (fun acc class_name ->
                match Hashtbl.find_opt parent_map class_name with
                | Some parent when class_name <> "Object" ->
                    (class_name, parent) :: acc
                | _ -> acc)
              [] all_classes
          in

          (* Output the number of parent-child relationships *)
          fprintf fout "%d\n" (List.length all_classes - 1);

          (* Output each child-parent relationship *)
          List.iter
            (fun (child, parent) -> fprintf fout "%s\n%s\n" child parent)
            (List.sort compare parent_child_pairs);

          (* ANNOTATED AST*)
          fprintf fout "%d\n" (List.length user_classes);

          List.iter
            (fun ((cloc, cname), inherits, features) ->
              fprintf fout "%s\n%s\n" cloc cname;
              (* Print parent class *)
              (match inherits with
              | Some (ploc, parent) ->
                  fprintf fout "inherits\n%s\n%s\n" ploc parent
              | None -> fprintf fout "no_inherits\n");

              fprintf fout "%d\n" (List.length features);

              (* Output attributes and methods *)
              List.iter
                (fun feat ->
                  match feat with
                  | Attribute ((aname_loc, aname), (atype_loc, atype), None) ->
                      (* No initializer *)
                      fprintf fout "attribute_no_init\n%s\n%s\n%s\n%s\n"
                        aname_loc aname atype_loc atype
                  | Attribute
                      ((aname_loc, aname), (atype_loc, atype), Some init_exp) ->
                      (* With initializer *)
                      fprintf fout "attribute_init\n%s\n%s\n%s\n%s\n" aname_loc
                        aname atype_loc atype;
                      output_annotated_exp init_exp
                  | Method ((mloc, mname), formals, (rtype_loc, ret_type), body)
                    ->
                      fprintf fout "method\n%s\n%s\n%d\n" mloc mname
                        (List.length formals);
                      List.iter
                        (fun ((floc, fname), (ftloc, ftype)) ->
                          fprintf fout "%s\n%s\n%s\n%s\n" floc fname ftloc ftype)
                        formals;
                      fprintf fout "%s\n%s\n" rtype_loc ret_type;
                      output_annotated_exp body)
                features)
            ast;
          close_out fout)
;;

main ()
