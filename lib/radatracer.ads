package Radatracer is
   pragma Pure;

   type Value is new Float;

   type Tuple is record
      X : Value := 0.0;
      Y : Value := 0.0;
      Z : Value := 0.0;
      W : Value := 0.0;
   end record;

   overriding function "=" (L, R : Value) return Boolean;
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
   function Normalize (T : Tuple) return Tuple
      with Pre => Is_Vector (T) and Magnitude (T) /= 0.0;

   function Dot_Product (L, R : Tuple) return Value;
   function Cross_Product (L, R : Tuple) return Tuple;

   type Ray is record
      Origin : Tuple;
      Direction : Tuple;
   end record
      with Dynamic_Predicate => Is_Point (Origin) and Is_Vector (Direction);

   function Position (R : Ray; T : Value) return Tuple
      with Post => Is_Point (Position'Result);
end Radatracer;
