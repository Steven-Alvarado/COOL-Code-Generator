class Main {
  x: SELF_TYPE; (* <- not initialized (void)*) 

  main(): Object {
    x (*  x not actually initialized a value
          if void then this could cause the code generated to deference
              a null pointer maybe?*)
  };
};

