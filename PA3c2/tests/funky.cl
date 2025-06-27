class Foo {
    foo () : Int{
        3
    };
};

class Main inherits Foo{
    x : Int <- foo();
    main () : Object{
        x
    };
};
