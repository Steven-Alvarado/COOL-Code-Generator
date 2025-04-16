class Main inherits IO{
    x : Int <- 5;
    y : Int;
    main () : Object{
        {
        x <- in_int();
        y <- x + 10 - 5 * 3 * 5 / 34;
        y <- 32 - 84 * 3 / 8 * 32;
        out_int(y);
        out_string("\n");
        out_string("finally\n");
        }
    };
};
