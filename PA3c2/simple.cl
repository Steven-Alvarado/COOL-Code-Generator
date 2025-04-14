class Main inherits IO
{
    x : Int <- 5;
    y : String <- "hi\n";
    z : Int;
    main () : Object{
        {
        z <- x + 1;
        out_int(z);
        out_string("\n");
        }
    };
};
