class Main {
    isTrue : Bool <- (5 < 10);
    isFalse : Bool <- (15 < 5);
    x : Int <- 42;
    y : Int <- 7; 
    main() : Object {
        let result : Int <- 0 in {
            if isTrue then {
                result <- x;
            } else {
                result <- 0;
            } fi;
            
            if isFalse then {
                result <- result - y;
            } else {
                result <- result + y;
            } fi;
            
            (new IO).out_int(result);
        }
    };
};
