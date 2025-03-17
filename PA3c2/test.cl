class Main inherits IO{
    x : Int <- 0;
    main () : Object{
        while (x <= 30) loop {
            x <- x + 5;
            out_int(x);
            out_string("\n");
        } pool 
    };
};
