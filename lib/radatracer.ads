package Radatracer is
   pragma Pure;

   type Value is new Float;

   overriding function "=" (L, R : Value) return Boolean;

   type Tuple is record
      X : Value := 0.0;
      Y : Value := 0.0;
      Z : Value := 0.0;
      W : Value := 0.0;
   end record;

   overriding function "=" (L, R : Tuple) return Boolean;

   function "+" (L, R : Tuple) return Tuple;

   function "*" (L, R : Tuple) return Tuple;

   function "-" (L, R : Tuple) return Tuple;
   function "-" (T : Tuple) return Tuple;

   function "*" (L : Tuple; R : Value) return Tuple;
   function "*" (L : Value; R : Tuple) return Tuple;

   function "/" (L : Tuple; R : Value) return Tuple;

   function Is_Point (T : Tuple) return Boolean;

   function Make_Point (X, Y, Z : Value) return Tuple
      with Post => Is_Point (Make_Point'Result);

   function Make_Point (X, Y, Z : Integer) return Tuple
      with Post => Is_Point (Make_Point'Result);

   function Is_Vector (T : Tuple) return Boolean;

   function Make_Vector (X, Y, Z : Value) return Tuple
      with Post => Is_Vector (Make_Vector'Result);

   function Make_Vector (X, Y, Z : Integer) return Tuple
      with Post => Is_Vector (Make_Vector'Result);

   function Magnitude (T : Tuple) return Value;

   function Normalize (V : Tuple) return Tuple
      with Pre => Is_Vector (V) and Magnitude (V) /= 0.0,
           Post => Is_Vector (Normalize'Result);

   function Dot_Product (L, R : Tuple) return Value
      with Pre => Is_Vector (L) and Is_Vector (R);

   function Cross_Product (L, R : Tuple) return Tuple
      with Pre => Is_Vector (L) and Is_Vector (R),
           Post => Is_Vector (Cross_Product'Result);

   type Ray is record
      Origin : Tuple := Make_Point (0, 0, 0);
      Direction : Tuple := Make_Vector (0, 0, 0);
   end record
      with Dynamic_Predicate => Is_Point (Origin) and Is_Vector (Direction);

   function Position (R : Ray; T : Value) return Tuple
      with Post => Is_Point (Position'Result);
end Radatracer;
