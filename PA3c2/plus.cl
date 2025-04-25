class Main inherits IO {
  main () : Object {
    let a : Int,
        b : Int,
        c : Int,
        d : Int,
        e : Int,
        f : Int,
        g : Int,
        h : Int,
        i : Int,
        j : Int in {
      a <- 10 + ~2 * 5 - 1;
      b <- ~a - 3 / 1 + 100 * ~7 * 2;
      c <- a - b + 15 * ~3 - 8 / 4;
      d <- 15 / 3 * ~4 - 9 + a * b;
      e <- a + b * d - ~a / 2 + 5 * 11 * ~b;
      f <- e + d * b + a - ~b * 2 / d;
      g <- c * a - f / b + ~e * 10;
      h <- f - e * d + a / ~2 - c * g;
      i <- ~h + a * b - d * e + f * g - c;
      j <- g + i * h - f * e * d + b * a - c / i;
      out_int(a);
      out_int(b);
      out_int(c);
      out_int(d);
      out_int(e);
      out_int(f);
      out_int(g);
      out_int(h);
      out_int(i);
      out_int(j);
    }
  };
};
