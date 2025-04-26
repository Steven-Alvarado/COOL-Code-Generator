class Main inherits IO{
    main () : Object{
        let x : String , b : Bool , y : Int, z : Int  in{
            b <- not not not false;
            if not not not not b then out_string("foo\n") else out_string("bar\n") fi;
        }
    };
};
