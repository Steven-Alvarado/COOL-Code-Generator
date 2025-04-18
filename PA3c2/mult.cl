class Main inherits IO{
    z  : Bool <- true;
    x : Int <- 5;
    y : Int <- x * 4 / x + 4 * x / 2;
    main () : Object{
        {
        x <- x * y;
        y <- x * ~4 - y / ~x;
        out_int(~y);
        out_string("\n");
        }
    };
};
