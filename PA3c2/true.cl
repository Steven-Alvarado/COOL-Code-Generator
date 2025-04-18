class Main inherits IO{
    x : Bool <- true;
    main (): Object{
        if x then 
            out_string("correct\n")
        else
            out_string("wrong\n")
        fi
    };
};
