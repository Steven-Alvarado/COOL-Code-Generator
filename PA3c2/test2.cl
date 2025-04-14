class Main inherits IO{
    x : String <- "Hello\n";
    y : String <- "inbetween\n";
    z : Int;

    main () : Object {
        {
        z <- 5;
        out_string(" World\n");
        out_string(" after");
        out_int(z);
        }
    };
};
