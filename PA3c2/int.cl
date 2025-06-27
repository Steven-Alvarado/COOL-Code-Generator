class Main inherits IO{
x : Int <- 3 + 43 + 232;
    main () : Object{
        {
            out_int(x);
            let x : Int in {
                x <- 4;
                out_string("\n");
                out_int(x);
            };
        }
    };
};
