--reveals bug 4
class A {
   f(): SELF_TYPE { new SELF_TYPE };
};

class B inherits A {};

class Main {
   main(): A {
      let obj: A <- new B in obj.f()  -- Should return a `B`, but typed as `A`
   };
};

