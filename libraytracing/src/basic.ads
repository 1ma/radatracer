package Basic is
   function Answer return String;

   Value_Epsilon : constant := 0.0001;
   Min_Value : constant := -1_000_000_000_000.0;
   Max_Value : constant := 1_000_000_000_000.0;
   type Value is delta Value_Epsilon range Min_Value .. Max_Value;

   type Tuple is record
      X : Value := 0.0;
      Y : Value := 0.0;
      Z : Value := 0.0;
      W : Value := 0.0;
   end record;

   function "+" (A, B : Tuple) return Tuple;
   function "-" (A, B : Tuple) return Tuple;
   function "-" (A : Tuple) return Tuple;

   function New_Point (X, Y, Z : Value) return Tuple;
   function New_Vector (X, Y, Z : Value) return Tuple;
end Basic;
