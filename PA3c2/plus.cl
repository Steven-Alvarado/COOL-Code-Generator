class Main inherits IO {
    x : Int <- 4;
    y : Int <- 6;
    main () : Object{
        {
        x <- y + x;
        out_int(y);
       } 
    };
};
