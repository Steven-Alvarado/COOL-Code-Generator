class Parent {
   f(): Int { 1 };
};

class Child inherits Parent {
   f(): Int { 2 };
};

class Main {
   main(): Int {
      let obj: Child <- new Child in obj@Parent.f()  -- Should return 1
   };
};

