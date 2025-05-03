class A {
   x: A <- new A;  -- Should initialize `x` properly without infinite recursion
};

class Main {
   main(): A {
      new A  -- Should return an instance of A
   };
};

