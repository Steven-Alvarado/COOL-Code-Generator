class Main inherits IO
{
    x : Int;
    z : Int <- 5;
    main () : Object{
        {
        x <- 10;
        z <- z + x;
        z <- 5+ 4 + x + 10 - 3 - 100;
        z <- 5 - x + z -40;
        out_int(z);
        out_string("\n");
        }
    };
};
