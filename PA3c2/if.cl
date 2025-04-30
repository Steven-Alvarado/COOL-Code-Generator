class Main inherits IO{
    main () : Object{
    let x : Int, y : Bool in{
        y <- (~4 < 10);
        if y then {
            if y then out_string("hi\n") else out_string("no\n") fi;
        }
        else
            out_string("yes\n")
        fi;
    }
    };
};
