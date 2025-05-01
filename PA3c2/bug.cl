class Main inherits IO {
    main() : Object {
        let a : Int,
            b : Int,
            c : Int, 
            d : Int,
            i : Int in {

                out_string("Enter number: ");
                a <- in_int();

                (* These are the lines with potential division operations *)
                    b <- ~a - 3 / 1;          (* Safe division *)
                    c <- a - b - 8 / 4;       (* Safe division *)
                    d <- 15 / 3 + a * b;      (* Safe division *)

                    (* These are the risky divisions that might cause issues *)
                    out_string("\nAbout to calculate f (using d as divisor)\n");
                let f : Int <- a - b * 2 / d in   (* Risky: d could be 0 *)
                {
                    out_int(f);

                    out_string("\nAbout to calculate g (using b as divisor)\n");
                    let g : Int <- c * a - f / b in   (* Risky: b could be 0 *){
                        out_int(g);

                        out_string("\nAbout to calculate j (using i as divisor)\n");
                        i <- a + b;
                        let j : Int <- g - c / i in       (* Risky: i could be 0 *){
                            out_int(j);

                            out_string("\nEnd of program\n");
                        };
                    };
                };
            }
    };
};
