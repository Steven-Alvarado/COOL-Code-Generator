class Foo inherits IO{
    x : Int <-4;
    y : String <- "third";
  foo() : Object{
      {
    out_int(x);
    out_string(y);
}
  };
};
class Main inherits IO{

    main() :Object{
        {
        out_string("hi\n");
        out_string("bye\n");
        }
    };
};
