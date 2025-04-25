class Main inherits IO{
    main () : Object{
         let x : Int, y : Int in{
        x <- in_int();

        y <- x + 10 - 5 * 3 * 5 / 34 + ~523245 -24 / ~54;
        y <- y - 32 - 84 * 3 / 8 * 32 + 9000 - ~43;
        y <- in_int();
        out_int(y);
        }
    };
};
