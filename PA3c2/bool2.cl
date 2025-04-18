class Main inherits IO{
    istrue : Bool <- true;
    here : Bool <- false;
    x : Int <- 4;
    z : Int<- x + 4 * 2;
    y : Int <- x + z -1;
    main () : Object{
    {
        here <- ( not false);
           if here then 
           out_int(y)
           else
           out_string("false")
           fi;
    }
    };
};

