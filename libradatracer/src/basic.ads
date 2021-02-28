package Basic is
   pragma Pure;

   Min_Value : constant := -1_000_000.0;
   Max_Value : constant := 1_000_000.0;
   Value_Epsilon : constant := 0.000_01;
   type Value is delta Value_Epsilon range Min_Value .. Max_Value;

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
   function "*" (A : Tuple; B : Value) return Tuple;
   function "/" (A : Tuple; B : Value) return Tuple;

   function New_Point (X, Y, Z : Value) return Tuple;
   function New_Vector (X, Y, Z : Value) return Tuple;
end Basic;
