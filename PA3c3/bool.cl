class Main inherits IO {
    main(): Object {
        let a: Int in {
            -- Read two inputs and compute initial value
            a <- in_int();
            a <- a + 121 - 32 / 4 + 1 - 32;

            -- Outrageously nested boolean logic with 40+ comparisons!
            if not(
                not(
                      ((((4 < 5) = (4 <= 5)) = ((42 = 43) = (false = false)))
                    = (((4 < 5) = (4 <= 5)) = ((42 = 43) = (false = true))))
                    = (
                    (((4 < 1) = (4 <= 45)) = ((41 = 43) = (false = true))) = not (43 <= 32)
                    )
                    = ()
                )
            )
            = not (4 < 39)
            then
                out_int(a)
            else{
                out_int(a + 3 - 1);
                out_int(a + 43);
                out_int(a);
            }
            fi;
        }
    };
};

