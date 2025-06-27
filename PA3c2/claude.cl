class Main inherits IO {
    main() : Object {
        let a : Int,
            b : Int,
            c : Int,
            d : Int,
            x : Int,
            result : Int,
            bool1 : Bool,
            bool2 : Bool,
            bool3 : Bool,
            input_str : String,
            output_str : String in {
            
            out_string("Enter a value for x: ");
            x <- in_int();
            
            (* Testing boolean arithmetic with <, <=, and = *)
            bool1 <- 4 < 6;
            bool2 <- x <= 5;
            bool3 <- c = d;
            
            (* Initialize c and d *)
            out_string("Enter a value for c: ");
            c <- in_int();
            out_string("Enter a value for d: ");
            d <- in_int();
            
            (* Now bool3 will be properly evaluated *)
            bool3 <- c = d;
            
            (* Display boolean results *)
            out_string("\nBoolean test results:\n");
            if bool1 then
                out_string("4 < 6 is true\n")
            else
                out_string("4 < 6 is false\n")
            fi;
            
            if bool2 then
                out_string("x <= 5 is true\n")
            else
                out_string("x <= 5 is false\n")
            fi;
            
            if bool3 then
                out_string("c = d is true\n")
            else
                out_string("c = d is false\n")
            fi;
            
            (* Nested if statements *)
            out_string("\nTesting nested if statements:\n");
            if x < 10 then
                if x < 5 then
                    out_string("x is less than 5\n")
                else
                    out_string("x is between 5 and 9\n")
                fi
            else
                if x <= 20 then
                    out_string("x is between 10 and 20\n")
                else
                    out_string("x is greater than 20\n")
                fi
            fi;
            
            (* Complex arithmetic with results dependent on conditions *)
            out_string("\nComplex arithmetic with conditions:\n");
            if bool1 then
                a <- x * 2 + 10
            else
                a <- x * 3 - 5
            fi;
            
            if bool2 then
                b <- a + x * 4
            else
                b <- a - x * 2
            fi;
            
            out_string("a = ");
            out_int(a);
            out_string("\nb = ");
            out_int(b);
            out_string("\n");
            
            (* String input testing *)
            out_string("\nEnter a string: ");
            
           
            (* Boolean combinations *)
            out_string("\nBoolean combinations:\n");
            if bool1 then
                if bool2 then
                    out_string("Both bool1 and bool2 are true\n")
                else
                    out_string("bool1 is true but bool2 is false\n")
                fi
            else
                if bool3 then
                    out_string("bool1 is false but bool3 is true\n")
                else
                    out_string("bool1 and bool3 are both false\n")
                fi
            fi;
            
            (* Final calculations *)
            result <- 0;
            
            if bool1 then
                result <- result + 100
            else 
                result <- result - 50
            fi;
            
            if bool2 then
                result <- result + 200
            else
                result <- result - 25
            fi;
            
            if bool3 then
                result <- result + 300
            else
                result <- result - 75
            fi;
            
            out_string("\nFinal result: ");
            out_int(result);
            out_string("\n");
        }
    };
};
