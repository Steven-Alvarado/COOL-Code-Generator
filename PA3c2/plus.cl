class Main inherits IO {
    x : Int <- 4;
    y : Int <- 6;
    main () : Object{
        {
        x <- in_int();
        x <- x + 3 + 4;
        out_int(x);
        out_string("\n");
       } 
    };
};
