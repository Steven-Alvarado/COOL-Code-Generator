class Main inherits IO{
    x : Int <- 5;
    y : Int <- ~10;
    (*) z : Bool <- ( x > y) *)
    main () : Object{
        {
        if x < y then 
            out_string("<\n")
        else
            out_string("not <\n")
        fi;
        if x <= y then
            out_string("<=\n")
        else 
            out_string("not <=\n")
        fi;
        if not (x <= y) then
            out_string(">\n")
            else 
             out_string("not >\n")
         fi;
        }
    };
};
