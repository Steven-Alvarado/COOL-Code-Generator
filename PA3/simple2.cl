class Main inherits IO{
  main(): Object {
    let x: Int, y :Int, z : Bool in
    {
        z <- false;
        x <- 9 + y - 32 /23 + ~32 ;
        if z then out_int(x) else out_string("wrong\n") fi;
    }
  };
};

