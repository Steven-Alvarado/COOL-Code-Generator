(* 
   Steven Alvarado & 
   PA3
   code generator
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
    | TAC_Assign_Divide of string * tac_expr * tac_expr * string
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
    | TAC_Assign_Divide (x, y, z, _(*loc*)) ->
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
    | TAC_Assign_Divide (_, _, _, _) -> "TAC_Assign_Divide"
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
let temp_var_counter = ref 1

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
    let l = method_name ^ "_l" ^ string_of_int !label_counter in
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

(* explicit type for locations in memory and stack*)
type location = int

type class_info = {
    name: string;
    parent: string option;
    attributes:( string * string * exp option) list; (* name, type, init/no-init *)
    methods: (string * (string list) * exp) list; (*mname, parameters, method body*)
}

(* Maps attribute names to locations in memory*)
type cool_object = {
    class_name: string;
    attributes: (string * location) list; 
}

(* runtime values*)
type cool_value = 
    | IntValue of int
    | BoolValue of bool
    | StringValue of int * string (* length, "string" *)
    | ObjectValue of cool_object
    | VoidValue

type var_scope = 
    | ClassAttribute
    | LocalVariable
    | Parameter

(* Maps variable names to locations *)
type environment = (string, location) Hashtbl.t

(* Maps locations to values *)
type store = (location, cool_value) Hashtbl.t

(* memory offset information for codegen*)
type mem_info = {
    offset: int;
    var_type: string;
    scope: var_scope;
}

(* all data needed for codegen hopefully *)
type code_meta = (location, mem_info) Hashtbl.t


type context = {
    env: environment;         (* Maps names to locations *)
    store: store;             (* Maps locations to values *)
    meta: code_meta;          (* Maps locations to code generation info *)
    class_attributes: (string, class_info) Hashtbl.t;  (* Class definitions *)
    current_class: string;
    current_method: string;
    next_stack_offset: int;   (* For local variable allocation *)
    self_loc: location;       (* Location of "self" *)
}

let rec convert (current_class : string) (current_method : string) (env : environment) 
    (context : context) (a : exp) : tac_instr list * tac_expr * environment * context =
    match a.exp_kind with
  | AST_Identifier id ->
    let name = snd id in

    if name = "self" then
      ( [], TAC_Variable "self", env, context )

    else
      (* 1) Ensure the original variable has a location *)
      let (orig_loc, env1, ctx1) =
        if Hashtbl.mem env name then
          ( Hashtbl.find env name
          , env
          , context )
        else
          let loc = newloc () in
          Hashtbl.add env name loc;
          (* give it a default VoidValue until initialized *)
          Hashtbl.add context.store loc VoidValue;
          Hashtbl.add context.meta  loc {
            offset   = context.next_stack_offset;
            var_type = "Unknown";
            scope    = LocalVariable
          };
          let ctx' = { context with
            next_stack_offset = context.next_stack_offset - 8
          } in
          ( loc
          , env
          , ctx' )
      in

      (* 2) Allocate a fresh temp and its location *)
      let temp     = fresh_variable () in
      let temp_loc = newloc           () in
      Hashtbl.add env1 temp temp_loc;

      (* 3) Copy the runtime value from orig_loc into the temp’s slot *)
      let value = Hashtbl.find ctx1.store orig_loc in
      Hashtbl.add ctx1.store temp_loc value;

      (* 4) Propagate the type metadata into the temp’s slot *)
      let orig_meta = Hashtbl.find ctx1.meta orig_loc in
      Hashtbl.add ctx1.meta temp_loc {
        offset   = ctx1.next_stack_offset;
        var_type = orig_meta.var_type;
        scope    = LocalVariable
      };

      (* 5) Bump the stack offset in the new context *)
      let ctx2 = { ctx1 with
        env               = env1;
        next_stack_offset = ctx1.next_stack_offset - 8
      } in

      (* 6) Emit the TAC that copies into the temp *)
      ( [ TAC_Assign_Variable (temp, name) ]
      , TAC_Variable temp
      , env1
      , ctx2 )
    | AST_Integer i_str ->
        (* 1) Parse the literal and fresh names/locs *)
        let i       = int_of_string i_str in
        let temp    = fresh_variable () in
        let loc     = newloc () in

        (* 2) Env: bind temp → loc *)
        Hashtbl.add env temp loc;

        (* 3) Store: record the IntValue *)
        Hashtbl.add context.store loc (IntValue i);

        (* 4) Meta: record offset, type, scope *)
        Hashtbl.add context.meta loc {
            offset   = context.next_stack_offset;
            var_type = "Int";
            scope    = LocalVariable
        };

        (* 5) Bump the stack offset *)
        let context' = { context with
            env               = env;
            next_stack_offset = context.next_stack_offset - 8
        } in

        ( [ TAC_Assign_Int (temp, i) ]
            , TAC_Variable temp
            , env
            , context' )


    | AST_String s ->
        let len     = String.length s in
        let temp    = fresh_variable () in
        let loc     = newloc () in

        Hashtbl.add env temp loc;
        Hashtbl.add context.store loc (StringValue (len, s));
        Hashtbl.add context.meta loc {
            offset   = context.next_stack_offset;
            var_type = "String";
            scope    = LocalVariable
        };

        let context' = { context with
            env               = env;
            next_stack_offset = context.next_stack_offset - 8
        } in

        ( [ TAC_Assign_String (temp, s) ]
            , TAC_Variable temp
            , env
            , context' )


    | AST_True ->
        let temp    = fresh_variable () in
        let loc     = newloc () in

        Hashtbl.add env temp loc;
        Hashtbl.add context.store loc (BoolValue true);
        Hashtbl.add context.meta loc {
            offset   = context.next_stack_offset;
            var_type = "Bool";
            scope    = LocalVariable
        };

        let context' = { context with
            env               = env;
            next_stack_offset = context.next_stack_offset - 8
        } in

        ( [ TAC_Assign_Bool (temp, true) ]
            , TAC_Variable temp
            , env
            , context' )


    | AST_False ->
        let temp    = fresh_variable () in
        let loc     = newloc () in

        Hashtbl.add env temp loc;
        Hashtbl.add context.store loc (BoolValue false);
        Hashtbl.add context.meta loc {
            offset   = context.next_stack_offset;
            var_type = "Bool";
            scope    = LocalVariable
        };

        let context' = { context with
            env               = env;
            next_stack_offset = context.next_stack_offset - 8
        } in

        ( [ TAC_Assign_Bool (temp, false) ]
            , TAC_Variable temp
            , env
            , context' )
| AST_Plus (e1, e2) ->
    (* 1) Recurse on subexpressions *)
    let i1, a1, env1, ctx1 = convert current_class current_method env  context e1 in
    let i2, a2, env2, ctx2 = convert current_class current_method env1 ctx1     e2 in

    (* 2) Fresh temp + location *)
    let tmp = fresh_variable () in
    let loc = newloc           () in
    Hashtbl.add env2 tmp loc;

    (* 3) Placeholder in store; we'll fill it at runtime in assembly *)
    Hashtbl.add ctx2.store loc  VoidValue;
    Hashtbl.add ctx2.meta  loc {
      offset   = ctx2.next_stack_offset;
      var_type = "Int";
      scope    = LocalVariable
    };

    (* 4) Bump the offset *)
    let ctx3 = { ctx2 with
      env               = env2;
      next_stack_offset = ctx2.next_stack_offset - 8
    } in

    (* 5) Emit the TAC instruction *)
    ( i1 @ i2 @ [ TAC_Assign_Plus (tmp, a1, a2) ]
    , TAC_Variable tmp
    , env2
    , ctx3 )
  | AST_Minus (a1, a2) ->
    (* 1) recurse on operands *)
    let i1, t1, env1, ctx1 = convert current_class current_method env  context a1 in
    let i2, t2, env2, ctx2 = convert current_class current_method env1 ctx1      a2 in

    (* 2) allocate temp + slot *)
    let temp = fresh_variable () in
    let loc  = newloc       () in
    Hashtbl.add env2 temp loc;

    (* 3) placeholder in store & meta *)
    Hashtbl.add ctx2.store loc VoidValue;
    Hashtbl.add ctx2.meta  loc {
      offset   = ctx2.next_stack_offset;
      var_type = "Int";
      scope    = LocalVariable
    };

    (* 4) bump offset *)
    let ctx' = { ctx2 with
      env               = env2;
      next_stack_offset = ctx2.next_stack_offset - 8
    } in

    (* 5) emit TAC *)
    ( i1 @ i2 @ [ TAC_Assign_Minus (temp, t1, t2) ]
    , TAC_Variable temp
    , env2
    , ctx' )

| AST_Times (a1, a2) ->
    let i1, t1, env1, ctx1 = convert current_class current_method env  context a1 in
    let i2, t2, env2, ctx2 = convert current_class current_method env1 ctx1      a2 in

    let temp = fresh_variable () in
    let loc  = newloc       () in
    Hashtbl.add env2 temp loc;

    Hashtbl.add ctx2.store loc VoidValue;
    Hashtbl.add ctx2.meta  loc {
      offset   = ctx2.next_stack_offset;
      var_type = "Int";
      scope    = LocalVariable
    };

    let ctx' = { ctx2 with
      env               = env2;
      next_stack_offset = ctx2.next_stack_offset - 8
    } in

    ( i1 @ i2 @ [ TAC_Assign_Times (temp, t1, t2) ]
    , TAC_Variable temp
    , env2
    , ctx' )

| AST_Divide (a1, a2) ->
    (* 1) capture the source location for runtime checks *)
    let ln = a.loc in

    (* 2) recurse on the two subexpressions *)
    let i1, t1, env1, ctx1 =
      convert current_class current_method env  context a1
    in
    let i2, t2, env2, ctx2 =
      convert current_class current_method env1 ctx1 a2
    in

    (* 3) allocate a fresh temp and stack slot *)
    let temp = fresh_variable () in
    let loc  = newloc       () in
    Hashtbl.add env2 temp loc;
    Hashtbl.add ctx2.store loc  VoidValue;
    Hashtbl.add ctx2.meta  loc {
      offset   = ctx2.next_stack_offset;
      var_type = "Int";
      scope    = LocalVariable
    };

    (* 4) bump the offset *)
    let ctx' = { ctx2 with
      env               = env2;
      next_stack_offset = ctx2.next_stack_offset - 8
    } in

    (* 5) emit the divide TAC, including the original source‐line info *)
    ( i1 @ i2 @ [ TAC_Assign_Divide (temp, t1, t2, ln) ]
    , TAC_Variable temp
    , env2
    , ctx' )
| AST_Lt (a1, a2) ->
    (* 1) recurse on operands *)
    let i1, t1, env1, ctx1 = convert current_class current_method env  context a1 in
    let i2, t2, env2, ctx2 = convert current_class current_method env1 ctx1      a2 in

    (* 2) fresh temp + stack slot *)
    let temp = fresh_variable () in
    let loc  = newloc       () in
    Hashtbl.add env2 temp loc;

    (* 3) placeholder in store & metadata *)
    Hashtbl.add ctx2.store loc VoidValue;
    Hashtbl.add ctx2.meta  loc {
      offset   = ctx2.next_stack_offset;
      var_type = "Bool";
      scope    = LocalVariable
    };

    (* 4) bump the offset *)
    let ctx' = { ctx2 with
      env               = env2;
      next_stack_offset = ctx2.next_stack_offset - 8
    } in

    (* 5) emit the TAC *)
    ( i1 @ i2 @ [ TAC_Assign_Lt (temp, t1, t2) ]
    , TAC_Variable temp
    , env2
    , ctx' )

| AST_Le (a1, a2) ->
    let i1, t1, env1, ctx1 = convert current_class current_method env  context a1 in
    let i2, t2, env2, ctx2 = convert current_class current_method env1 ctx1     a2 in

    let temp = fresh_variable () in
    let loc  = newloc       () in
    Hashtbl.add env2 temp loc;
    Hashtbl.add ctx2.store loc (VoidValue);
    Hashtbl.add ctx2.meta loc {
      offset   = ctx2.next_stack_offset;
      var_type = "Bool";
      scope    = LocalVariable
    };
    let ctx' = { ctx2 with
      env               = env2;
      next_stack_offset = ctx2.next_stack_offset - 8
    } in

    ( i1 @ i2 @ [ TAC_Assign_Le (temp, t1, t2) ]
    , TAC_Variable temp
    , env2
    , ctx' )

| AST_Eq (a1, a2) ->
    let i1, t1, env1, ctx1 = convert current_class current_method env  context a1 in
    let i2, t2, env2, ctx2 = convert current_class current_method env1 ctx1     a2 in

    let temp = fresh_variable () in
    let loc  = newloc       () in
    Hashtbl.add env2 temp loc;
    Hashtbl.add ctx2.store loc (VoidValue);
    Hashtbl.add ctx2.meta loc {
      offset   = ctx2.next_stack_offset;
      var_type = "Bool";
      scope    = LocalVariable
    };
    let ctx' = { ctx2 with
      env               = env2;
      next_stack_offset = ctx2.next_stack_offset - 8
    } in

    ( i1 @ i2 @ [ TAC_Assign_Eq (temp, t1, t2) ]
    , TAC_Variable temp
    , env2
    , ctx' )

| AST_Not a1 ->
    let i1, t1, env1, ctx1 = convert current_class current_method env  context a1 in

    let temp = fresh_variable () in
    let loc  = newloc       () in
    Hashtbl.add env1 temp loc;
    Hashtbl.add ctx1.store loc (VoidValue);
    Hashtbl.add ctx1.meta loc {
      offset   = ctx1.next_stack_offset;
      var_type = "Bool";
      scope    = LocalVariable
    };
    let ctx' = { ctx1 with
      env               = env1;
      next_stack_offset = ctx1.next_stack_offset - 8
    } in

    ( i1 @ [ TAC_Assign_Not (temp, t1) ]
    , TAC_Variable temp
    , env1
    , ctx' )

| AST_Negate a1 ->
    let i1, t1, env1, ctx1 = convert current_class current_method env  context a1 in

    let temp = fresh_variable () in
    let loc  = newloc       () in
    Hashtbl.add env1 temp loc;
    Hashtbl.add ctx1.store loc (VoidValue);
    Hashtbl.add ctx1.meta loc {
      offset   = ctx1.next_stack_offset;
      var_type = "Int";
      scope    = LocalVariable
    };
    let ctx' = { ctx1 with
      env               = env1;
      next_stack_offset = ctx1.next_stack_offset - 8
    } in

    ( i1 @ [ TAC_Assign_Negate (temp, t1) ]
    , TAC_Variable temp
    , env1
    , ctx' )

| AST_IsVoid a1 ->
    let i1, t1, env1, ctx1 = convert current_class current_method env  context a1 in

    let temp = fresh_variable () in
    let loc  = newloc       () in
    Hashtbl.add env1 temp loc;
    Hashtbl.add ctx1.store loc (VoidValue);
    Hashtbl.add ctx1.meta loc {
      offset   = ctx1.next_stack_offset;
      var_type = "Bool";
      scope    = LocalVariable
    };
    let ctx' = { ctx1 with
      env               = env1;
      next_stack_offset = ctx1.next_stack_offset - 8
    } in

    ( i1 @ [ TAC_Assign_IsVoid (temp, t1) ]
    , TAC_Variable temp
    , env1
    , ctx' )

| AST_New type_name ->
    let cname = snd type_name in
    let temp  = fresh_variable () in
    let loc   = newloc       () in

    Hashtbl.add env temp loc;
    (* at runtime this will construct an object *)
    Hashtbl.add context.store loc (ObjectValue {
      class_name = cname;
      attributes = []  (* you’ll fill these in once you know the class’s fields *)
    });
    Hashtbl.add context.meta loc {
      offset   = context.next_stack_offset;
      var_type = cname;
      scope    = LocalVariable
    };
    let context' = { context with
      env               = env;
      next_stack_offset = context.next_stack_offset - 8
    } in

    ( [ TAC_Assign_New (temp, TAC_Variable cname) ]
    , TAC_Variable temp
    , env
    , context' )
 | AST_If (cond, then_branch, else_branch) ->
    (* 1) Condition *)
    let cond_instrs, cond_expr, env1, ctx1 =
      convert current_class current_method env context cond
    in

    (* 2) Allocate not_temp *)
    let not_temp = fresh_variable () in
    let not_loc  = newloc        () in
    Hashtbl.add env1 not_temp not_loc;
    Hashtbl.add ctx1.store not_loc  VoidValue;
    Hashtbl.add ctx1.meta  not_loc {
      offset   = ctx1.next_stack_offset;
      var_type = "Bool";
      scope    = LocalVariable
    };
    let ctx1 = { ctx1 with
      env               = env1;
      next_stack_offset = ctx1.next_stack_offset - 8
    } in

    (* 2a) Copy the condition’s value into not_temp *)
    let cond_name = match cond_expr with TAC_Variable v -> v | _ -> assert false in
    let src_loc   = Hashtbl.find env1 cond_name in
    let v         = Hashtbl.find ctx1.store src_loc in
    Hashtbl.replace ctx1.store not_loc v;
    let m         = Hashtbl.find ctx1.meta src_loc in
    Hashtbl.replace ctx1.meta not_loc { (Hashtbl.find ctx1.meta not_loc) with
      var_type = m.var_type
    };

    let not_instr = TAC_Assign_Not (not_temp, cond_expr) in

    (* 3) Fresh labels *)
    let l_then, l_else, l_join =
      ( fresh_label current_class current_method
      , fresh_label current_class current_method
      , fresh_label current_class current_method )
    in

    (* 4) Then branch *)
    let then_instrs, then_expr, env2, ctx2 =
      convert current_class current_method env1 ctx1 then_branch
    in

    (* 5) Else branch *)
    let else_instrs, else_expr, env3, ctx3 =
      convert current_class current_method env2 ctx2 else_branch
    in

    (* 6) Allocate result temp *)
    let res_tmp = fresh_variable () in
    let res_loc = newloc        () in
    Hashtbl.add env3 res_tmp res_loc;
    Hashtbl.add ctx3.store res_loc  VoidValue;
    Hashtbl.add ctx3.meta  res_loc {
      offset   = ctx3.next_stack_offset;
      var_type = "Unknown";
      scope    = LocalVariable
    };
    let ctx3 = { ctx3 with
      env               = env3;
      next_stack_offset = ctx3.next_stack_offset - 8
    } in

    (* 6a) Copy both then_expr and else_expr into res_tmp *)
    let copy_into_res name ctx =
      let sl = Hashtbl.find env3 name in
      let vv = Hashtbl.find ctx.store sl in
      Hashtbl.replace ctx.store res_loc vv;
      let mm = Hashtbl.find ctx.meta sl in
      Hashtbl.replace ctx.meta res_loc { (Hashtbl.find ctx.meta res_loc) with
        var_type = mm.var_type
      }
    in
    (* copy for then branch value *)
    copy_into_res (match then_expr with TAC_Variable v -> v | _ -> assert false) ctx3;
    (* copy for else branch value *)
    copy_into_res (match else_expr with TAC_Variable v -> v | _ -> assert false) ctx3;

    (* 7) Assemble TAC *)
    let then_code =
      [ TAC_Comment "then branch"; TAC_Label l_then ]
      @ then_instrs
      @ [ TAC_Assign_Variable (res_tmp, tac_expr_to_string then_expr)
        ; TAC_Jump l_join
        ]
    in
    let else_code =
      [ TAC_Comment "else branch"; TAC_Label l_else ]
      @ else_instrs
      @ [ TAC_Assign_Variable (res_tmp, tac_expr_to_string else_expr)
        ; TAC_Jump l_join
        ]
    in
    let if_code =
      cond_instrs
      @ [ not_instr
        ; TAC_ConditionalJump (not_temp, l_else)
        ; TAC_ConditionalJump (tac_expr_to_string cond_expr, l_then)
        ]
      @ then_code
      @ else_code
      @ [ TAC_Comment "if-join"; TAC_Label l_join ]
    in

    ( if_code
    , TAC_Variable res_tmp
    , env3
    , ctx3 )
