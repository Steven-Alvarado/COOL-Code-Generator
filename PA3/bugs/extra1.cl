class A {
   x: A <- new A;  -- Every object creates another object
};

class Main {
   main(): A {
      new A --Infinite allocation of `A`
   };
};

