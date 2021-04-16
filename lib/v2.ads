package V2 is
   pragma Pure;

   type Value is new Float;

   overriding function "=" (L, R : Value) return Boolean;

   type Tuple is record
      X, Y, Z : Value := 0.0;
      W : Value := -1.0;
   end record;

   subtype Point is Tuple
      with Dynamic_Predicate => Point.W = 1.0;

   subtype Vector is Tuple
      with Dynamic_Predicate => Vector.W = 0.0;

   function Dot_Product (L, R : Vector) return Value;

   function Cross_Product (L, R : Vector) return Vector;
end V2;
