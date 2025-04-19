class Main inherits IO{
    isfalse : Bool <- false ;
    main () : Object{
    {
       isfalse <- false;
       if not isfalse then {
           out_string("correct\n");
       }
           else 
           out_string("wrong\n")
       fi;
    }
    };
};
