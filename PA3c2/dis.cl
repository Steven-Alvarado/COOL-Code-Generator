class Foo inherits IO{
    x : Int <- 0;
    foo() : Int {
        x
    };
};

class Main inherits Foo {
    main () : Int {
        foo()
    };
};
