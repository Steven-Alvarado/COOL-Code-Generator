class Main inherits IO{
    a  : Bool <- true;
    b : Int <- ~5;
    main () : Object{
        {
            let x : Int, y : Bool , z : Int in
            {
            if y then out_string("wrong\n") else out_int(b) fi;
            z <- 4;
            x <- z + 4 / 4 - ~10 * 43 / 89234 + 4 ;
            out_string("\n");
            out_int(x); 
            };
        }
    };
};
