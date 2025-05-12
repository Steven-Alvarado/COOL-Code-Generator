class Main inherits IO {
    main () : Object{
        let a : Bool, b : Bool, c : Int, d : Int  in {
            c <- in_int();
            d <- in_int();
            if not c = d then a <- true else a <- false fi;
            let b : Bool  in {
                b <- false;
                let x : Bool in{
                    x <- false;
                    if not not not not not not a = b then out_string("hi\n") else out_string("bye\n") fi;
                    if b then out_string("b\n") else out_string("no\n") fi;
                    if x then out_string("x\n") else out_string("no\n") fi;
                };
            };
        }
    };
};
