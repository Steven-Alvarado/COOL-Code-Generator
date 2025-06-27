class Main inherits IO{
    x : Int;
    y : Int;
    z : Int;
    t : Bool;
    main () : Object{
        {
            z <- 49 - 235 + 43;
            x <- 4 +  y * z *2;
            out_int(z);
            t <-  (z<x);
                if t then {
                    out_string(" t\n");
                    out_int(x);
                }
                else{
                    out_string("o\n");
                    out_int(z);
                }
                fi;
        }
    };
};
