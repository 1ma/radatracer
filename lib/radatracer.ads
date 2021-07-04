package Radatracer is
   pragma Pure;

   type Value is new Long_Float;

   Epsilon : constant Value := 0.00001;

   overriding function "=" (L, R : Value) return Boolean;

   type Tuple is record
      X, Y, Z : Value := 0.0;
      W : Value := -1.0;
   end record;
   --  The W component of the default Tuple is set to -1.0
   --  to emphasize that it is neither a Point nor a Vector.

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

   subtype Color is Vector;

   Origin : constant Point := (0.0, 0.0, 0.0, 1.0);

   Black : constant Color := (0.0, 0.0, 0.0, 0.0);
   Red   : constant Color := (1.0, 0.0, 0.0, 0.0);
   Green : constant Color := (0.0, 1.0, 0.0, 0.0);
   Blue  : constant Color := (0.0, 0.0, 1.0, 0.0);
   White : constant Color := (1.0, 1.0, 1.0, 0.0);

   function Make_Point (X, Y, Z : Integer) return Point;
   function Make_Point (X, Y, Z : Value) return Point;

   function Make_Vector (X, Y, Z : Integer) return Vector;
   function Make_Vector (X, Y, Z : Value) return Vector;

   function Make_Color (Red, Green, Blue : Value) return Color;

   function Magnitude (V : Vector) return Value;

   function Normalize (V : Vector) return Vector
      with Pre => Magnitude (V) /= 0.0;

   function Dot_Product (L, R : Vector) return Value;

   function Cross_Product (L, R : Vector) return Vector;

   type Ray is record
      Origin : Point := Radatracer.Origin;
      Direction : Vector := Make_Vector (0, 0, 0);
   end record;

   overriding function "=" (L, R : Ray) return Boolean;

   function Position (R : Ray; T : Value) return Point;
end Radatracer;
