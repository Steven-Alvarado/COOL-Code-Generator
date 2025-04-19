class Main inherits IO{
    x : Int <- 5 - 32 - 84 * 3 / 8 * 32 + 9000 - ~43;
    z : Bool <- not true;

    y : Int;
    main () : Object{
        {
        out_string("Enter a number\n");
        x <- in_int();
        y <- x + 10 - 5 * 3 * 5 / 34 + ~523245 -24 / ~54;
        y <- y - 32 - 84 * 3 / 8 * 32 + 9000 - ~43;
        out_int(y);
        out_string("\n");
        out_string("finally\n");
        if  not (not z) then out_string("uh\n") else out_string("maybe\n") fi; 
        }
    };
};
