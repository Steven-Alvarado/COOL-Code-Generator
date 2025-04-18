class Main inherits IO{
    z  : Bool <- not (4 <= 2);
    x : Int <- 5;
    y : Int <- x * 4 / x + 4 -x * x / 2;
    main () : Object{
        {
            x <- x * y;
            y <- x * ~4 - y / ~x;
            out_int(~y);
            out_string("\n");
            if not z then 
                out_int(y / ~3)
            else
                out_string("no")
            fi;
        }
    };
};
