package Basic is
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

   function "+" (A, B : Tuple) return Tuple;

   function "-" (A, B : Tuple) return Tuple;
   function "-" (A : Tuple) return Tuple;

   function "*" (T : Tuple; V : Value) return Tuple;
   function "*" (V : Value; T : Tuple) return Tuple;

   function "/" (T : Tuple; V : Value) return Tuple;

   function Magnitude (T : Tuple) return Value;

   function New_Point (X, Y, Z : Value) return Tuple;
   function New_Vector (X, Y, Z : Value) return Tuple;
end Basic;
