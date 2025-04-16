class Main inherits IO {
    x : Int <- 5;
    y : Int <- 43;
    z : Int;
    main() : Object{
        {
            z <- y * x;
            y <- x - z;
            x <- x - z + y * 89 * 3 - z;
            out_int(x);
            out_string("\n");
        }
    };
};
