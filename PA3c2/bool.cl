class Main inherits IO{
    istrue : Bool <- (( 4 < 6) = (4 < 90));
    here : Bool <- ((not (4 <= 5)) = false);
    x : Int <- 4;
    y : Int <- x + 43;
    main () : Object{
    {
       if here then 
           out_int(y)
           else 
           out_string("false")
        fi;
    }
    };
};
