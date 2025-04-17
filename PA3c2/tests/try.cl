class Main inherits IO{
    x : Int <- 1;
    y : Int <- 5;
    z : Int <- x;
    s : String;
    main () : Object{
        {
            out_string(" enter string: \n");
            s <- in_string();
            out_string("enter int:\n");
            x <- in_int();
            x <- y + x + z;
            out_int(x);
            out_string(" :D yayy\n");
            out_string(s);
            out_string("\n");
        }
    };
};
