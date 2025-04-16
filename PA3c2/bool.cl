class Main inherits IO{
    istrue : Bool <- (4 < 9);
    x : Int <- 4 * 4;
    main () : Object{
       if istrue then x
           else 
            out_string("0")
        fi
    };
};
