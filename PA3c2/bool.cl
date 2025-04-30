class Main inherits IO {
  main () : Object {
    let 
      p : Int, q : Int, r : Int,
      u : Bool, v : Bool, w : Bool,
      x : Bool, y : String, z : Int
    in {
      out_string("Enter two integers p and q:\n");
      p <- in_int();
      q <- in_int();

      r <- (p + (~q)) - (p / (~2));

      u <- if not ((~p) < (q + r)) then
             if (r - (~q)) <= (p + (~2)) then true else false fi
           else false
           fi;

      v <- not not ( if (p = (~r)) then true else
                        if q < (~p) then true else false fi
                     fi );

      w <- ((~p) + (~q)) = (r - p);

      x <- not (u = w);

      z <- (r / 
             (if w then (q + (~1)) else (p - (~2)) fi)
           ) + (3);

      out_string("Computed values:\n");
      out_string("  p = "); out_int(p); out_string("\n");
      out_string("  q = "); out_int(q); out_string("\n");
      out_string("  r = "); out_int(r); out_string("\n");
      out_string("  z = "); out_int(z); out_string("\n\n");

      out_string("Now choosing a branch...\n");
      -- simulate “not (u and (v or w))”
      if not (
           if u then
             if ( if v then true else w fi ) then true else false fi
           else false
           fi
         ) then

        if z <= (p + q) then
          out_string("Branch A\n")
        else
          if v then
            out_string("Branch B1\n")
          else
            out_string("Branch B2\n")
          fi
        fi

      else

        if not (u = w) then
          out_string("Branch C\n")
        else
          out_string("Branch D\n")
        fi

      fi;
    }
  };
};

