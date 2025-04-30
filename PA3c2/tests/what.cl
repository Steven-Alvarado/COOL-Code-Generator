class Main inherits IO{
    x : Bool;
    main(): Object{
        {
        x <- (4 < 5);
        if x then out_int(4) else out_int(223) fi;
        }
    };
};
