class Main inherits IO{
    main () : Object{
        let z : Int, x : Int, y : Bool in{
            z <- 0; 
            y <- not (z < x) ; 
            if y then 
                out_string("correct:)\n")
            else 
                out_string("wrong:(\n") 
            fi;
        }
    };
};
