class Main {
    istrue : Bool <- (4 < 9);
    x : Int <- 4 * 4;
    main () : Object{
       if istrue then x
           else 0
        fi
    };
};
