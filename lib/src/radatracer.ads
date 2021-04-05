package Radatracer is
   pragma Pure;

   type Value is new Float;

   type Tuple is record
      X : Value := 0.0;
      Y : Value := 0.0;
      Z : Value := 0.0;
      W : Value := 0.0;
   end record;

   overriding function "=" (A, B : Value) return Boolean;
   overriding function "=" (A, B : Tuple) return Boolean;

   function "+" (L, R : Tuple) return Tuple;

   function "*" (L, R : Tuple) return Tuple;

   function "-" (L, R : Tuple) return Tuple;
   function "-" (T : Tuple) return Tuple;

   function "*" (L : Tuple; R : Value) return Tuple;
   function "*" (L : Value; R : Tuple) return Tuple;

   function "/" (L : Tuple; R : Value) return Tuple;

   function Magnitude (T : Tuple) return Value;
   function Normalize (T : Tuple) return Tuple;
   function Dot_Product (L, R : Tuple) return Value;
   function Cross_Product (L, R : Tuple) return Tuple;

   function Make_Point (X, Y, Z : Value) return Tuple;
   function Make_Vector (X, Y, Z : Value) return Tuple;
   function Make_Color (Red, Green, Blue : Value) return Tuple;
end Radatracer;
