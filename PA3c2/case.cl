class Main inherits IO {
  main(): Int {
    {
      -- simple case on an Int literal
      let i: Object <- 2 in
      case i of
        x: Int  => out_int(x);    -- prints "2"
        y: Object => out_string("oops"); 
      esac;
      
      -- case on a Bool - using if instead of duplicate Bool types
      let b: Bool <- true in
      case b of
        t: Bool => if t then out_string("true\n") else out_string("false\n") fi;
        o: Object => out_string("not a boolean\n");
      esac;
      
      -- case on Object hierarchy
      let s: Object <- "hello" in
      case s of
        str: String => out_string(str);
        obj: Object => out_string("unknown\n");
      esac;
      0;
    }
  };
};

