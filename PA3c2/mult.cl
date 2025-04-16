class Main inherits IO{
    x : Int <- 5;
    y : Int <- 100;
    main () : Object{
        {
        x <- x * y;
        out_int(x);
        out_string("\n");
        }
    };
};
