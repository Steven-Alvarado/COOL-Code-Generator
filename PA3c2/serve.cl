class Main inherits IO{
    x : Int;
    y : Int;
    z : Int;
    t : Bool;
    main () : Object{
        {
            z <- 49 - 235 + 43;
            x <- 4 +  y * z *2;
            out_int(z + 43);
            t <- not ( z = x);
                if t then 
                    out_int( x)
                else
                    out_int(z /x)
                        fi;
        }
    };
};
