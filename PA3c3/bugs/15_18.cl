class Main inherits IO {
    main () : Object { 
        out_string("hello world\n") (* <- bugs 15 and 18 revealed by calling 
                                    base method from base class IO*)
    };
};
