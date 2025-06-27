class A {
   f(): Int { 5 };
};

class Main {
   main(): Int {
      let a: A in a.f()  -- a is void → runtime error reveals bug 203 and 210
   };
};

