
class Foo {
    z : Object <- 4;
    foo () : Object{
        z
    };
};

class Main inherits Foo{
    x : Int <- 4;
    y : String <-"hi\n";
    main() : Object {
        y
    };
};
