class Main inherits IO{
        x : Bool;
        y : Bool;
 
    main () : Object {
       {
        x <- (5 <= 5);
        y <- (10 = 10);
        if (x) then
            out_string("yes")
            else
            out_string("no")
        fi;

        out_string("\n");
        }
    };
};
