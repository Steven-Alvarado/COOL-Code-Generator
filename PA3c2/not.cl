class Main inherits IO{
    iscool : Bool; 
    main () : Object {
        {
        iscool <- not false;

        if iscool then 
            out_string("correct\n")
        else 
            out_string("wrong\n")
        fi;
        }
    };
};
