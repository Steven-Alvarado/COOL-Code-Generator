class Main inherits IO{
x : Int <- 4;
y : Bool <- not false;
obj1 : Object;
obj2 : Object;
       main () : Object{
           {
               if y then out_string("not true\n")
                   else out_string("actually true\n")
                fi;
               (** Object comparisons *)
                   obj1 <- new Object;
               obj2 <- new Object;
               out_string("\n= comparison (Object !=): ");
               out_int(if obj1 = obj2 then 1 else 0 fi);    (** 0 *)

                   out_string("\n= comparison (Object =): ");
               out_int(if obj1 = obj1 then 1 else 0 fi);    (** 1 *)
           } 
       };
};
