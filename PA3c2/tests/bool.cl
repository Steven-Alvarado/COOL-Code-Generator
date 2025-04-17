class Main inherits IO{
    istrue : Bool <- (4 < 9);
    here : Bool <- false;
    x : Int <- 4 * 4 / 6 + 3 - 4;
    y : Int <- x;
    main () : Object{
    {
        here <- true;

       if istrue then 
           out_int(x)
           else 
           out_string("false")
        fi;
    }
    };
};
