class Main inherits IO {
  main () : Object {
    let p : Int, q : Int, r : Int,
        u : Bool, v : Bool, w : Bool,
        x : Bool, y : Bool in {
      p <- 5;
      q <- 2;
      r <- 5;
      u <- not (p < q);
      v <- not not (q <= r);
      w <- (p = r);
      x <- not (u = v);

      if x then
        if  w then
          out_string("Branch A\n")
        else
          if v then
            out_string("Branch B1\n")
          else
            out_string("Branch B2\n")
          fi
        fi
      else
        if  not (u = w) then
          out_string("Branch C\n")
        else
          out_string("Branch D\n")
        fi
      fi;

      
    }
  };
};

