class Main inherits IO{
    main () : Object{
           let z : String, y : Int , b : Bool in{
            out_string(z);
            out_string("\n");
            out_int(y);
            b <- false;
            if  not not b then out_string("correct\n") else out_string("wrong\n") fi;
        }
    };
};
