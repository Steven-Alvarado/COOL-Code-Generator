class Main inherits IO{
    x : Int <- 1;
    y : Int <- 5;
    z : Int <- x;
    main () : Object{
        {
     x <- y + x + z;
    out_int(x);
    out_string(" :D yayy\n");
        }
    };
};
