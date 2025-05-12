-- reveals bug 201 along with 215, 216, and 218 
-- stack trace from recursion??
class Factorial {
  fact(n: Int): Int {
    if n = 0 then 1 else n * fact(n - 1) fi 
  };
};

class Main {
  main(): Int {
    (new Factorial).fact(5)  -- Should return 120
  };
};

