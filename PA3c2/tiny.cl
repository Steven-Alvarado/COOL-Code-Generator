class Main inherits IO{
    x : Int <- ~10;
    y : Int;
    main () : Object{
        {
       y <- x + ~10 ;
       out_int(y);
       out_string("\n");
        }
    };
};
