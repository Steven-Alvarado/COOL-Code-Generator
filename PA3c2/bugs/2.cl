class Main {

   factorial(n: Int): Int {
      if n = 0 then 1 else n * factorial(n - 1) fi
   };
   main(): Int {
       {
      (new IO).out_string("Enter a number: ");
      let n: Int <- (new IO).in_int() in
      factorial(n);  -- Should return n!
       }
   };
};