| AST_Assign (var_id, expr) ->
    (* 1) compute the RHS *)
    let instrs, rhs_expr, env1, ctx1 =
      convert current_class current_method env context expr
    in

    (* 2) figure out the string name of the RHS temp *)
    let src_name = match rhs_expr with
      | TAC_Variable v -> v
      | _ -> failwith "Expected TAC_Variable on RHS of assign"
    in

    (* 3) find source & target locations *)
    let src_loc = Hashtbl.find env1 src_name in
    let tgt     = snd var_id in
    let tgt_loc = Hashtbl.find env1 tgt in

    (* 4) copy the runtime value into the target *)
    let value   = Hashtbl.find ctx1.store src_loc in
    Hashtbl.replace ctx1.store tgt_loc value;

    (* 5) propagate the type metadata *)
    let src_meta = Hashtbl.find ctx1.meta src_loc in
    Hashtbl.replace ctx1.meta tgt_loc
      { (Hashtbl.find ctx1.meta tgt_loc) with
          var_type = src_meta.var_type
      };

    (* 6) emit the actual TAC instruction *)
    let assign_instr = TAC_Assign_Variable (tgt, src_name) in

    (* 7) now wrap it in your “result temp” logic *)
    let res_tmp = fresh_variable () in
    let res_loc = newloc       () in
    Hashtbl.add env1 res_tmp res_loc;
    (* copy that same value into the result temp *)
    Hashtbl.add ctx1.store res_loc value;
    (* and give it the same type *)
    Hashtbl.add ctx1.meta res_loc {
      offset   = ctx1.next_stack_offset;
      var_type = src_meta.var_type;
      scope    = LocalVariable
    };
    let ctx2 = { ctx1 with
      env               = env1;
      next_stack_offset = ctx1.next_stack_offset - 8
    } in
    let final_copy = TAC_Assign_Variable (res_tmp, tgt) in

    ( instrs @ [ assign_instr; final_copy ]
    , TAC_Variable res_tmp
    , env1
    , ctx2 )

| AST_Block exprs ->
    let rec process_block exprs env_acc ctx_acc =
      match exprs with
      | [] ->
        ([], TAC_Variable "void", env_acc, ctx_acc)

      | [last] ->
        convert current_class current_method env_acc ctx_acc last

      | first :: rest ->
        let first_instrs, _, env1, ctx1 =
          convert current_class current_method env_acc ctx_acc first
        in
        let rest_instrs, rest_expr, env2, ctx2 =
          process_block rest env1 ctx1
        in
        ( first_instrs @ rest_instrs
        , rest_expr
        , env2
        , ctx2 )
    in
    process_block exprs env context

 | AST_While (cond, body) ->
    (* reset labels *)
    label_counter := 0;
    let l_start = fresh_label current_class current_method in
    let l_pred  = fresh_label current_class current_method in
    let l_join  = fresh_label current_class current_method in
    let l_body  = fresh_label current_class current_method in

    (* 1) Evaluate the condition *)
    let cond_instrs, cond_expr, env1, ctx1 =
      convert current_class current_method env context cond
    in

    (* 2) Evaluate the body once (for CFG construction) *)
    let body_instrs, _, env2, ctx2 =
      convert current_class current_method env1 ctx1 body
    in

    (* 3) Allocate cond_var and copy its value *)
    let cond_var = fresh_variable () in
    let cond_loc = newloc           () in
    Hashtbl.add env2 cond_var cond_loc;
    Hashtbl.add ctx2.store cond_loc  VoidValue;
    Hashtbl.add ctx2.meta  cond_loc {
      offset   = ctx2.next_stack_offset;
      var_type = "Bool";
      scope    = LocalVariable
    };
    (* copy the evaluated condition into cond_loc *)
    let cond_src = match cond_expr with
      | TAC_Variable v -> v
      | _ -> assert false
    in
    let src_loc1 = Hashtbl.find env1 cond_src in
    let v1      = Hashtbl.find ctx2.store src_loc1 in
    Hashtbl.replace ctx2.store cond_loc v1;
    Hashtbl.replace ctx2.meta  cond_loc {
      (Hashtbl.find ctx2.meta cond_loc) with
        var_type = (Hashtbl.find ctx2.meta src_loc1).var_type
    };
    let ctx3 = { ctx2 with
      env               = env2;
      next_stack_offset = ctx2.next_stack_offset - 8
    } in

    (* 4) Allocate not_cond and compute its value *)
    let not_cond = fresh_variable () in
    let not_loc   = newloc           () in
    Hashtbl.add env2 not_cond not_loc;
    Hashtbl.add ctx3.store not_loc  VoidValue;
    Hashtbl.add ctx3.meta  not_loc {
      offset   = ctx3.next_stack_offset;
      var_type = "Bool";
      scope    = LocalVariable
    };
    (* eager negation in the store *)
    let orig_val = Hashtbl.find ctx3.store cond_loc in
    let neg_val  = match orig_val with
      | BoolValue b -> BoolValue (not b)
      | _           -> VoidValue
    in
    Hashtbl.replace ctx3.store not_loc neg_val;
    Hashtbl.replace ctx3.meta  not_loc {
      (Hashtbl.find ctx3.meta not_loc) with var_type = "Bool"
    };
    let ctx4 = { ctx3 with
      env               = env2;
      next_stack_offset = ctx3.next_stack_offset - 8
    } in

    (* 5) Allocate the default result slot *)
    let res_tmp = fresh_variable () in
    let res_loc = newloc           () in
    Hashtbl.add env2 res_tmp res_loc;
    Hashtbl.add ctx4.store res_loc  VoidValue;
    Hashtbl.add ctx4.meta  res_loc {
      offset   = ctx4.next_stack_offset;
      var_type = "Object";
      scope    = LocalVariable
    };
    let ctx5 = { ctx4 with
      env               = env2;
      next_stack_offset = ctx4.next_stack_offset - 8
    } in

    (* 6) Build the TAC sequence *)
    let code =
      [ TAC_Comment "start"
      ; TAC_Label   l_start
      ; TAC_Jump    l_pred
      ; TAC_Comment "while-pred"
      ; TAC_Label   l_pred
      ]
      @ cond_instrs
      @ [ TAC_Assign_Variable (cond_var,        tac_expr_to_string cond_expr)
        ; TAC_Assign_Not      (not_cond, TAC_Variable cond_var)
        ; TAC_ConditionalJump (not_cond,        l_join)
        ; TAC_ConditionalJump (cond_var,        l_body)
        ; TAC_Comment         "while-join"
        ; TAC_Label           l_join
        ; TAC_Assign_Default  (res_tmp, "Object")
        ; TAC_Return          res_tmp
        ; TAC_Comment         "while-body"
        ; TAC_Label           l_body
        ]
      @ body_instrs
      @ [ TAC_Jump l_pred ]
    in

    ( code
    , TAC_Variable res_tmp
    , env2
    , ctx5 )
| AST_DynamicDispatch (obj, method_name, args) ->
    (* 1) Evaluate the target object *)
    let obj_instrs, obj_expr, env1, ctx1 =
      convert current_class current_method env context obj
    in

    (* 2) Evaluate each argument *)
    let rec process_args args env_acc ctx_acc instrs_acc exprs_acc =
      match args with
      | [] ->
        ( List.rev instrs_acc
        , List.rev exprs_acc
        , env_acc
        , ctx_acc )
      | a :: rest ->
        let ai, ae, env', ctx' =
          convert current_class current_method env_acc ctx_acc a
        in
        process_args rest env' ctx'
          (ai :: instrs_acc)
          (tac_expr_to_string ae :: exprs_acc)
    in
    let arg_instrs_rev, arg_exprs, env2, ctx2 =
      process_args args env1 ctx1 [] []
    in
    let arg_instrs = List.concat (List.rev arg_instrs_rev) in

    (* 3) Allocate a temp for the call result *)
    let result = fresh_variable () in
    let rloc   = newloc           () in
    Hashtbl.add env2 result rloc;
    Hashtbl.add ctx2.store rloc   VoidValue;
    Hashtbl.add ctx2.meta  rloc {
      offset   = ctx2.next_stack_offset;
      var_type = "Unknown";   (* or the method’s return type *)
      scope    = LocalVariable
    };
    let ctx3 = { ctx2 with
      env               = env2;
      next_stack_offset = ctx2.next_stack_offset - 8
    } in

    (* 4) Emit the call *)
    let call_instr = TAC_Call (result, snd method_name, arg_exprs) in

    (* 5) Propagate the runtime result into the store & meta *)
    let vloc = rloc in
    let vval = Hashtbl.find ctx3.store vloc in
    Hashtbl.replace ctx3.store vloc vval;
    Hashtbl.replace ctx3.meta  vloc { (Hashtbl.find ctx3.meta vloc) with
      var_type = "Unknown"    (* update if you know the return type *)
    };

    (* 6) Return *)
    ( obj_instrs @ arg_instrs @ [ call_instr ]
    , TAC_Variable result
    , env2
    , ctx3 )


