class Main inherits IO {
    x : Int <- 5;
    y : Int <- 43 * 4 / x + 2 -4345;
    z : Int;
    d : Int;
    main() : Object{
        {
            z <- y * x;
            y <- x - z;
            x <- x - z + y * 89 * 3 * 4335 * 232342- z;

            out_int(x);
            out_string("\n");
        }
    };
};
