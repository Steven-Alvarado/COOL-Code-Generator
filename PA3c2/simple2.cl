class Main inherits IO{
  q : Int <- 4;
  main(): Object {
    let x: Int, y :Int, z : Bool in
    {
        z <- not not not false;
        x <- 9 + y - 32 /23 + ~32 * q ;
        if z then out_int(x) else out_string("wrong\n") fi;
    }
  };
};

