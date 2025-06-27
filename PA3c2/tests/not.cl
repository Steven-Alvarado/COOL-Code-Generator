class Main inherits IO{
    main () : Object {
        let iscool : Bool in{
        iscool <- not not true;

        if iscool then 
            out_string("correct\n")
        else 
            out_string("wrong\n")
        fi;
        }
    };
};
