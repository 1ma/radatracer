package Basic is
   pragma Pure;

   Value_Epsilon : constant := 0.000_01;
   Value_Digits : constant := 18;
   type Value is delta Value_Epsilon digits Value_Digits;

   type Tuple is record
      X : Value := 0.0;
      Y : Value := 0.0;
      Z : Value := 0.0;
      W : Value := 0.0;
   end record;

   overriding function "=" (A, B : Tuple) return Boolean;

   function "+" (A, B : Tuple) return Tuple;

   function "-" (A, B : Tuple) return Tuple;
   function "-" (A : Tuple) return Tuple;

   function "*" (T : Tuple; V : Value) return Tuple;
   function "*" (V : Value; T : Tuple) return Tuple;

   function "/" (T : Tuple; V : Value) return Tuple;

   function New_Point (X, Y, Z : Value) return Tuple;
   function New_Vector (X, Y, Z : Value) return Tuple;
end Basic;
