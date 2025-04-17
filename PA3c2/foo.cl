class Foo inherits IO{
    x : Int <-5;
    y : Int <- x + 1;
    z : Int <- x / z;
    foo () : Object{
        {

        out_int(y);
        out_string("foo\n");

        }
    };
};

class Main inherits Foo{
    a : Int <- z;
    main () : Object {
{
        out_string("main\n");
        foo();
}
    };
};
