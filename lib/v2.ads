package V2 is
   pragma Pure;

   type Value is new Float;

   overriding function "=" (L, R : Value) return Boolean;

   type Tuple is record
      X, Y, Z : Value := 0.0;
      W : Value := -1.0;
   end record;

   overriding function "=" (L, R : Tuple) return Boolean;

   function "+" (L, R : Tuple) return Tuple;

   function "-" (L, R : Tuple) return Tuple;
   function "-" (T : Tuple) return Tuple;

   function "*" (L, R : Tuple) return Tuple;
   function "*" (L : Tuple; R : Value) return Tuple;
   function "*" (L : Value; R : Tuple) return Tuple;

   function "/" (L : Tuple; R : Value) return Tuple
      with Pre => R /= 0.0;

   subtype Point is Tuple
      with Dynamic_Predicate => Point.W = 1.0;

   subtype Vector is Tuple
      with Dynamic_Predicate => Vector.W = 0.0;

   function Make_Point (X, Y, Z : Integer) return Point;
   function Make_Vector (X, Y, Z : Integer) return Vector;

   function Magnitude (V : Vector) return Value;

   function Normalize (V : Vector) return Vector
      with Pre => Magnitude (V) /= 0.0;

   function Dot_Product (L, R : Vector) return Value;

   function Cross_Product (L, R : Vector) return Vector;

   type Ray is record
      Origin : Point := Make_Point (0, 0, 0);
      Direction : Vector := Make_Vector (0, 0, 0);
   end record;

   function Position (R : Ray; T : Value) return Point;
end V2;