| AST_StaticDispatch (obj, _type_name, method_name, args) ->
    (* 1) Evaluate the target object *)
    let obj_instrs, obj_expr, env1, ctx1 =
      convert current_class current_method env context obj
    in

    (* 2) Evaluate each argument *)
    let rec process_args args env_acc ctx_acc instrs_acc exprs_acc =
      match args with
      | [] ->
        ( List.rev instrs_acc
        , List.rev exprs_acc
        , env_acc
        , ctx_acc )
      | a :: rest ->
        let ai, ae, env', ctx' =
          convert current_class current_method env_acc ctx_acc a
        in
        process_args rest env' ctx'
          (ai :: instrs_acc)
          (tac_expr_to_string ae :: exprs_acc)
    in
    let arg_instrs_rev, arg_exprs, env2, ctx2 =
      process_args args env1 ctx1 [] []
    in
    let arg_instrs = List.concat (List.rev arg_instrs_rev) in

    (* 3) Allocate a temp for the call result *)
    let result = fresh_variable () in
    let rloc   = newloc           () in
    Hashtbl.add env2 result rloc;
    Hashtbl.add ctx2.store rloc   VoidValue;
    Hashtbl.add ctx2.meta  rloc {
      offset   = ctx2.next_stack_offset;
      var_type = "Unknown";
      scope    = LocalVariable
    };
    let ctx3 = { ctx2 with
      env               = env2;
      next_stack_offset = ctx2.next_stack_offset - 8
    } in

    (* 4) Emit the call *)
    let call_instr = TAC_Call (result, snd method_name, arg_exprs) in

    (* 5) Propagate the runtime result into the store & meta *)
    let vloc = rloc in
    let vval = Hashtbl.find ctx3.store vloc in
    Hashtbl.replace ctx3.store vloc vval;
    Hashtbl.replace ctx3.meta  vloc { (Hashtbl.find ctx3.meta vloc) with
      var_type = "Unknown"
    };

    (* 6) Return *)
    ( obj_instrs @ arg_instrs @ [ call_instr ]
    , TAC_Variable result
    , env2
    , ctx3 )


| AST_SelfDispatch (method_name, args) ->
    (* Desugar into dynamic dispatch on “self” *)
    let self_exp = {
      loc         = "0";
      exp_kind    = AST_Identifier ("0", "self");
      static_type = None;
    } in
    let dyn = {
      loc         = a.loc;
      exp_kind    = AST_DynamicDispatch (self_exp, method_name, args);
      static_type = None;
    } in
    convert current_class current_method env context dyn


| AST_Case (expr, case_elements) ->
    (* 1) Evaluate the case expression *)
    let expr_instrs, expr_temp, env1, ctx1 =
      convert current_class current_method env context expr
    in

    (* 2) Allocate a temp to hold the case result *)
    let result   = fresh_variable () in
    let result_l = newloc           () in
    Hashtbl.add env1 result result_l;
    Hashtbl.add ctx1.store result_l   VoidValue;
    Hashtbl.add ctx1.meta  result_l {
      offset   = ctx1.next_stack_offset;
      var_type = "Unknown";   (* case expression’s result type *)
      scope    = LocalVariable
    };
    let ctx2 = { ctx1 with
      env               = env1;
      next_stack_offset = ctx1.next_stack_offset - 8
    } in

    (* 3) For each branch, convert its body and assign into result, propagating store *)
    let case_instrs, final_ctx =
      List.fold_left
        (fun (instrs, ctx_acc) (id, type_name, body) ->
           let body_is, body_temp, env_branch, ctx_branch =
             convert current_class current_method env1 ctx_acc body
           in
           (* emit the branch’s assignment *)
           let assign = TAC_Assign_Variable (result, tac_expr_to_string body_temp) in

           (* propagate into the store & meta *)
           let src_loc = Hashtbl.find env_branch
             (match body_temp with TAC_Variable v -> v | _ -> assert false)
           in
           let vval = Hashtbl.find ctx_branch.store src_loc in
           Hashtbl.replace ctx_branch.store result_l vval;
           let m    = Hashtbl.find ctx_branch.meta src_loc in
           Hashtbl.replace ctx_branch.meta result_l { (Hashtbl.find ctx_branch.meta result_l) with
             var_type = m.var_type
           };

           ( instrs @ body_is @ [ assign ]
           , ctx_branch
           )
        )
        ([], ctx2)
        case_elements
    in

    (* 4) Return the accumulated instructions and final context *)
    ( expr_instrs @ case_instrs
    , TAC_Variable result
    , env1
    , final_ctx )

| AST_Internal s ->
    (* 1) create a fresh temp and location *)
    let tmp  = fresh_variable () in
    let loc  = newloc           () in

    (* 2) bind in env *)
    Hashtbl.add env tmp loc;

    (* 3) placeholder in store & meta *)
    Hashtbl.add context.store loc VoidValue;
    Hashtbl.add context.meta  loc {
      offset   = context.next_stack_offset;
      var_type = "Object";       (* or actual return type if known *)
      scope    = LocalVariable
    };

    (* 4) bump the stack offset *)
    let ctx' = { context with
      env               = env;
      next_stack_offset = context.next_stack_offset - 8
    } in

    (* 5) emit the call *)
    let instrs = [ TAC_Call (tmp, s, []) ] in

    (* 6) propagate into store & meta *)
    Hashtbl.replace ctx'.store loc VoidValue;  (* call returns VoidValue here *)
    Hashtbl.replace ctx'.meta  loc { (Hashtbl.find ctx'.meta loc) with
      var_type = "Object"
    };

    ( instrs
    , TAC_Variable tmp
    , env
    , ctx' )


| AST_Let (bindings, body_exp) ->
    (* Each binding introduces one fresh temp dv and one stack slot *)
    let rec loop rem env ctx instrs =
      match rem with
      | [] ->
        (* All lets handled, now convert the body *)
        let body_is, body_e, final_env, final_ctx =
          convert current_class current_method env ctx body_exp
        in
        ( instrs @ body_is, body_e, final_env, final_ctx )

      | (var_id, type_id, init_opt) :: rest ->
        let vname = snd var_id in

        (* 1) Pick a fresh temp and slot for this binding *)
        let dv    = fresh_variable () in
        let dv_loc = newloc       () in
        Hashtbl.add env vname dv_loc;
        Hashtbl.add ctx.store dv_loc VoidValue;
        Hashtbl.add ctx.meta  dv_loc {
          offset   = ctx.next_stack_offset;
          var_type = snd type_id;
          scope    = LocalVariable
        };
        let ctx1 = { ctx with
          env               = env;
          next_stack_offset = ctx.next_stack_offset - 8
        } in

        (* 2) Generate code to initialize dv *)
        let init_is, init_expr, ctx2 =
          match init_opt with
          | Some e ->
            (* Recursively convert the initializer *)
            let is, e_expr, env', ctx' =
              convert current_class current_method env  ctx1 e
            in
            (is, e_expr, ctx')

          | None ->
            (* Emit a default‐constructor call into dv *)
            ([ TAC_Assign_Default (dv, snd type_id) ],
             TAC_Variable dv,
             ctx1)
        in

        (* 3) If the init_expr isn’t already in dv, copy it in *)
        let assign_dv =
          match init_expr with
          | TAC_Variable t when t = dv -> []
          | TAC_Variable t            -> [ TAC_Assign_Variable (dv, t) ]
          | _                         -> [ TAC_Assign_Variable (dv, tac_expr_to_string init_expr) ]
        in

        (* 4) Recurse on the rest, accumulating instructions *)
        loop rest env ctx2 (instrs @ init_is @ assign_dv)
    in

    (* Kick off with an empty instr list *)
    loop bindings env context [] 

let identify_leaders (instructions : tac_instr list) : int list =
    let rec find_leaders acc index instrs =
        match instrs with
        | [] -> List.rev acc
        | first_instr :: rest ->
            let acc' =
                if index = 0 then
                    index :: acc  
                else match first_instr with
                    | TAC_Label _ ->
                        index :: acc  
                    | _ -> (
                        match List.nth_opt instructions (index - 1) with
                        | Some (TAC_Jump _) | Some (TAC_ConditionalJump _) | Some (TAC_Return _) ->
                            index :: acc  (* Instructions following jumps are leaders *)
                        | _ -> acc)
            in
            (* mark instruction after conditional jump as a leader *)
            let acc'' = 
                match first_instr with
                | TAC_ConditionalJump _ -> 
                    if index + 1 < List.length instructions then
                        (index + 1) :: acc'  (* Next instruction is a leader *)
                    else
                        acc'
                | _ -> acc'
            in
            find_leaders acc'' (index + 1) rest
    in
    let all_leaders = find_leaders [] 0 instructions in
    List.sort_uniq compare all_leaders

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

    (* Create blocks from each leader to the next leader *)
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

