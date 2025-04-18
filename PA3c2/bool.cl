class Main inherits IO{
    istrue : Bool <- not false = ((( 4< 7) = (5 <= 5)) = not true);
    here : Bool <- not(not true);
    x : Int <- 4;
    y : Int <- x + 43;
    main () : Object{
    {
       here <- ( not (not false));
       if here then {
           out_string("wrong\n");
       }
           else 
           out_string("correct\n")
        fi;
    }
    };
};
