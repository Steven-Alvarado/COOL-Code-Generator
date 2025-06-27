class Main inherits IO{
    istrue : Bool <- true;
    here : Bool <- false;
    x : Int <- 4;
    z : Int<- x + 2 * 5;
    y : Int <- x + z -1;
    main () : Object{
    {
        here <- (  false);
           if here then 
           out_int(y)
           else
           out_string("false")
           fi;
    }
    };
};

