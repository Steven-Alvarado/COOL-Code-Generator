class Foo inherits IO {
    i : Int <- 0;
    x : Int <- 2;
    y : Int <- 3;
    foo () : Object {
        {
           while ( i < 10) loop {
              x = x + 1;
              y = y;
              i <- i + 1; 
              out_int(i);
           } pool ;
           out_string ("Done\n");
        }
    };
};

class Main inherits Foo {
    main () : Object {
        foo ()
    };
};
