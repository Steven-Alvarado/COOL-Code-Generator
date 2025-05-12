class Main inherits IO{
    istrue : Bool <- true;
    here : Bool <- not false;
    x : Int <- 4;
    z : Int<- x + 2 * 5;
    y : Int <- x + z -1;
    main () : Object{
    {
        here <- ( not  false);
           if here then 
           out_int((y + 2) / 8)
           else
           out_string("false")
           fi;
    }
    };
};

