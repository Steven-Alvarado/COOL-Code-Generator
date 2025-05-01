class Main inherits IO{
i :  Int <- 0;
     main () : Object {
         {
             while ( i <= 10) loop {
                 out_int(i);
                 out_string("\n");
                 i <- i + 1;
                 out_int(i);
             } pool;
             let x : Int <- 4+ 5 in{
                 out_string("\n");
                 out_int(x);
             };
         }
     };
};
