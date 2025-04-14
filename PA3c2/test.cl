class Main inherits IO{
    x : Int <- 0;
    y : Int <- 4;
    main () : Object{
        {
            x <- x - 5;
            x <- y * 4 + 5 - 4;
            out_string("hi\n");
            out_int(x);
        }
    };
};