(* build the control flow graph  *)
let build_cfg (blocks : basic_block list) : cfg =
    let cfg_map = Hashtbl.create (List.length blocks) in
    let label_to_block = create_label_to_block_map blocks in

    (* Add all blocks to the hashtable first *)
    List.iter (fun block -> Hashtbl.add cfg_map block.id block) blocks;

    (* Helper function to find the next block in sequence *)
    let find_next_block current_block =
        let rec find_next = function
            | [] -> None
            | [_] -> None  (* Last block has no next *)
            | b1 :: b2 :: rest ->
                if b1.id = current_block.id then
                    Some b2.id
                else
                    find_next (b2 :: rest)
        in
        find_next blocks
    in

    (* Update successors and predecessors *)
    List.iter (fun block ->
        (* Examine instructions for control flow *)
        let rec analyze_instrs instrs =
            match instrs with
            | [] -> 
                (* No control flow instructions found, fallthrough to next block *)
                (match find_next_block block with
                    | Some next_id -> [next_id]
                    | None -> [])
            | TAC_Jump label :: _ -> 
                (* Unconditional jump - single target *)
                (match Hashtbl.find_opt label_to_block label with
                    | Some target_block -> [target_block]
                    | None -> [])
            | TAC_ConditionalJump (_, label) :: rest ->
                (* Conditional jump - add jump target *)
                let jump_target = 
                    match Hashtbl.find_opt label_to_block label with
                    | Some target_block -> [target_block]
                    | None -> []
                in
                (* Add fallthrough target if there's no terminating instruction after *)
                (match rest with
                    | (TAC_Jump _) :: _ | (TAC_Return _) :: _ -> 
                        jump_target  (* No fallthrough - next instruction is terminating *)
                    | _ -> 
                        (* Find next block as fallthrough *)
                        match find_next_block block with
                        | Some next_id -> next_id :: jump_target
                        | None -> jump_target)
            | TAC_Return _ :: _ -> 
                []  (* Return has no successors *)
            | _ :: rest -> 
                analyze_instrs rest  (* Check next instruction *)
        in

        (* Get targets based on control flow in last instructions *)
        let targets = analyze_instrs (List.rev block.instructions) in

        (* Update current block's successors *)
        let block = Hashtbl.find cfg_map block.id in
        block.successors <- targets;

        (* Update predecessors of target blocks *)
        List.iter (fun target ->
            match Hashtbl.find_opt cfg_map target with
            | Some target_block ->
                if not (List.mem block.id target_block.predecessors) then
                    target_block.predecessors <- block.id :: target_block.predecessors
            | None -> ()
        ) targets
    ) blocks; 
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

(* Helper function for method generation code *)
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


(* Interanl methods taken form refernce compiler*)
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
                    "                        .quad " ^ label)
                all_methods
        in

        (* Build the VTable assembly for this class *)
        [
            "                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;";
            ".globl " ^ class_name ^ "..vtable";
            class_name ^ "..vtable:\t\t\t## virtual function table for " ^ class_name;
            "                        .quad string" ^ string_of_int string_num;
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



(* Helper function to lookup a variable's location and memory layout information *)
let lookup_variable context var =
  try
    (* First look in the environment to get the location *)
    let loc = Hashtbl.find context.env var in
    
    (* Then look up the memory layout information *)
    let layout = Hashtbl.find context.meta loc in
    
    (* Return both the location and layout *)
    Some (loc, layout)
  with Not_found ->
    None

(* Generate assembly for variable access based on its scope *)
let gen_variable_access context var =
  match lookup_variable context var with
  | Some (loc, layout) ->
      (* Generate appropriate access based on scope *)
      (match layout.scope with
      | ClassAttribute ->
          (* Class attributes are accessed through the object pointer (r12) *)
          Printf.sprintf "%d(%%r12)" layout.offset
      | LocalVariable ->
          (* Local variables are accessed through the stack pointer (rbp) *)
          Printf.sprintf "%d(%%rbp)" layout.offset
      | Parameter ->
          (* Parameters are accessed through the frame pointer (rbp) *)
          Printf.sprintf "%d(%%rbp)" layout.offset)
  | None ->
      (* Special handling for some cases *)
      if var = "self" then
        (* Self is always in r12 *)
        "%r12"
      else if String.length var >= 2 && String.sub var 0 2 = "t$" then
        (* Legacy handling for temporary variables that might not be in our new system *)
        let n = int_of_string (String.sub var 2 (String.length var - 2)) in
        Printf.sprintf "%d(%%rbp)" ((8 * n) * -1)
      else
        failwith ("Variable not found in environment: " ^ var)

(* Helper to get variable type *)
let get_variable_type context var =
  match lookup_variable context var with
  | Some (_, layout) -> layout.var_type
  | None -> "Object" (* Default type *)

(* Function to check if a value is stored in a register *)
(* let is_register var = *)
(*   var = "%rax" || var = "%rbx" || var = "%rcx" || var = "%rdx" || *)
(*   var = "%rsi" || var = "%rdi" || var = "%r8" || var = "%r9" || *)
(*   var = "%r10" || var = "%r11" || var = "%r12" || var = "%r13" || *)
(*   var = "%r14" || var = "%r15" *)
(**)
(*Functions preserve the registers rbx, rsp, rbp, r12, r13, r14, and r15;
while rax, rdi, rsi, rdx, rcx, r8, r9, r10, r11 are scratch registers. 
The return value is stored in the rax register*)


(* Given a temp or var name, find its offset from %rbp *)
let lookup_offset (ctx: context) (v: string) : int =
  let loc = Hashtbl.find ctx.env v in
  (Hashtbl.find ctx.meta loc).offset

(* Find the 0-based index of a field in a class’s attribute list *)
let attribute_index (class_info : class_info) (field_name : string) : int =
  class_info.attributes
  |> List.mapi (fun i (name, _typ, _init_opt) -> (name, i))
  |> List.assoc field_name

(* Lookup env & meta (as before) *)
let lookup_variable ctx v =
  try
    let loc    = Hashtbl.find ctx.env v in
    let layout = Hashtbl.find ctx.meta loc in
    Some (loc, layout)
  with Not_found ->
    None

(* Generate the address string for any variable v: *)
let gen_variable_address (ctx: context) (v: string) : string =
  match lookup_variable ctx v with
  | Some (loc, layout) ->
    (match layout.scope with
     | ClassAttribute ->
         (* 'loc' is the 0-based index of the field in the object *)
         let byte_off = 24 + (loc * 8) in
         Printf.sprintf "%d(%%r12)" byte_off
     | LocalVariable
     | Parameter ->
         (* locals & parameters live at layout.offset(%rbp) *)
         Printf.sprintf "%d(%%rbp)" layout.offset)

  | None ->
    if v = "self" then "%r12"
    else failwith ("Unknown variable in codegen: " ^ v)


let codegen context tac =
    (* Extract needed information from the new context structure *)
    let current_class = context.current_class in
    let current_method = context.current_method in
    let class_attributes = context.class_attributes in
    let env = context.env in
    let store = context.store in
    let meta = context.meta in
    let next_stack_offset = context.next_stack_offset in
    let self_loc = context.self_loc in

    match tac with
    | TAC_Comment text -> [ "                        ## " ^ text ]
    | TAC_Label label -> [ ".globl " ^ label; label ^ ":" ]
    | TAC_Assign_Variable (dest, src) ->
        (* Compute “ofs(%rbp)” or “ofs(%r12)” for both sides *)
        let src_addr = gen_variable_address context src in
        let dst_addr = gen_variable_address context dest in

        [ Printf.sprintf "                        ## %s <- %s" dest src
            ; Printf.sprintf "                        movq  %s, %%r13" src_addr
            ; Printf.sprintf "                        movq  %%r13, %s"   dst_addr
        ]

    | TAC_Assign_Int (dest, value) ->
        let addr = gen_variable_address context dest in
        [ Printf.sprintf "                        ## new int %s <- %d"
            dest value
            ; "                        pushq %rbp"
            ; "                        pushq %r12"
            ; "                        movq  $Int..new, %r14"
            ; "                        call  *%r14"
            ; "                        popq  %r12"
            ; "                        popq  %rbp"
            ; Printf.sprintf "                        movq  $%d, %%r14" value
            ; "                        movq  %r14, 24(%r13)"
            ; "                        movq  24(%r13), %r13"
            ; Printf.sprintf "                        movq  %%r13, %s" addr
        ]

(*     | TAC_Assign_Bool (dest, bool) ->  *)
(*         let loc = lookup_temp_location context dest in *)
(*         let base_lines = [ *)
(*             "                        ## new Bool " ^ dest ^ " <- " ^ string_of_bool bool; *)
(*             "                        pushq %rbp"; *)
(*             "                        pushq %r12"; *)
(*             "                        movq $Bool..new, %r14"; *)
(*             "                        call *%r14"; *)
(*             "                        popq %r12"; *)
(*             "                        popq %rbp"; *)
(*         ] in *)
(*         let set_value =  *)
(*             if bool then [ *)
(*                 "                        movq $1, %r14"; *)
(*                 "                        movq %r14, 24(%r13)"; *)
(*             ] else [] *)
(*         in *)
(*         let rest = [ *)
(*             "                        movq %r13, " ^ string_of_int loc.pointer_offset ^ "(%rbp)";  (* store pointer *) *)
(*             "                        movq 24(%r13), %r13";  (* load value again *) *)
(*             "                        movq %r13, " ^ string_of_int loc.value_offset ^ "(%rbp)";    (* store value *) *)
(*         ] *)
(*         in  *)
(*         base_lines @ set_value @ rest *)
    | TAC_Assign_String (dest, value) ->
        (* 1) Compute the stack slot for dest *)
        let addr_dest = gen_variable_address context dest in
        (* 2) The label for the literal data in .rodata *)
        let str_lbl   = get_string_label value in

        [ Printf.sprintf "                        ## new String %s <- \"%s\"" dest value
            ; "                        pushq %rbp"
            ; "                        pushq %r12"
            ; "                        movq  $String..new, %r14"
            ; "                        call  *%r14"            (* returns new object ptr in %r13 *)
            ; "                        popq  %r12"
            ; "                        popq  %rbp"
            ;Printf.sprintf "                        ## %s holds \"%s\"" str_lbl value
            ; "                        movq  $" ^ str_lbl ^", %r14"
 ; "                        movq  %r14, 24(%r13)"  
            ; Printf.sprintf "                        movq  %%r14, %s" addr_dest
        ]

    | TAC_Assign_Plus (dest, e1, e2) ->
        let s1    = tac_expr_to_string e1 in
        let s2    = tac_expr_to_string e2 in
        let a1    = gen_variable_address context s1 in
        let a2    = gen_variable_address context s2 in
        let adest = gen_variable_address context dest in
        [
            Printf.sprintf "                        ## %s <- %s + %s" dest s1 s2;
            Printf.sprintf "                        movq  %s, %%r13" a1;
            Printf.sprintf "                        addq  %s, %%r13" a2;
            Printf.sprintf "                        movq  %%r13, %s"   adest;
        ]
(*     | TAC_Assign_Minus (dest, e1, e2) -> *)
(*         let op1 = tac_expr_to_string e1 in *)
(*         let op2 = tac_expr_to_string e2 in *)
(*         let dest_locs = lookup_temp_location context dest in *)
(*         let op1_locs = lookup_temp_location context op1 in *)
(*         let op2_locs = lookup_temp_location context op2 in *)
(*         [ *)
(*             "                        ## " ^ dest ^ " <- " ^ op1 ^ " - " ^  op2; *)
(*             Printf.sprintf "                        movq %d(%%rbp), %%r13" op1_locs.value_offset; *)
(*             Printf.sprintf "                        movq %d(%%rbp), %%r14" op2_locs.value_offset; *)
(*             "                        subq %r14, %r13"; *)
(*             Printf.sprintf "                        movq %%r13, %d(%%rbp)" dest_locs.value_offset *)
(*         ] *)
(**)
(*     | TAC_Assign_Times (dest, e1, e2) -> *)
(*         let op1 = tac_expr_to_string e1 in *)
(*         let op2 = tac_expr_to_string e2 in *)
(*         let dest_locs = lookup_temp_location context dest in *)
(*         let op1_locs = lookup_temp_location context op1 in *)
(*         let op2_locs = lookup_temp_location context op2 in *)
(*         [ *)
(*             "                        ## " ^ dest ^ " <- " ^ op1 ^ " * " ^  op2; *)
(*             Printf.sprintf "                        movq %d(%%rbp), %%r13" op1_locs.value_offset; *)
(*             Printf.sprintf "                        movq %d(%%rbp), %%r14" op2_locs.value_offset; *)
(**)
(*             "movq %r14, %rax"; *)
(*             "imull %r13d, %eax"; *)
(*             "shlq $32, %rax   "; *)
(*             "shrq $32, %rax   "; *)
(*             "movl %eax, %r13d "; *)
(**)
(*             Printf.sprintf "                        movq %%r13, %d(%%rbp)" dest_locs.value_offset *)
(*         ] *)
(**)
(*     | TAC_Assign_Divide (dest, e1, e2, line_number) -> *)
(*         let op1 = tac_expr_to_string e1 in *)
(*         let op2 = tac_expr_to_string e2 in *)
(*         let dest_locs = lookup_temp_location context dest in *)
(*         let op1_locs = lookup_temp_location context op1 in *)
(*         let op2_locs = lookup_temp_location context op2 in *)
(*         let label_div_ok = fresh_label context.class_name context.method_name ^ "_div_ok" in *)
(*         let error_msg = "ERROR: " ^ line_number ^": Exception: division by zero\\n" in *)
(*         let div_err_label = get_string_label error_msg in *)
(*         [ *)
(*             "                        ## " ^ dest ^ " <- " ^ op1 ^ " / " ^ op2; *)
(*             Printf.sprintf "                        movq %d(%%rbp), %%r13" op2_locs.value_offset; *)
(*             "                        cmpq $0, %r13"; *)
(*             "           jne " ^ label_div_ok; *)
(**)
(*             Printf.sprintf "                        movq $%s, %%r13" div_err_label; *)
(*             "                        ## division by zero detected"; *)
(*             "                        ## guarantee 16-byte alignment before call"; *)
(*             "           andq $0xFFFFFFFFFFFFFFF0, %rsp"; *)
(*             "           movq %r13, %rdi"; *)
(*             "           call cooloutstr"; *)
(*             "                        ## guarantee 16-byte alignment before call"; *)
(*             "           andq $0xFFFFFFFFFFFFFFF0, %rsp"; *)
(*             "           movl $0, %edi"; *)
(*             "           call exit"; *)
(*             ".global "^ label_div_ok; *)
(*             label_div_ok ^ ":        ## division is okay "; *)
(*             Printf.sprintf "                        movq %d(%%rbp), %%r14" op1_locs.value_offset; *)
(*             "movq $0, %rdx"; *)
(*             "movq %r14, %rax"; *)
(*             "cdq"; *)
(*             "idivl %r13d"; *)
(*             "movq %rax, %r13"; *)
(*             Printf.sprintf "                        movq %%r13, %d(%%rbp)" dest_locs.value_offset *)
(*         ] *)
(*     | TAC_Assign_Negate (dest, value) -> *)
(*         let value_str = tac_expr_to_string value in *)
(*         let value_locs = lookup_temp_location context value_str in *)
(*         let dest_locs = lookup_temp_location context dest in *)
(*         [ *)
(*             "                        ## " ^ dest ^ " <- -" ^ value_str; *)
(*             (* Load original value into %r13 *) *)
(*             Printf.sprintf "                        movq %d(%%rbp), %%r13" value_locs.value_offset; *)
(*             "                        negq %r13";  (* Negate the value *) *)
(*             Printf.sprintf "                        movq %%r13, %d(%%rbp)" dest_locs.value_offset; *)
(**)
(*             "                        ## new Int for negated result"; *)
(*             "                        pushq %rbp"; *)
(*             "                        pushq %r12"; *)
(*             "                        movq $Int..new, %r14"; *)
(*             "                        call *%r14"; *)
(*             "                        popq %r12"; *)
(*             "                        popq %rbp"; *)
(**)
(*             (* Store negated value into boxed Int object *) *)
(*             Printf.sprintf "                        movq %d(%%rbp), %%r14" dest_locs.value_offset; *)
(*             "                        movq %r14, 24(%r13)"; *)
(**)
(*             (* Save pointer to boxed Int object *) *)
(*             Printf.sprintf "                        movq %%r13, %d(%%rbp)" dest_locs.pointer_offset; *)
(*         ] *)
(*     | TAC_Assign_Lt (dest, op1, op2) -> *)
(*         let op1_str = tac_expr_to_string op1 in *)
(*         let op2_str = tac_expr_to_string op2 in *)
(*         let op1_locs = lookup_temp_location context op1_str in *)
(*         let op2_locs = lookup_temp_location context op2_str in *)
(*         let dest_locs = lookup_temp_location context dest in *)
(*         [ *)
(*             Printf.sprintf "                        ## %s <- %s < %s " dest op1_str op2_str; *)
(*             (* Load pointers to object operands *) *)
(*             "                        ## " ^ tac_expr_to_string op1; *)
(*             Printf.sprintf "                        movq %d(%%rbp), %%r13" op1_locs.pointer_offset;  (* right operand *) *)
(*             "                        pushq %r13"; *)
(**)
(*             Printf.sprintf "                        movq %d(%%rbp), %%r13" op2_locs.pointer_offset;  (* left operand *) *)
(*             "                        pushq %r13"; *)
(*             "                        pushq %r12";  (* self object *) *)
(**)
(*             "                        call lt_handler"; *)
(*             "                        addq $24, %rsp";  (* 3 args = 24 bytes *) *)
(**)
(*             (* Store the returned Bool object pointer from %r13 *) *)
(*             Printf.sprintf "                        movq %%r13, %d(%%rbp)" dest_locs.pointer_offset; *)
(*             "                        movq 24(%r13), %r14";  (* Load value from returned object *) *)
(*             Printf.sprintf "                        movq %%r14, %d(%%rbp)" dest_locs.value_offset *)
(*         ] *)
(*     | TAC_Assign_Le (dest, op1, op2) -> *)
(*         let op1_str = tac_expr_to_string op1 in *)
(*         let op2_str = tac_expr_to_string op2 in *)
(*         let op1_locs = lookup_temp_location context op1_str in *)
(*         let op2_locs = lookup_temp_location context op2_str in *)
(*         let dest_locs = lookup_temp_location context dest in *)
(*         [ *)
(*             Printf.sprintf "                        ## %s <- %s <= %s " dest op1_str op2_str; *)
(*             (* Load pointers to object operands *) *)
(*             Printf.sprintf "                        movq %d(%%rbp), %%r13" op1_locs.pointer_offset;  (* right operand *) *)
(*             "                        pushq %r13"; *)
(*             Printf.sprintf "                        movq %d(%%rbp), %%r13" op2_locs.pointer_offset;  (* left operand *) *)
(*             "                        pushq %r13"; *)
(*             "                        pushq %r12";  (* self object *) *)
(**)
(*             "                        call le_handler"; *)
(*             "                        addq $24, %rsp";  (* 3 args = 24 bytes *) *)
(**)
(*             (* Store the returned Bool object pointer from %r13 *) *)
(*             Printf.sprintf "                        movq %%r13, %d(%%rbp)" dest_locs.pointer_offset; *)
(*             "                        movq 24(%r13), %r14";  (* Load value from returned object *) *)
(*             Printf.sprintf "                        movq %%r14, %d(%%rbp)" dest_locs.value_offset *)
(*         ] *)
(*     | TAC_Assign_Eq (dest, op1, op2) -> *)
(*         let op1_str = tac_expr_to_string op1 in *)
(*         let op2_str = tac_expr_to_string op2 in *)
(*         let op1_locs = lookup_temp_location context op1_str in *)
(*         let op2_locs = lookup_temp_location context op2_str in *)
(*         let dest_locs = lookup_temp_location context dest in *)
(*         [ *)
(*             Printf.sprintf "                        ## %s <- %s == %s" dest op1_str op2_str; *)
(*             (* Load pointers to object operands *) *)
(*             Printf.sprintf "                        movq %d(%%rbp), %%r13" op1_locs.pointer_offset;   *)
(*             "                        pushq %r13"; *)
(*             Printf.sprintf "                        movq %d(%%rbp), %%r13" op2_locs.pointer_offset;   *)
(*             "                        pushq %r13"; *)
(*             "                        pushq %r12";  (* self object *) *)
(**)
(*             "                        call eq_handler"; *)
(*             "                        addq $24, %rsp";  (* 3 args = 24 bytes *) *)
(**)
(*             (* Store the returned Bool object pointer from %r13 *) *)
(*             Printf.sprintf "                        movq %%r13, %d(%%rbp)" dest_locs.pointer_offset; *)
(*             "                        movq 24(%r13), %r14";  (* Load value from returned object *) *)
(*             Printf.sprintf "                        movq %%r14, %d(%%rbp)" dest_locs.value_offset *)
(*         ]     *)
| TAC_Return r ->
        [""] (* taken care of in method generation phase*)
| TAC_Call (dest, method_name, args) ->
  if method_name = "out_int" && List.length args = 1 then
    (* --- Special case for out_int --- *)
    let arg = List.hd args in
    let arg_addr = gen_variable_address context arg in
    let voff     = Hashtbl.find vtable_offsets (current_class, "out_int") in
    [

      "                        ## new Int";
      "                        pushq %rbp";
      "                        pushq %r12";
      "                        movq $Int..new, %r14";
      "                        call *%r14";
      "                        popq %r12";
      "                        popq %rbp";
      Printf.sprintf "                        movq  %s, %%r14" arg_addr;
      "                        movq %r14, 24(%r13)";
      "                        movq %r13,       0(%rbp)";


      "                        ## out_int(...)";
      (* save frame & self *)
      "                        pushq %r12";
      "                        pushq %rbp";
      (* wrap primitive into an Int object *)
      "                        ## "^ arg ;
      "                        movq 0(%rbp), %r13"  ;
      "                        pushq %r13";
      "                        pushq %r12";
  
      "                        ##  obtain vtable for self object of type " ^ current_class;
      "                        movq  16(%r12), %r14";                  (* load vptr *)
      "                        ##   look up out_int() at offset " ^ string_of_int (voff/8) ^" in vtable";
      Printf.sprintf "                        movq  %d(%%r14), %%r14" voff; (* load slot *)
      "                        call  *%r14";                              (* call out_int *)
      "                        addq  $16, %rsp";                          (* pop arg+self *)
      "                        popq  %rbp";
      "                        popq  %r12";
    ]
  else if  method_name = "out_string" && List.length args = 1 then
    let arg        = List.hd args in
    let str_lbl    = get_string_label arg in
    let voff       = Hashtbl.find vtable_offsets (current_class, "out_string") in
    [
      "                        ## out_string(...)";

      (* --- wrap the literal into a new String object --- *)
      "                        ## new String";
      "                        pushq %rbp";
      "                        pushq %r12";
      "                        movq  $String..new, %r14";
      "                        call  *%r14";               (* returns ptr in %r13 *)
      "                        popq  %r12";
      "                        popq %rbp";

      (* --- store the literal’s data pointer at offset 24(%r13) --- *)
      Printf.sprintf "                        ## %s holds \"%s\"" str_lbl arg;
      Printf.sprintf "                        movq  $%s, %%r14" str_lbl;
      "                        movq  %r14, 24(%r13)";

      (* --- now push that String object as the argument --- *)
      "                        pushq %r13";
      "                        pushq %r12";

      (* --- lookup out_string in the vtable and call it --- *)
      Printf.sprintf "                        ## obtain vtable for self object of type %s" current_class;
      "                        movq  16(%r12), %r14";                                              (* load vptr *)
      Printf.sprintf "                        ## look up out_string() at offset %d in vtable" (voff/8);
      Printf.sprintf "                        movq  %d(%%r14), %%r14" voff;                         (* load slot *)
      "                        call  *%r14";
      "                        addq  $16, %rsp";                                                  (* pop arg + self *)
      "                        popq %rbp";
      "                        popq %r12";
    ]  else
    (* --- Normal vtable‐dispatch for everything else --- *)
    let setup = [
      Printf.sprintf "                        ## %s(...)" method_name;
      "                        pushq %rbp";
      "                        pushq %r12";
    ] in
    let pushes =
      args
      |> List.mapi (fun i arg ->
           let addr = gen_variable_address context arg in
           [ Printf.sprintf "                        ## arg%d = %s" i arg
           ; Printf.sprintf "                        movq  %s, %%r13" addr
           ; "                        pushq %r13"
           ])
      |> List.concat
    in
    let voff = Hashtbl.find vtable_offsets (current_class, method_name) in
    let dispatch = [
      "                        ## lookup vtable";
      "                        movq  16(%r12), %r14";
      Printf.sprintf "                        movq  %d(%%r14), %%r14" voff;
      "                        call  *%r14";
      Printf.sprintf "                        addq  $%d, %%rsp" ((List.length args + 1) * 8);
      "                        popq %r12";
      "                        popq %rbp";
    ] in
    let store_dest =
      if dest = "" then [] else
        let addr = gen_variable_address context dest in
        [ Printf.sprintf "                        movq  %%r13, %s" addr ]
    in
    setup @ pushes @ dispatch @ store_dest
(*     | TAC_Assign_Not (dest, value) -> *)
(*         let value_str = tac_expr_to_string value in *)
(*         let value_locs = lookup_temp_location context value_str in *)
(*         let dest_locs = lookup_temp_location context dest in *)
(*         let true_label = fresh_label context.class_name context.method_name ^ "_true" in *)
(*         let false_label = fresh_label context.class_name context.method_name ^ "_false" in *)
(*         let end_label = fresh_label context.class_name context.method_name ^ "_end" in *)
(*         [ *)
(*             Printf.sprintf "                        ## %s <- not %s" dest value_str; *)
(*             (* Load boxed Bool pointer from temp slot *) *)
(*             Printf.sprintf "                        movq %d(%%rbp), %%r13" value_locs.pointer_offset; *)
(*             "                        movq 24(%r13), %r13";  (* Load actual Bool value (0 or 1) *) *)
(*             "                        cmpq $0, %r13";  (* Check if value is false (0) *) *)
(*             Printf.sprintf "            jne %s" true_label;  (* If 0 (false), jump to true_branch *) *)
(*             Printf.sprintf ".globl %s" false_label; *)
(*             false_label ^ ":"; *)
(*             "                        ## false branch"; *)
(*             "                        ## new Bool"; *)
(*             "                        pushq %rbp"; *)
(*             "                        pushq %r12"; *)
(*             "                        movq $Bool..new, %r14"; *)
(*             "                        call *%r14"; *)
(*             "                        popq %r12"; *)
(*             "                        popq %rbp"; *)
(*             "                        movq $1, %r14";  *)
(*             "                        movq %r14, 24(%r13)"; *)
(*             Printf.sprintf "                        jmp %s" end_label; *)
(*             Printf.sprintf ".globl %s" true_label; *)
(*             true_label ^ ":"; *)
(*             "                        ## true branch"; *)
(*             "                        ## new Bool"; *)
(*             "                        pushq %rbp"; *)
(*             "                        pushq %r12"; *)
(*             "                        movq $Bool..new, %r14"; *)
(*             "                        call *%r14"; *)
(*             "                        popq %r12"; *)
(*             "                        popq %rbp"; *)
(*             Printf.sprintf ".globl %s" end_label; *)
(*             end_label ^ ":            ## end of if conditional";                                 *)
(*             Printf.sprintf "                        movq %%r13, %d(%%rbp)" dest_locs.pointer_offset; *)
(*             "                        movq 24(%r13), %r14"; *)
(*             Printf.sprintf "                        movq %%r14, %d(%%rbp)" dest_locs.value_offset *)
(**)
(*         ] *)
(*     | TAC_ConditionalJump (cond, label) -> *)
(*         let cond_locs = lookup_temp_location context cond in *)
(*         [ *)
(*             "                        ## if " ^ cond ^ " jump to " ^ label; *)
(*             Printf.sprintf "                        movq %d(%%rbp), %%r13" cond_locs.pointer_offset; *)
(*             "                        movq 24(%r13), %r13"; *)
(*             "                        cmpq $0, %r13"; *)
(*             "                        jne " ^ label *)
(*         ]    | TAC_Jump label -> [ *)
(*         "                        ## unconditional jump to " ^ label; *)
(*         "                        jmp " ^ label *)
(*     ] *)
(**)
(**)
(*     | TAC_Assign_New (dest, class_name) -> *)
(*         let dest_locs = lookup_temp_location context dest in *)
(*         let class_name_str = tac_expr_to_string class_name in *)
(**)
(*         if class_name_str = "SELF_TYPE" then *)
(*             [ *)
(*                 "                        ## " ^ dest ^ " <- new SELF_TYPE"; *)
(*                 "                        pushq %rbp"; *)
(*                 "                        pushq %r12"; *)
(*                 "                        ## obtain vtable for self object"; *)
(*                 "                        movq 16(%r12), %r14"; *)
(*                 "                        ## look up constructor at offset 1 in vtable"; *)
(*                 "                        movq 8(%r14), %r14"; *)
(*                 "                        call *%r14"; *)
(*                 "                        popq %r12"; *)
(*                 "                        popq %rbp"; *)
(*                 (* Store object pointer into temp variable's pointer slot *) *)
(*                 Printf.sprintf "                        movq %%r13, %d(%%rbp)" dest_locs.pointer_offset; *)
(*                 (* Load value field (offset 24) from newly allocated object if needed *) *)
(*                 "                        movq 24(%r13), %r14"; *)
(*                 (* Store value into temp variable's value slot *) *)
(*                 Printf.sprintf "                        movq %%r14, %d(%%rbp)" dest_locs.value_offset; *)
(*             ] *)
(*         else *)
(*             [ *)
(*                 "                        ## " ^ dest ^ " <- new " ^ class_name_str; *)
(*                 "                        pushq %rbp"; *)
(*                 "                        pushq %r12"; *)
(*                 "                        movq $" ^ class_name_str ^ "..new, %r14"; *)
(*                 "                        call *%r14"; *)
(*                 "                        popq %r12"; *)
(*                 "                        popq %rbp"; *)
(*                 (* Store object pointer into temp variable's pointer slot *) *)
(*                 Printf.sprintf "                        movq %%r13, %d(%%rbp)" dest_locs.pointer_offset; *)
(*                 (* Load value field (offset 24) from newly allocated object *) *)
(*                 "                        movq 24(%r13), %r14"; *)
(*                 (* Store value into temp variable's value slot *) *)
(*                 Printf.sprintf "                        movq %%r14, %d(%%rbp)" dest_locs.value_offset; *)
(**)
(*             ]      *)
(*     | TAC_Assign (dest, expr) ->( *)
(*         let info = ["                      ##  Assign " ^dest^ " <- " ^ tac_expr_to_string expr ;] in *)
(*         info @ *)
(*         let dest_locs = lookup_temp_location context dest in *)
(*         match expr with *)
(*         | TAC_Variable src ->( *)
(*             if is_temp src then *)
(*                 let src_locs = lookup_temp_location context src in *)
(*                 [ *)
(*                     Printf.sprintf "movq %d(%%rbp), %%r13" src_locs.pointer_offset; *)
(*                     Printf.sprintf "movq %%r13, %d(%%rbp)" dest_locs.pointer_offset; *)
(*                     Printf.sprintf "movq %d(%%rbp), %%r13" src_locs.value_offset; *)
(*                     Printf.sprintf "movq %%r13, %d(%%rbp)" dest_locs.value_offset; *)
(*                 ] *)
(*             else *)
(*                 match lookup_variable_location context src with *)
(*                 | `Local src_locs -> *)
(*                     [ *)
(*                         Printf.sprintf "movq %d(%%rbp), %%r13" src_locs.pointer_offset; *)
(*                         Printf.sprintf "movq %%r13, %d(%%rbp)" dest_locs.pointer_offset; *)
(*                         Printf.sprintf "movq %d(%%rbp), %%r13" src_locs.value_offset; *)
(*                         Printf.sprintf "movq %%r13, %d(%%rbp)" dest_locs.value_offset; *)
(*                     ] *)
(*                 | `Param idx -> *)
(*                     let arg_off = 16 + (idx * 8) in *)
(*                     [ *)
(*                         Printf.sprintf "movq %d(%%rbp), %%r13" arg_off; *)
(*                         Printf.sprintf "movq %%r13, %d(%%rbp)" dest_locs.pointer_offset; *)
(*                     ] *)
(*                 | `Field field_off -> *)
(*                     [ *)
(*                         Printf.sprintf "movq %d(%%r12), %%r13" field_off; *)
(*                         Printf.sprintf "movq %%r13, %d(%%rbp)" dest_locs.pointer_offset; *)
(*                     ] *)
(*                 | `Temp _ -> *)
(*                     failwith "internal error: unexpected temp") *)
(*         | TAC_Int value -> *)
(*             [ *)
(*                 "pushq %rbp"; *)
(*                 "pushq %r12"; *)
(*                 "movq $Int..new, %r14"; *)
(*                 "call *%r14"; *)
(*                 "movq %rax, %r13"; *)
(*                 Printf.sprintf "movq $%d, 24(%%r13)" value; *)
(*                 Printf.sprintf "movq %%r13, %d(%%rbp)" dest_locs.pointer_offset; *)
(*                 Printf.sprintf "movq $%d, %d(%%rbp)" value dest_locs.value_offset; *)
(*             ] *)
(*         | TAC_Bool b -> *)
(*             let v = if b then 1 else 0 in *)
(*             [ *)
(*                 "pushq %rbp"; *)
(*                 "pushq %r12"; *)
(*                 "movq $Bool..new, %r14"; *)
(*                 "call *%r14"; *)
(*                 "movq %rax, %r13"; *)
(*                 Printf.sprintf "movq $%d, 24(%%r13)" v; *)
(*                 Printf.sprintf "movq %%r13, %d(%%rbp)" dest_locs.pointer_offset; *)
(*                 Printf.sprintf "movq $%d, %d(%%rbp)" v dest_locs.value_offset; *)
(*             ] *)
(*         | TAC_String lit -> *)
(*             let str_lbl = get_string_label lit in *)
(*             [ *)
(*                 "pushq %rbp"; *)
(*                 "pushq %r12"; *)
(*                 "movq $String..new, %r14"; *)
(*                 "call *%r14"; *)
(*                 "movq %rax, %r13"; *)
(*                 Printf.sprintf "movq $%s, %%r14" str_lbl; *)
(*                 "movq %r14, 24(%r13)"; *)
(*                 Printf.sprintf "movq %%r13, %d(%%rbp)" dest_locs.pointer_offset; *)
(*             ] *)
(*         | other -> *)
(*             failwith ("TAC_Assign not implemented for: " ^ tac_expr_to_string other) *)
(*     ) *)
(**)
   | TAC_Assign_Default (dest, type_name) ->

    let addr = gen_variable_address context dest in
    [
      Printf.sprintf "                        ## %s <- default %s" dest type_name;
      "                        pushq %rbp";
      "                        pushq %r12";
      Printf.sprintf "                        movq  $%s..new, %%r14" type_name;
      "                        call  *%r14";        (* returns in %r13 *)
      "                        popq  %r12";
      "                        popq  %rbp";
      Printf.sprintf "                        movq  %%r13, %s" addr;
    ]
(* *)
    | x -> failwith ("no asm for instruction: " ^ tac_instr_to_str x)


(* (TAC_Assign_IsVoid (_, _)|TAC_Assign_Call (_, _)| *)
(* TAC_StaticCall (_, _, _, _)|TAC_New (_, _)|TAC_IsVoid (_, _)| *)
(* TAC_Compare (_, _, _, _)|TAC_Not (_, _)|TAC_Negate (_, _)| *)
(**)

(*let constructor_lookup_field_offset context field =*)
(*  match List.find_opt (fun (name, _, _) -> name = field) context.class_attributes with*)
(*  | Some (_, _, index) -> 8 * index*)
(*  | None -> failwith ("constructor_lookup_field_offset: field not found: " ^ field)*)
(**)
(*let get_value_offset context operand =*)
(*  let name = tac_expr_to_string operand in*)
(*  let is_temp = String.length name >= 2 && String.sub name 0 2 = "t$" in*)
(*  if is_temp then*)
(*    let loc = lookup_temp_location context name in*)
(*    string_of_int loc.value_offset ^ "(%rbp)"*)
(*  else*)
(*    let offset = constructor_lookup_field_offset context name in*)
(*    string_of_int offset ^ "(%r12)"*)
(**)
(**)
(*let context = {*)
(*            class_attributes = attributes_with_index;*)
(*            temp_vars = temp_vars;*)
(*            params = [];*)
(*            class_name = class_name;*)
(*            method_name = "<init>";*)
(*          } in*)
(**)
(* let attributes_with_index *)
(*    List.mapi (fun idx (name, typ, _) -> (name, typ, idx + 3)) attributes*)
(*  in*)

(**)
(* let constructor_codegen context tac = *)
(*     let class_name = context.class_name in *)
(*     let method_name = context.method_name in *)
(*     let class_attrs = context.class_attributes in *)
(**)
(**)
(*     match tac with *)
(*     | TAC_Comment text -> [ "                        ## " ^ text ] *)
(*     | TAC_Label label -> [ ".globl " ^ label; label ^ ":" ] *)
(*     | TAC_Assign_Variable (dest, src) -> *)
(*         (* Case 1: t$n <- t$n *) *)
(*         if is_temp src && is_temp dest then *)
(*             let dest_locs = lookup_temp_location context dest in *)
(*             let src_locs = lookup_temp_location context src in *)
(*             [ *)
(*                 "                       ## " ^ dest ^ " <- " ^ src ^ " (temp <- temp)"; *)
(*                 Printf.sprintf "                       movq %d(%%rbp), %%r13" src_locs.pointer_offset; *)
(*                 Printf.sprintf "                       movq %%r13, %d(%%rbp)" dest_locs.pointer_offset; *)
(*                 Printf.sprintf "                       movq %d(%%rbp), %%r13" src_locs.value_offset; *)
(*                 Printf.sprintf "                       movq %%r13, %d(%%rbp)" dest_locs.value_offset; *)
(*             ] *)
(*         (* Case 2: t$n <- x *) *)
(*         else if is_temp dest then *)
(*             let field_offset = lookup_field_offset context src in *)
(*             let field_type = *)
(*                 match List.find_opt (fun (f, _, _) -> f = src) context.class_attributes with *)
(*                 | Some (_, typ, _) -> typ *)
(*                 | None -> failwith ("unknown field: " ^ src) *)
(*             in *)
(**)
(*             let dest_locs = lookup_temp_location context dest in *)
(*             match field_type with *)
(*             | "Int" | "Bool" -> [ *)
(**)
(*                 "                       ## "^dest ^" <- " ^ src; *)
(*                 "                       movq " ^ string_of_int field_offset ^ "(%r12), %r13";(* load pointer *) *)
(*                 "                       movq %r13, " ^ string_of_int dest_locs.pointer_offset ^ "(%rbp)";(* save pointer *) *)
(*                 "                       movq 24(%r13), %r13"; (* load value *) *)
(*                 "                       movq %r13, " ^ string_of_int  dest_locs.value_offset ^ "(%rbp)";(* save value *) *)
(*             ] *)
(*             | _ -> [ *)
(*                 "                       ## "^dest ^" <- " ^ src; *)
(*                 "                       movq " ^ string_of_int field_offset ^ "(%r12), %r13" ; *)
(*                 "                       movq %r13, " ^ string_of_int dest_locs.pointer_offset ^ "(%rbp)"; *)
(*             ] *)
(**)
(*         (* Case 3: x <- t$n *) *)
(*         else if is_temp src then *)
(*             let src_locs = lookup_temp_location context src in *)
(*             let field_offset = lookup_field_offset context dest in *)
(*             let dest_field_type = *)
(*                 match List.find_opt (fun (f, _, _) -> f = dest) context.class_attributes with *)
(*                 | Some (_, typ, _) -> typ *)
(*                 | None -> failwith ("unknown field: " ^ dest) *)
(*             in *)
(*             [ *)
(*                 Printf.sprintf "                        ## new %s %s <- %s" dest_field_type dest src; *)
(*                 "                        pushq %rbp"; *)
(*                 "                        pushq %r12"; *)
(*                 Printf.sprintf "                        movq $%s..new, %%r14" dest_field_type; *)
(*                 "                        call *%r14"; *)
(*                 "                        popq %r12"; *)
(*                 "                        popq %rbp"; *)
(*                 Printf.sprintf "                        movq %d(%%rbp), %%r14" src_locs.value_offset; *)
(*                 "                        movq %r14, 24(%r13)"; *)
(*                 Printf.sprintf "                        movq %%r13, %d(%%r12)" field_offset; *)
(*             ] *)
(*         (* Else fallback case *) *)
(*         else *)
(*             let dest_offset = lookup_offset context dest in *)
(*             let field_offset = lookup_field_offset context src in *)
(*             [ *)
(*                 "                       ## fallback "^dest ^" <- " ^ src ; *)
(*                 "                        movq " ^ string_of_int field_offset ^ "(%r12), %r13" ; *)
(*                 "                        movq %r13, " ^ string_of_int dest_offset ^ "(%rbp)" ; *)
(*             ] *)
(*     | TAC_Assign_Int (dest, value) -> *)
(*         let loc = lookup_temp_location context dest in *)
(**)
(*         [ *)
(*             "                        ## new int " ^ dest ^ " <- " ^ string_of_int value; *)
(*             "                        movq $" ^ string_of_int value ^ " ,$r13";    (* store value *) *)
(*         ] *)
(**)
(*     | TAC_Assign_Bool (dest, bool) ->  *)
(*         let loc = lookup_temp_location context dest in *)
(*         let base_lines = [ *)
(*             "                        ## new Bool " ^ dest ^ " <- " ^ string_of_bool bool; *)
(*             "                        pushq %rbp"; *)
(*             "                        pushq %r12"; *)
(*             "                        movq $Bool..new, %r14"; *)
(*             "                        call *%r14"; *)
(*             "                        popq %r12"; *)
(*             "                        popq %rbp"; *)
(*         ] in *)
(*         let set_value =  *)
(*             if bool then [ *)
(*                 "                        movq $1, %r14"; *)
(*                 "                        movq %r14, 24(%r13)"; *)
(*             ] else [] *)
(*         in *)
(*         let rest = [ *)
(*             "                        movq %r13, " ^ string_of_int loc.pointer_offset ^ "(%rbp)";  (* store pointer *) *)
(*             "                        movq 24(%r13), %r13";  (* load value again *) *)
(*             "                        movq %r13, " ^ string_of_int loc.value_offset ^ "(%rbp)";    (* store value *) *)
(*         ] *)
(*         in  *)
(*         base_lines @ set_value @ rest *)
(*     | TAC_Assign_String (dest, value) -> *)
(*         let string_label = get_string_label value in *)
(*         let loc = lookup_temp_location context dest in *)
(*         [ *)
(*             "                        ## new String " ^ dest ^ " <- \"" ^ value ^ "\""; *)
(*             "                        pushq %rbp"; *)
(*             "                        pushq %r12"; *)
(*             "                        movq $String..new, %r14"; *)
(*             "                        call *%r14"; *)
(*             "                        popq %r12"; *)
(*             "                        popq %rbp"; *)
(*             Printf.sprintf "                        ## %s holds \"%s\"" string_label value; *)
(*             Printf.sprintf "                        movq $%s, %%r14" string_label; *)
(*             "                        movq %r14, 24(%r13)";  (* store string data inside object *) *)
(*             Printf.sprintf "                        movq %%r13, %d(%%rbp)" loc.pointer_offset; *)
(*         ] *)
(*     | TAC_Assign_Plus (dest, e1, e2) -> *)
(*         let op1 = tac_expr_to_string e1 in *)
(*         let op2 = tac_expr_to_string e2 in *)
(*         let dest_locs = lookup_temp_location context dest in *)
(*         let op1_locs = lookup_temp_location context op1 in *)
(*         let op2_locs = lookup_temp_location context op2 in *)
(*         [ *)
(*             "                        ## " ^ dest ^ " <- " ^ op1 ^ " + " ^  op2; *)
(*             Printf.sprintf "                        movq %d(%%rbp), %%r13" op1_locs.value_offset; *)
(*             Printf.sprintf "                        movq %d(%%rbp), %%r14" op2_locs.value_offset; *)
(*             "                        addq %r14, %r13"; *)
(*             Printf.sprintf "                        movq %%r13, %d(%%rbp)" dest_locs.value_offset *)
(*         ] *)
(*     | TAC_Assign_Not (dest, value)-> *)
(*         []   *)
(*     | TAC_Assign_Minus (dest, e1, e2) -> *)
(*         let op1 = tac_expr_to_string e1 in *)
(*         let op2 = tac_expr_to_string e2 in *)
(*         let dest_locs = lookup_temp_location context dest in *)
(*         let op1_locs = lookup_temp_location context op1 in *)
(*         let op2_locs = lookup_temp_location context op2 in *)
(*         [ *)
(*             "                        ## " ^ dest ^ " <- " ^ op1 ^ " + " ^  op2; *)
(*             Printf.sprintf "                        movq %d(%%rbp), %%r13" op1_locs.value_offset; *)
(*             Printf.sprintf "                        movq %d(%%rbp), %%r14" op2_locs.value_offset; *)
(*             "                        subq %r14, %r13"; *)
(*             Printf.sprintf "                        movq %%r13, %d(%%rbp)" dest_locs.value_offset *)
(*         ] *)
(**)
(*     | TAC_Assign_Times (dest, e1, e2) -> *)
(*         let op1 = tac_expr_to_string e1 in *)
(*         let op2 = tac_expr_to_string e2 in *)
(*         let dest_locs = lookup_temp_location context dest in *)
(*         let op1_locs = lookup_temp_location context op1 in *)
(*         let op2_locs = lookup_temp_location context op2 in *)
(*         [ *)
(*             "                        ## " ^ dest ^ " <- " ^ op1 ^ " * " ^  op2; *)
(*             Printf.sprintf "                        movq %d(%%rbp), %%r13" op1_locs.value_offset; *)
(*             Printf.sprintf "                        movq %d(%%rbp), %%r14" op2_locs.value_offset; *)
(*             "            imulq %r14, %r13"; *)
(*             Printf.sprintf "                        movq %%r13, %d(%%rbp)" dest_locs.value_offset *)
(*         ] *)
(**)
(*     | TAC_Assign_Divide (dest, e1, e2, line_number) -> *)
(*         let op1 = tac_expr_to_string e1 in *)
(*         let op2 = tac_expr_to_string e2 in *)
(*         let dest_locs = lookup_temp_location context dest in *)
(*         let op1_locs = lookup_temp_location context op1 in *)
(*         let op2_locs = lookup_temp_location context op2 in *)
(*         let label_div_ok = fresh_label context.class_name context.method_name ^ "_div_ok" in *)
(*         let error_msg = "ERROR: " ^ line_number ^": Exception: division by zero\\n" in *)
(*         let div_err_label = get_string_label error_msg in *)
(*         [ *)
(*             "                        ## " ^ dest ^ " <- " ^ op1 ^ " / " ^ op2; *)
(*             Printf.sprintf "                        movq %d(%%rbp), %%r13" op2_locs.value_offset; *)
(*             "                        cmpq $0, %r13"; *)
(*             "           jne " ^ label_div_ok; *)
(**)
(*             Printf.sprintf "                        movq $%s, %%r13" div_err_label; *)
(*             "                        ## division by zero detected"; *)
(*             "                        ## guarantee 16-byte alignment before call"; *)
(*             "           andq $0xFFFFFFFFFFFFFFF0, %rsp"; *)
(*             "           movq %r13, %rdi"; *)
(*             "           call cooloutstr"; *)
(*             "                        ## guarantee 16-byte alignment before call"; *)
(*             "           andq $0xFFFFFFFFFFFFFFF0, %rsp"; *)
(*             "           movl $0, %edi"; *)
(*             "           call exit"; *)
(*             ".global "^ label_div_ok; *)
(*             label_div_ok ^ ":        ## division is okay "; *)
(*             Printf.sprintf "                        movq %d(%%rbp), %%r14" op1_locs.value_offset; *)
(*             "           movq $0, %rdx"; *)
(*             "           movq %r14, %rax"; *)
(*             "           cdq"; *)
(*             "           idivq %r13"; *)
(*             "           movq %rax, %r13"; *)
(*             Printf.sprintf "                        movq %%r13, %d(%%rbp)" dest_locs.value_offset *)
(*         ] *)
(*     | TAC_Assign_Negate (dest, value) -> *)
(*         let value_str = tac_expr_to_string value in *)
(*         let value_locs = lookup_temp_location context value_str in *)
(*         let dest_locs = lookup_temp_location context dest in *)
(*         [ *)
(*             "                        ## " ^ dest ^ " <- -" ^ value_str; *)
(*             (* Load original value into %r13 *) *)
(*             Printf.sprintf "                        movq %d(%%rbp), %%r13d" value_locs.value_offset; *)
(*             "                        negl %r13d";  (* Negate the value *) *)
(*             Printf.sprintf "                        movq %%r13, %d(%%rbp)" dest_locs.value_offset; *)
(**)
(*             "                        ## new Int for negated result"; *)
(*             "                        pushq %rbp"; *)
(*             "                        pushq %r12"; *)
(*             "                        movq $Int..new, %r14"; *)
(*             "                        call *%r14"; *)
(*             "                        popq %r12"; *)
(*             "                        popq %rbp"; *)
(**)
(*             (* Store negated value into boxed Int object *) *)
(*             Printf.sprintf "                        movq %d(%%rbp), %%r14" dest_locs.value_offset; *)
(*             "                        movq %r14, 24(%r13)"; *)
(**)
(*             (* Save pointer to boxed Int object *) *)
(*             Printf.sprintf "                        movq %%r13, %d(%%rbp)" dest_locs.pointer_offset; *)
(*         ] *)
(*     | TAC_Assign_Lt (dest, op1, op2) -> *)
(*         let op1_str = tac_expr_to_string op1 in *)
(*         let op2_str = tac_expr_to_string op2 in *)
(*         let op1_locs = lookup_temp_location context op1_str in *)
(*         let op2_locs = lookup_temp_location context op2_str in *)
(*         let dest_locs = lookup_temp_location context dest in *)
(*         [ *)
(*             Printf.sprintf "                        ## %s <- %s < %s" dest op1_str op2_str; *)
(*             (* Move operands into registers *) *)
(*             Printf.sprintf "                        movq %d(%%rbp), %%r13" op1_locs.value_offset; *)
(*             Printf.sprintf "                        movq %d(%%rbp), %%r14" op2_locs.value_offset; *)
(**)
(*             (* Call lt_handler with r13 and r14 as arguments *) *)
(*             "                        pushq %r14";  (* second argument *) *)
(*             "                        pushq %r13";  (* first argument *) *)
(*             "                        pushq %r12";  (* self pointer if needed by handler *) *)
(*             "                        call lt_handler"; *)
(*             "                        addq $24, %rsp";  (* clean up 3 pushes *) *)
(**)
(*             (* Save result pointer (r13 points to Bool object) *) *)
(*             Printf.sprintf "                        movq %%r13, %d(%%rbp)" dest_locs.pointer_offset; *)
(*             "                        movq 24(%r13), %r14";  (* Load actual boolean value from object *) *)
(*             Printf.sprintf "                        movq %%r14, %d(%%rbp)" dest_locs.value_offset; *)
(*         ] *)
(*     | TAC_Assign_Le (dest, op1, op2) -> *)
(*         let op1_str = tac_expr_to_string op1 in *)
(*         let op2_str = tac_expr_to_string op2 in *)
(*         let op1_locs = lookup_temp_location context op1_str in *)
(*         let op2_locs = lookup_temp_location context op2_str in *)
(*         let dest_locs = lookup_temp_location context dest in *)
(*         [ *)
(*             "                        ## " ^ dest ^ " <- " ^ op1_str ^ " <= " ^ op2_str; *)
(*             Printf.sprintf "                        movq %d(%%rbp), %%r13" op1_locs.value_offset; *)
(*             Printf.sprintf "                        movq %d(%%rbp), %%r14" op2_locs.value_offset; *)
(*             "                        cmpq %r14, %r13"; *)
(*             "                        setle %r15b"; *)
(*             "                        movzbq %r15b, %r15"; *)
(*             Printf.sprintf "                        movq %%r15, %d(%%rbp)" dest_locs.value_offset *)
(*         ] *)
(*     | TAC_Assign_Eq (dest, op1, op2) -> *)
(*         let op1_str = tac_expr_to_string op1 in *)
(*         let op2_str = tac_expr_to_string op2 in *)
(*         let op1_locs = lookup_temp_location context op1_str in *)
(*         let op2_locs = lookup_temp_location context op2_str in *)
(*         let dest_locs = lookup_temp_location context dest in *)
(*         [ *)
(*             "                        ## " ^ dest ^ " <- " ^ op1_str ^ " == " ^ op2_str; *)
(*             Printf.sprintf "                        movq %d(%%rbp), %%r13" op1_locs.value_offset; *)
(*             Printf.sprintf "                        movq %d(%%rbp), %%r14" op2_locs.value_offset; *)
(*             "                        cmpq %r14, %r13"; *)
(*             "                        sete %r15b"; *)
(*             "                        movzbq %r15b, %r15"; *)
(*             Printf.sprintf "                        movq %%r15, %d(%%rbp)" dest_locs.value_offset *)
(*         ] *)
(**)
(*     | TAC_Return r -> *)
(*         [""] (* taken care of in method generation phase*) *)
(**)
(*     (* For TAC_Call *) *)
(*  | TAC_Call (dest, method_name, args) -> *)
(*     (* Create a comment that includes the method name and arguments *) *)
(*     let args_str = String.concat ", " args in  *)
(*     let call_setup = [ *)
(*         "                        ## " ^ method_name ^ "(" ^ args_str ^ ")"; *)
(*         "                        pushq %r12"; *)
(*         "                        pushq %rbp" *)
(*     ] in *)
(*        (* let arg_pushes = List.fold_left (fun acc arg -> *) *)
(*        (*      if String.length arg >= 2 && String.sub arg 0 2 = "t$" then *) *)
(*        (*          let arg_loc = lookup_temp_location context arg in *) *)
(*        (*          acc @ [ *) *)
(*        (*              "                        ## arg " ^ arg ^ " (pointer)"; *) *)
(*        (*              Printf.sprintf "                        movq %d(%%rbp), %%r13" arg_loc.pointer_offset; *) *)
(*        (*              "                        pushq %r13" *) *)
(*        (*          ] *) *)
(*        (*      else *) *)
(*        (*          let field_offset = lookup_field_offset context arg in *) *)
(*        (*          acc @ [ *) *)
(*        (*              "                        ## arg " ^ arg ^ " (field)"; *) *)
(*        (*              Printf.sprintf "                        movq %d(%%r12), %%r13" field_offset; *) *)
(*        (*              "                        pushq %r13" *) *)
(*        (*          ] *) *)
(*        (*  ) [] args in *) *)
(*     (* For each argument, prepare and box it *) *)
(*     let arg_pushes = List.mapi (fun i arg -> *)
(**)
(*         if String.length arg >= 2 && String.sub arg 0 2 = "t$" then *)
(*             (* It's a temporary variable *) *)
(*             let arg_loc = lookup_temp_location context arg in *)
(*             [ *)
(*                 "                        ## box arg " ^ string_of_int (i+1) ^ ": " ^ arg; *)
(*                 Printf.sprintf "                        movq %d(%%rbp), %%r13" arg_loc.value_offset; *)
(*                 "                        pushq %rbp"; *)
(*                 "                        pushq %r12"; *)
(*                 "                        movq $Object..new, %r14";  (* NOTE: try and incorporate constructor based on type *) *)
(*                 "                        call *%r14"; *)
(*                 "                        popq %r12"; *)
(*                 "                        popq %rbp"; *)
(*                 "                        movq -16(%rbp), %r14";  (* Get correct pointer from stack not correct yet *) *)
(*                 "                        movq %r13, 24(%r14)";   (* Store the value in the boxed object *) *)
(*                 "                        movq %r14, %r13";       (* Move boxed object to r13 for pushing *) *)
(*                 "                        pushq %r13" *)
(*             ] *)
(*         else *)
(*             (* It's a field or other expression *) *)
(*             let field_offset = lookup_field_offset context arg in *)
(*             [ *)
(*                 "                        ## box arg " ^ string_of_int (i+1) ^ ": " ^ arg; *)
(*                 Printf.sprintf "                        movq %d(%%r12), %%r13" field_offset; *)
(*                 "                        pushq %rbp"; *)
(*                 "                        pushq %r12"; *)
(*                 "                        movq $Object..new, %r14";   *)
(*                 "                        call *%r14"; *)
(*                 "                        popq %r12"; *)
(*                 "                        popq %rbp"; *)
(*                 "                        movq -16(%rbp), %r14";   *)
(*                 "                        movq %r13, 24(%r14)";   *)
(*                 "                        movq %r14, %r13";      *)
(*                 "                        pushq %r13" *)
(*             ] *)
(*     ) args |> List.concat in *)
(**)
(*     let call_and_cleanup =  *)
(*         (* Look up the method's offset from the vtable_offsets *) *)
(*         let method_offset = *)
(*             try  *)
(*                 Hashtbl.find vtable_offsets (class_name, method_name) *)
(*             with Not_found -> *)
(*                 failwith ("Method not found in vtable: " ^ class_name ^ "." ^ method_name) *)
(*         in *)
(*         [ *)
(*             "                        pushq %r12"; *)
(*             "                        ## obtain vtable for self object of type " ^ class_name; *)
(*             "                        movq 16(%r12), %r14"; *)
(*             "                        ## look up " ^ method_name ^ "() at offset " ^ string_of_int (method_offset / 8) ^ " in vtable"; *)
(*             "                        movq " ^ string_of_int method_offset ^ "(%r14), %r14"; *)
(*             "                        call *%r14"; *)
(*             "                        addq $" ^ string_of_int ((List.length args + 1) * 8) ^ ", %rsp"; *)
(*             "                        popq %rbp"; *)
(*             "                        popq %r12" *)
(*         ] in *)
(**)
(*     (* Store result if needed *) *)
(*     let store_result =  *)
(*         if dest <> "" then *)
(*             let dest_locs = lookup_temp_location context dest in *)
(*             [ *)
(*                 Printf.sprintf "                        movq %%r13, %d(%%rbp)" dest_locs.pointer_offset; *)
(*                 "                        movq 24(%r13), %r14"; *)
(*                 Printf.sprintf "                        movq %%r14, %d(%%rbp)" dest_locs.value_offset *)
(*             ] *)
(*         else [] in  *)
(**)
(*     call_setup @ arg_pushes @ call_and_cleanup @ store_result        (*let store_result = *) *)
(*         (*    if dest <> "" then*) *)
(*         (*        ["                        movq %r13, 24(%r12)"] (*hardcoded*)*) *)
(*         (*    else*) *)
(*         (*        []*) *)
(*         (*in*) *)
(*         (**) *)
(*     | TAC_ConditionalJump (cond, label) -> [ *)
(*         "                   ## "^ cond ^ " x " ^label; *)
(*     ] *)
(*     | TAC_Jump label -> [ *)
(*         "                    ## jmp "^ label; *)
(*     ] *)
(**)
(**)
(**)
(*     | TAC_Assign_New (dest, class_name) -> *)
(*         let dest_locs = lookup_temp_location context dest in *)
(*         [ *)
(*             "                        ## " ^ dest ^ " <- new " ^ tac_expr_to_string class_name; *)
(*             "                        pushq %rbp"; *)
(*             "                        pushq %r12"; *)
(*             "                        movq $" ^ tac_expr_to_string class_name ^ "..new, %r14"; *)
(*             "                        call *%r14"; *)
(*             "                        popq %r12"; *)
(*             "                        popq %rbp"; *)
(**)
(*             (* Store object pointer into temp variable’s pointer slot *) *)
(*             Printf.sprintf "                        movq %%r13, %d(%%rbp)" dest_locs.pointer_offset; *)
(**)
(*             (* Load value field (offset 24) from newly allocated object *) *)
(*             "                        movq 24(%r13), %r14"; *)
(**)
(*             (* Store value into temp variable’s value slot *) *)
(*             Printf.sprintf "                        movq %%r14, %d(%%rbp)" dest_locs.value_offset; *)
(*         ] *)
(**)
(*     (* | TAC_Assign_Lt *) *)
(*     (* | TAC_Assign_Le *) *)
(*     (* | TAC_Assign_Negate  *) *)
(*     (* | TAC_Assign_IsVoid of string * tac_expr *) *)
(*     (* | TAC_Assign_New of string * tac_expr *) *)
(*     (* | TAC_Assign_Call of string * tac_expr *) *)
(*     (* | TAC_Assign_Eq of string * tac_expr * tac_expr *) *)
(*     (* | TAC_Label of string (* label L1 *) *) *)
(*     (* | TAC_StaticCall of string * string * string * string list *) *)
(*     (* | TAC_New of string * string *) *)
(*     (* | TAC_IsVoid of string * string *) *)
(*     (* | TAC_Compare of string * string * string * string *) *)
(*     (* | TAC_Negate of string * string *) *)
(*     (* | TAC_Comment of string *) *)
(*     (* | TAC_Assign_Default of string * string *) *)
(*     (**) *)
(**)
(*     | x -> failwith ("no asm for tac instr in constructor: " ^ tac_instr_to_str tac ^ "\n") *)
(**)
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


(* print crazy initializers*)
let rec pretty_print_expr (e : exp) : string =
    match e.exp_kind with
    | AST_Integer i -> i
    | AST_String s -> "\"" ^ s ^ "\""
    | AST_True -> "true"
    | AST_False -> "false"
    | AST_Identifier (_, name) -> name
    | AST_Plus (e1, e2) ->
        pretty_print_expr e1 ^ " + " ^ pretty_print_expr e2
    | AST_Minus (e1, e2) ->
        pretty_print_expr e1 ^ " - " ^ pretty_print_expr e2
    | AST_Times (e1, e2) ->
        pretty_print_expr e1 ^ " * " ^ pretty_print_expr e2
    | AST_Divide (e1, e2) ->
        pretty_print_expr e1 ^ " / " ^ pretty_print_expr e2
    | AST_Lt (e1, e2) ->
        pretty_print_expr e1 ^ " < " ^ pretty_print_expr e2
    | AST_Le (e1, e2) ->
        pretty_print_expr e1 ^ " <= " ^ pretty_print_expr e2
    | AST_Eq (e1, e2) ->
        pretty_print_expr e1 ^ " = " ^ pretty_print_expr e2
    | AST_Negate e1 ->
        " ~ " ^ pretty_print_expr e1
    | AST_Not e1 ->
        "not " ^ pretty_print_expr e1
    | _ -> "complex_expr"  (* fallback for blocks, lets, etc. *)

(* Generate constructor for user-defined classes *)
let generate_custom_constructor class_map class_name
    (attributes : (string * string * exp option) list) =
    let constructor_label = class_name ^ "..new" in
    let class_tag = get_class_tag class_name in
    (* object size: 3 words (for tag, size, vtable) plus one word per attribute *)
    let object_size = 3 + List.length attributes in
    let vtable_label = class_name ^ "..vtable" in

    (* Convert attributes to include index *)
    let attributes_with_index =
        List.mapi (fun idx (name, typ, _) -> (name, typ, idx + 3)) attributes
    in

    (* Record explicitly initialized fields *)
    List.iter 
        (fun (attr_name, _, init_opt) -> 
            match init_opt with
            | Some _ -> record_explicit_initializer class_name attr_name
            | None -> ())
        attributes;

    (* Generate default initialization code for all attributes - keeping exactly as is *)
    let default_init_lines =
        ["                        ## initialize attributes"] @
        (List.mapi
            (fun idx (attr_name, attr_type, _) ->
                let offset = 24 + (idx * 8) in
                if attr_type = "Object" || attr_type = "IO" then
                    [ "                        ## self["
                        ^ string_of_int (idx + 3)
                        ^ "] holds field " ^ attr_name ^ " (" ^ attr_type ^ ")";
                        "                        movq $0, %r13";
                        "                        movq %r13, " ^ string_of_int offset^"(%r12)";
                    ]
                else 
                    [
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
            |> List.flatten)
    in

    reset_newloc_counter ();
    
    (* Create a hashtable with class info for use in initializers *)
    let class_attributes_table = Hashtbl.create 10 in
    let class_info = { 
        name = class_name;
        parent = None;  (* Assuming no parent info needed here *)
        attributes = attributes;
        methods = [];  (* Assuming no methods needed here *)
    } in
    Hashtbl.add class_attributes_table class_name class_info;
    
    (* Generate TAC for initializers *)
    let tac_for_initializers =
        List.mapi
            (fun idx (attr_name, attr_type, init_opt) ->
                match init_opt with
                | None -> (idx, [], TAC_Variable "dummy", 0)
                | Some expr ->
                    let initial_env = Hashtbl.create 10 in
                    let initial_store = Hashtbl.create 10 in
                    let initial_meta = Hashtbl.create 10 in
                    
                    (* Create self location *)
                    let self_loc = newloc () in
                    Hashtbl.add initial_env "self" self_loc;
                    
                    (* Initialize a new context with our proper structure *)
                    let initial_context = {
                        env = initial_env;
                        store = initial_store;
                        meta = initial_meta;
                        class_attributes = class_attributes_table;
                        current_class = class_name;
                        current_method = "init";
                        next_stack_offset = 0;
                        self_loc = self_loc;
                    } in
                    
                    (* Reset temp counter for TAC generation *)
                    reset_newloc_counter();
                    
                    let tac_instrs, tac_result, _, _ = 
                        convert class_name "init" initial_env initial_context expr in
                        
                    (* Get the total number of locations allocated *)
                    let temp_count = !newloc_counter - 2 in
                    (idx, tac_instrs, tac_result, temp_count))
            attributes
    in

    (* Get max stack space needed from all initializers *)
    let max_temp_count =
        List.fold_left (fun acc (_, _, _, tc) -> max acc tc) 0 tac_for_initializers
    in

    let total_stack_space = ((max_temp_count * 8) + 15) / 16 * 16 in

    (* Generate code for explicit initializers *)
    let initializer_lines =
        List.map
            (fun (idx, tac_instrs, tac_result, _) ->
                let attr_name, attr_type, init_opt = List.nth attributes idx in
                let offset = 24 + (idx * 8) in
                
                match init_opt with
                | None -> 
                    [ "                        ## self[" ^ string_of_int (idx + 3) ^ "] " ^ attr_name ^ " initializer -- none" ]
                    
                | Some expr ->
                    (* Create a new environment for this initializer *)
                    let env = Hashtbl.create 10 in
                    let store = Hashtbl.create 10 in
                    let meta = Hashtbl.create 10 in
                    
                    (* Create self location *)
                    let self_loc = newloc () in
                    Hashtbl.add env "self" self_loc;
                    
                    (* Add meta information for the attribute in the object *)
                    let attr_loc = newloc () in
                    let attr_mem_info = {
                        offset = offset;
                        var_type = attr_type;
                        scope = ClassAttribute;
                    } in
                    Hashtbl.add meta attr_loc attr_mem_info;
                    
                    (* Setup context for code generation *)
                    let initializer_context = {
                        env = env;
                        store = store;
                        meta = meta;
                        class_attributes = class_attributes_table;
                        current_class = class_name;
                        current_method = "init";
                        next_stack_offset = -8;  (* Start allocating stack space *)
                        self_loc = self_loc;
                    } in

                    (* Create header comment for initializer *)
                    let init_header = [
                        "                        ## self[" ^ string_of_int (idx + 3) ^ "] " ^ attr_name ^ " initializer <- " ^
                        (match expr.exp_kind with
                            | AST_String s -> "\"" ^ s ^ "\""
                            | AST_Integer i -> i
                            | AST_True -> "true"
                            | AST_False -> "false"
                            | _ -> pretty_print_expr expr)
                    ] in

                    (* Generate code for the initialization expression *)
                    let init_code = List.concat_map (codegen initializer_context) tac_instrs in
                    
                    (* Get the result variable name from TAC *)
                    let result_var =
                        match tac_result with
                        | TAC_Variable name -> name
                        | _ -> failwith "Expected TAC_Variable as final result in initializer"
                    in
                    
                    (* Generate code to store the result in the attribute *)
                    let store_code =
                        match lookup_variable initializer_context result_var with
                        | Some (result_loc, result_layout) ->
                            let src_access = 
                                match result_layout.scope with
                                | ClassAttribute -> Printf.sprintf "%d(%%r12)" result_layout.offset
                                | LocalVariable | Parameter -> Printf.sprintf "%d(%%rbp)" result_layout.offset
                            in
                            
                            [
                                "                        ## Store result to attribute " ^ attr_name;
                                Printf.sprintf "                        movq %s, %%r13" src_access;
                                Printf.sprintf "                        movq %%r13, %d(%%r12)" offset
                            ]
                            
                        | None ->
                            (* Handle legacy temporary variable case *)
                            if String.length result_var >= 2 && String.sub result_var 0 2 = "t$" then
                                let temp_n = int_of_string (String.sub result_var 2 (String.length result_var - 2)) in
                                let temp_offset = (8 * temp_n) * -1 in
                                
                                [
                                    "                        ## Store result from legacy temp to attribute " ^ attr_name;
                                    Printf.sprintf "                        movq %d(%%rbp), %%r13" temp_offset;
                                    Printf.sprintf "                        movq %%r13, %d(%%r12)" offset
                                ]
                            else
                                failwith ("Result variable not found: " ^ result_var)
                    in
                    
                    init_header @ init_code @ store_code
            )
            tac_for_initializers
        |> List.flatten
    in 

    (* Keeping footer exactly as is *)
    let footer =
        [
            "                        movq %r12, %r13";
            "                        ## return address handling";
            "                        movq %rbp, %rsp";
            "                        popq %rbp";
            "                        ret";
        ]
    in

    (* Keeping base_lines exactly as is *)
    let base_lines =
        [
            "                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;";
            ".globl " ^ constructor_label;
            constructor_label ^ ":              ## constructor for " ^ class_name;
            "                        pushq %rbp";
            "                        movq %rsp, %rbp";
            "                        ## stack room for temporaries: "^ string_of_int max_temp_count;
            "                        movq $"^string_of_int total_stack_space ^", %r14";
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

let topological_sort (cfg : cfg) : string list =
    (* Create a dependency count map (in-degree for each block) *)
    let dependency_count = Hashtbl.create (Hashtbl.length cfg) in

    (* Initialize all blocks with zero dependencies *)
    Hashtbl.iter (fun id _ -> 
        Hashtbl.add dependency_count id 0
    ) cfg;

    (* Count dependencies (incoming edges) for each block *)
    Hashtbl.iter (fun _ block ->
        List.iter (fun succ_id ->
            if Hashtbl.mem cfg succ_id then
                let count = 
                    if Hashtbl.mem dependency_count succ_id then
                        Hashtbl.find dependency_count succ_id + 1
                    else 1
                in
                Hashtbl.replace dependency_count succ_id count
        ) block.successors
    ) cfg;

    (* Initialize queue with blocks that have no dependencies *)
    let queue = ref [] in
    Hashtbl.iter (fun id count ->
        if count = 0 then queue := id :: !queue
    ) dependency_count;

    (* Process queue in order (no need to sort for CFG) *)
    let sorted_blocks = ref [] in

    while !queue <> [] do
        (* Get next block from queue *)
        let block_id = List.hd !queue in
        queue := List.tl !queue;

        (* Add to sorted result *)
        sorted_blocks := block_id :: !sorted_blocks;

        (* Process successors *)
        if Hashtbl.mem cfg block_id then
            let block = Hashtbl.find cfg block_id in
            List.iter (fun succ_id ->
                if Hashtbl.mem dependency_count succ_id then
                    let count = Hashtbl.find dependency_count succ_id - 1 in
                    Hashtbl.replace dependency_count succ_id count;
                    if count = 0 then
                        queue := succ_id :: !queue
            ) block.successors
    done;

    (* Check for cycles *)
    if List.length !sorted_blocks <> Hashtbl.length cfg then
        failwith "Topological sort error: the CFG has at least one cycle"
    else
        List.rev !sorted_blocks

let generate_method_definition
    class_name
    method_name
    params
    return_type
    body
    class_map
    parent_map
  =
  (* 0) Helpers for printing *)
  let pad n s = Printf.sprintf "%-*s" n s in

  (* 1) Compute labels & attributes *)
  let method_label = class_name ^ "." ^ method_name in
  let attributes = get_class_attributes class_map parent_map class_name in
  let attributes_comments =
    List.map
      (fun (fn, ft, idx) ->
         Printf.sprintf "    ## self[%d] holds %s (%s)" idx fn ft)
      attributes
  in

  (* 2) Reset all counters *)
  reset_temp_var_counter ();
  reset_label_counter   ();
  reset_newloc_counter  ();

  (* 3) Build initial env/store/meta/context *)
  let initial_env   = Hashtbl.create 16 in
  let initial_store = Hashtbl.create 16 in
  let initial_meta  = Hashtbl.create 16 in
  let self_loc      = newloc () in
  Hashtbl.add initial_env "self" self_loc;

  (* parameters at 16(%rbp),24(%rbp),… *)
  let param_base = 16 in
  List.iteri
    (fun i p ->
       let loc = newloc () in
       Hashtbl.add initial_env p loc;
       Hashtbl.add initial_meta loc {
         offset   = param_base + i*8;
         var_type = "Object";
         scope    = Parameter;
       })
    params;

  let class_tbl = Hashtbl.create 4 in
  let ci = {
    name       = class_name;
    parent     = None;
    attributes = List.map (fun (n,t,_) -> (n,t,None)) attributes;
    methods    = [(method_name, params, body)];
  } in
  Hashtbl.add class_tbl class_name ci;

  let initial_context = {
    env               = initial_env;
    store             = initial_store;
    meta              = initial_meta;
    class_attributes  = class_tbl;
    current_class     = class_name;
    current_method    = method_name;
    next_stack_offset = -8;
    self_loc;
  } in

  (* 4) Convert to TAC *)
  let tac_instrs, final_expr, _, final_ctx =
    convert class_name method_name initial_env initial_context body
  in
  let return_var = match final_expr with
    | TAC_Variable v -> v
    | _              -> "t$0"
  in
  let tac_full = tac_instrs @ [ TAC_Return return_var ] in

  (* 5) Decide how many temps → stack bytes *)
  let num_temps   = get_temp_var_count () in
  let stack_bytes = ((num_temps*8)+15)/16*16 in

  let header = [
        "                        ## ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;";
    Printf.sprintf ".globl %s" method_label;
    Printf.sprintf "%s:              ## method definition" method_label;
    "                        pushq %rbp";
    "                        movq  %rsp, %rbp";
        "                        movq  16(%rbp), %r12";
    Printf.sprintf "                        ## stack room for temporaries: %d" num_temps;
    Printf.sprintf "                        movq  $%d, %%r14" stack_bytes;
        "                        subq %r14, %rsp";
            "                        ## return address handling";
            "                        ## method body begins";
  ]
  @ List.map (fun s -> "    " ^ s) attributes_comments
  in

  (* 7) Dump the final context *)
  let dump_context ctx =
    Printf.printf "\n==== TAC/CTX DUMP ====\n";
    Printf.printf "Class: %s, Method: %s\n" ctx.current_class ctx.current_method;
    Printf.printf "Next offset: %d, self @ %d\n\n"
      ctx.next_stack_offset ctx.self_loc;

    Printf.printf "-- ENVIRONMENT (var → loc) --\n";
    Hashtbl.iter (fun v l ->
      Printf.printf "  %-8s → %d\n" v l)
      ctx.env;

    Printf.printf "\n-- STORE (loc → value) --\n";
    Hashtbl.iter (fun l v ->
      let vs = match v with
        | IntValue i        -> "Int:"^string_of_int i
        | BoolValue b       -> "Bool:"^string_of_bool b
        | StringValue(_,s)  -> "Str:\""^s^"\""
        | ObjectValue o     -> "Obj:"^o.class_name
        | VoidValue         -> "Void"
      in
      Printf.printf "  loc %-3d → %s\n" l vs)
      ctx.store;

    Printf.printf "\n-- META (loc → ofs,type,scope) --\n";
    Hashtbl.iter (fun l mi ->
      let sc = match mi.scope with
        | ClassAttribute -> "Attr"
        | LocalVariable  -> "Local"
        | Parameter      -> "Param"
      in
      Printf.printf
        "  loc %-3d → {ofs:%3d, type:%-6s, %s}\n"
        l mi.offset mi.var_type sc)
      ctx.meta;

   Printf.printf "\n-- CLASS ATTRIBUTES --\n";
    Hashtbl.iter
      (fun class_name ci ->
         (* Header for the class *)
         Printf.printf "Class: %s\n" class_name;
         Printf.printf "Parent: %s\n"
           (match ci.parent with Some p -> p | None -> "None");
         (* Fields *)
         Printf.printf "Attributes:\n";
         List.iter
           (fun (field_name, field_type, init_opt) ->
              Printf.printf "  %-12s : %-8s%s\n"
                field_name
                field_type
                (match init_opt with None -> "" | Some _ -> "  [has init]"))
           ci.attributes;
         (* Methods *)
         Printf.printf "Methods:\n";
         List.iter
           (fun (mname, params, _) ->
              Printf.printf "  %-12s(%s)\n"
                mname
                (String.concat ", " params))
           ci.methods;
         Printf.printf "\n")
      ctx.class_attributes;

    Printf.printf "==== END DUMP ====\n\n%!";
  in 
  dump_context final_ctx;

  (* 8) Build CFG *)
  let leaders      = identify_leaders tac_full in
  let blocks       = create_basic_blocks tac_full leaders in
  let cfg          = build_cfg blocks in
  let sorted_ids   = topological_sort cfg in

  (* 9) Generate body via your codegen *)
  let body_asm =
    List.concat_map (fun bid ->
      let blk = Hashtbl.find cfg bid in
      let hdr = [Printf.sprintf "                        ## block %s" blk.id] in
      let code =
        List.concat_map (fun instr ->
          codegen final_ctx instr
        ) blk.instructions
      in
      hdr @ code
    ) sorted_ids
  in

    let epilogue = [
        Printf.sprintf ".globl %s.end" method_label;
        Printf.sprintf "%s.end:          ## method body ends" method_label;
        "                        ## return address handling";
        "                        movq %rbp, %rsp";
        "                        popq %rbp";
        "                        ret";
    ] in


  (* final assembly lines *)
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

(* helper and entry functions taking from reference compiler*)
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
        let class_name = snd class_id in
        let method_name = snd method_id in
        
        (* Create initial environment, store, and meta tables *)
        let initial_env = Hashtbl.create 10 in
        let initial_store = Hashtbl.create 10 in
        let initial_meta = Hashtbl.create 10 in
        
        (* Create self location *)
        let self_loc = newloc () in
        Hashtbl.add initial_env "self" self_loc;
        
        (* Create parameter locations and add to environment *)
        let param_index_start = 16 in (* Start at 16 bytes offset from RBP *)
        let param_locs = List.mapi
            (fun i (param_id, param_type) ->
                let param_name = snd param_id in
                let loc = newloc () in
                Hashtbl.add initial_env param_name loc;
                
                (* Create metadata for the parameter *)
                let param_info = {
                    offset = param_index_start + (i * 8);
                    var_type = snd param_type;
                    scope = Parameter;
                } in
                Hashtbl.add initial_meta loc param_info;
                
                (param_name, loc))
            formals
        in
        
        (* Create an empty class attributes table for now *)
        let class_attributes_table = Hashtbl.create 10 in
        
        (* Create initial context with our new structure *)
        let initial_context = {
            env = initial_env;
            store = initial_store;
            meta = initial_meta;
            class_attributes = class_attributes_table;
            current_class = class_name;
            current_method = method_name;
            next_stack_offset = -8; (* Start allocating stack space below frame pointer *)
            self_loc = self_loc;
        } in
        
        (* Convert method body to TAC instructions *)
        let tac_instrs, result_expr, final_env, final_context =
            convert class_name method_name initial_env initial_context body
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
        
        (* Print debug information about the context after TAC generation *)
        let debug_context ctx =
            Printf.printf "\n=== TAC GENERATION CONTEXT FOR %s.%s ===\n" 
                class_name method_name;
            
            (* Print environment size *)
            Printf.printf "Environment entries: %d\n" (Hashtbl.length ctx.env);
            
            (* Print meta entries count *)
            Printf.printf "Meta entries: %d\n" (Hashtbl.length ctx.meta);
            
            (* Print parameters *)
            Printf.printf "Parameters:\n";
            List.iter 
                (fun (name, loc) ->
                    let meta_info = Hashtbl.find_opt ctx.meta loc in
                    match meta_info with
                    | Some info -> 
                        Printf.printf "  %s: loc=%d, offset=%d, type=%s\n" 
                            name loc info.offset info.var_type
                    | None -> 
                        Printf.printf "  %s: loc=%d (no meta info)\n" name loc)
                param_locs;
            
            (* Print next stack offset *)
            Printf.printf "Next stack offset: %d\n" ctx.next_stack_offset;
            
            Printf.printf "=== END TAC CONTEXT ===\n\n";
            flush stdout
        in
        
        (* Print debug information *)
        debug_context final_context;
        
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
