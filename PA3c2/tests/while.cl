class Main inherits IO{
    i :  Int <- 0;
    main () : Object {
        while ( i <= 10) loop {
            out_int(i);
            out_string("\n");
            i <- i + 1;
        } pool
    };
};
