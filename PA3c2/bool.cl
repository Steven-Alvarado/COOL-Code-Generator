class Main inherits IO{
    istrue : Bool <- (4 < 9);
    x : Int <- 4 * 4 / 6 + 3 - 4;
    main () : Object{
       if istrue then 
           out_int(x)
           else 
           out_string("false")
        fi
    };
};
