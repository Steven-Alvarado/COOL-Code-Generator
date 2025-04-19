class Main inherits IO {
    main () : Object{
        let x : Int , y : Int in {
        x <- in_int();
        x <- 3+ 3 + 4 + x;
        out_int(x);
        out_string("\n");
       } 
    };
};
