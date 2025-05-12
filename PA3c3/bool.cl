class Main inherits IO {
    main(): Object {
        let a: Int in {
            out_string("Enter an integer value for 'a': ");
            a <- in_int();
            a <- a + 121 - 32 / 4 + 1 - 32; 

            -- Declare all 25 boolean variables c_0 to c_24
            let c_0: Bool, c_1: Bool, c_2: Bool, c_3: Bool, c_4: Bool,
                c_5: Bool, c_6: Bool, c_7: Bool, c_8: Bool, c_9: Bool,
                c_10: Bool, c_11: Bool, c_12: Bool, c_13: Bool, c_14: Bool,
                c_15: Bool, c_16: Bool, c_17: Bool, c_18: Bool, c_19: Bool,
                c_20: Bool, c_21: Bool, c_22: Bool, c_23: Bool, c_24: Bool
            in {
                c_0 <- (((a < 10) = (a = 20)) = ((a <= 30) = not (not (a <= 40))));
                c_1 <- (((a < 17) = (a = 31)) = ((a <= 43) = not (not (a <= 57))));
                c_2 <- (((a < 24) = (a = 42)) = ((a <= 56) = not (not (a <= 74))));
                c_3 <- (((a < 31) = (a = 53)) = ((a <= 69) = not (not (a <= 91))));
                c_4 <- (((a < 38) = (a = 4)) = ((a <= 12) = not (not (a <= 28))));
                c_5 <- (((a < 45) = (a = 15)) = ((a <= 25) = not not (not (a <= 45))));
                c_6 <- (((a < 7) = (a = 26)) = ((a <= 38) = not (not (a <= 62))));
                c_7 <- (((a < 14) = (a = 37)) = ((a <= 51) = not (not (a <= 79))));
                c_8 <- (((a < 21) = (a = 48)) = ((a <= 64) = not (not (a <= 16))));
                c_9 <- (((a < 28) = (a = 59)) = ((a <= 7) = not (not (a <= 33))));
                c_10 <- (((a < 35) = (a = 10)) = ((a <= 20) = not (not (a <= 50))));
                c_11 <- (((a < 42) = (a = 21)) = ((a <= 33) = not (not (a <= 67))));
                c_12 <- (((a < 49) = (a = 32)) = ((a <= 46) = not (not (a <= 4))));
                c_13 <- (((a < 6) = (a = 43)) = ((a <= 59) = not (not (a <= 21))));
                c_14 <- (((a < 13) = (a = 54)) = ((a <= 2) = not (not (a <= 38))));
                c_15 <- (((a < 20) = (a = 5)) = ((a <= 15) = not (not (a <= 55))));
                c_16 <- (((a < 27) = (a = 16)) = ((a <= 28) = not (not (a <= 72))));
                c_17 <- (((a < 34) = (a = 27)) = ((a <= 41) = not (not (a <= 9))));
                c_18 <- (((a < 41) = (a = 38)) = ((a <= 54) = not (not (a <= 26))));
                c_19 <- (((a < 48) = (a = 49)) = ((a <= 67) = not (not (a <= 43))));
                c_20 <- (((a < 5) = (a = 0)) = ((a <= 10) = not (not (a <= 60))));
                c_21 <- (((a < 12) = (a = 11)) = ((a <= 23) = not (not (a <= 77))));
                c_22 <- (((a < 19) = (a = 22)) = ((a <= 36) = not (not (a <= 14))));
                c_23 <- (((a < 26) = (a = 33)) = ((a <= 49) = not (not (a <= 31))));
                c_24 <- (((a < 33) = (a = 44)) = ((a <= 62) = not (not (a <= 48))));

                -- Declare chain1_val and chain2_val
                let chain1_val: Bool, chain2_val: Bool
                in {
                    -- Assign values to chain1_val and chain2_val
                    chain1_val <- c_0 = (c_1 = (c_2 = (c_3 = (c_4 = (c_5 = (c_6 = (c_7 = (c_8 = (c_9 = (c_10 = (c_11 = c_12))))))))))); (* 12 closing parens *)
                    chain2_val <- c_13 = (c_14 = (c_15 = (c_16 = (c_17 = (c_18 = (c_19 = (c_20 = (c_21 = (c_22 = (c_23 = c_24)))))))))); (* 11 closing parens *)

                    -- The final conditional structure using the chains
                    if not chain1_val = not chain2_val then {
                        out_string("Value of 'a' is: "); out_int(a); out_string("\n");
                        out_string("Let's do something arbitrary: a + 777 = "); out_int(a + 777); out_string("\n");
                    }
                    else {
                        out_string("Value of 'a' is: "); out_int(a); out_string("\n");
                        out_string("Another arbitrary operation: a - 999 = "); out_int(a - 999); out_string("\n");
                        out_string("Repeating 'a' for emphasis: "); out_int(a); out_string("\n");
                    }
                    fi; (* End of if expression *)
                }; (* End of inner let-block's expression sequence for chain_val variables *)
            }; (* End of outer let-block's expression sequence for c_i variables *)
        } (* End of let-block for 'a' *)
    }; (* End of main method *)
}; (* End of class Main *)
