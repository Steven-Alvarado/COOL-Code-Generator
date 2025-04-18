class Main inherits IO{
    y : Bool <- not false;
    x : Bool <- not true;
    z : Bool;
    main () : Object{
        {
        a <- not true;
        x <- not false;
        if x then 
            out_string("good\n\n")
        else
            out_string(":(\n")
        fi;
        }
    };
};
