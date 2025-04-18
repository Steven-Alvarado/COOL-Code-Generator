class Main inherits IO{
    iscool : Bool <- not (not ( 40 <= 40)) ;
    main () : Object {
        if iscool then 
            out_string("cool\n")
        else 
            out_string(":</\n")
        fi
    };
};
