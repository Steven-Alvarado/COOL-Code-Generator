class Main inherits IO {
  main() : Object {
    let 
      x : Int,
      y : Int,
      z : Int,
      input_str : String,
      b1 : Bool,
      b2 : Bool,
      b3 : Bool
    in {
      (* Get user input values *)
      out_string("Enter an integer value for x: ");
      x <- in_int();
      
      out_string("Enter an integer value for y: ");
      y <- in_int();
      
      out_string("Enter a string: ");
      input_str <- in_string();
      
      (* Test complex nested expressions with operator precedence *)
      z <- ~(x * y) + (x / y) * (x - y);
      
      (* Test boolean expressions with negation and comparisons *)
      b1 <- not (x < y);
      b2 <- (x + y) <= (x * y);
      b3 <- not not (x = y);
      
      (* Output the string input *)
      out_string("You entered: ");
      out_string(input_str);
      out_string("\n");
      
      (* Test complex if-then-else with expressions *)
      if b1 then
        if b2 then
          out_string("Path 1: b1 true, b2 true\n")
        else
          out_string("Path 2: b1 true, b2 false\n")
        fi;
        (* Reassign variables inside nested conditionals *)
        x <- if not b3 then x * 2 else x - 1 fi
      else
        if not b2 then
          out_string("Path 3: b1 false, b2 false\n")
        else
          out_string("Path 4: b1 false, b2 true\n")
        fi;
        (* Different reassignment based on condition path *)
        y <- if b3 then y * 3 else y - 2 fi
      fi;
      
      (* Test complex arithmetic after conditionals *)
      z <- (x * ~y) + (if b1 then x else y fi);
      
      (* Output values to verify correctness *)
      out_string("Final values:\n");
      out_string("x = "); out_int(x); out_string("\n");
      out_string("y = "); out_int(y); out_string("\n");
      out_string("z = "); out_int(z); out_string("\n");
      
      (* Test nested conditionals within arithmetic *)
      z <- (if x < 10 then 
              if y < 5 then x * y else x + y fi 
            else 
              if b1 = b2 then x - y else x / y fi
            fi) + (if b3 then 100 else 200 fi);
      
      out_string("New z value: ");
      out_int(z);
      out_string("\n");
      
      (* Final complex conditional with nested conditionals *)
      if (if b1 then not b2 else b3 fi) then
        out_string("Complex condition true\n");
        out_string(input_str)
      else
        out_string("Complex condition false\n");
        out_string(input_str)
      fi
    }
  };
};
