class Main inherits IO
{
    z : Int <- 5;
    main () : Object{
        {
        z <- z + 1;
        out_int(z);
        out_string("\n");
        }
    };
};
