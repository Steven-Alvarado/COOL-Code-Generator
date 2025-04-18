class Main inherits IO{
    x : Bool <- false;
    main () : Object{
        if x then 
            out_string("wrong\n")
        else 
            out_string("correct\n")
        fi
    };
};
