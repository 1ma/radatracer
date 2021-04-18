with Ada.Numerics.Generic_Elementary_Functions;

package body Radatracer is
   overriding function "=" (L, R : Value) return Boolean is
      Epsilon : constant Value := 0.00001;
   begin
      return abs (L - R) < Epsilon;
   end "=";

   overriding function "=" (L, R : Tuple) return Boolean is
   begin
      return L.X = R.X and L.Y = R.Y and L.Z = R.Z and L.W = R.W;
   end "=";

   function "+" (L, R : Tuple) return Tuple is
   begin
      return (
         X => L.X + R.X,
         Y => L.Y + R.Y,
         Z => L.Z + R.Z,
         W => L.W + R.W
      );
   end "+";

   function "-" (L, R : Tuple) return Tuple is
   begin
      return (
         X => L.X - R.X,
         Y => L.Y - R.Y,
         Z => L.Z - R.Z,
         W => L.W - R.W
      );
   end "-";

   function "-" (T : Tuple) return Tuple is
   begin
      return (
         X => -T.X,
         Y => -T.Y,
         Z => -T.Z,
         W => -T.W
      );
   end "-";

   function "*" (L, R : Tuple) return Tuple is
   begin
      return (
         X => L.X * R.X,
         Y => L.Y * R.Y,
         Z => L.Z * R.Z,
         W => L.W * R.W
      );
   end "*";

   function "*" (L : Tuple; R : Value) return Tuple is
   begin
      return (
         X => L.X * R,
         Y => L.Y * R,
         Z => L.Z * R,
         W => L.W * R
      );
   end "*";

   function "*" (L : Value; R : Tuple) return Tuple is
   begin
      return (
         X => R.X * L,
         Y => R.Y * L,
         Z => R.Z * L,
         W => R.W * L
      );
   end "*";

   function "/" (L : Tuple; R : Value) return Tuple is
   begin
      return (
         X => L.X / R,
         Y => L.Y / R,
         Z => L.Z / R,
         W => L.W / R
      );
   end "/";

   function Make_Point (X, Y, Z : Integer) return Point is
   begin
      return Make_Point (Value (X), Value (Y), Value (Z));
   end Make_Point;

   function Make_Point (X, Y, Z : Value) return Point is
   begin
      return (X, Y, Z, 1.0);
   end Make_Point;

   function Make_Vector (X, Y, Z : Integer) return Vector is
   begin
      return Make_Vector (Value (X), Value (Y), Value (Z));
   end Make_Vector;

   function Make_Vector (X, Y, Z : Value) return Vector is
   begin
      return (X, Y, Z, 0.0);
   end Make_Vector;

   function Make_Color (Red, Green, Blue : Value) return Color renames Make_Vector;

   function Magnitude (V : Vector) return Value is
      package Math is new Ada.Numerics.Generic_Elementary_Functions (Value);
   begin
      return Math.Sqrt ((V.X * V.X) + (V.Y * V.Y) + (V.Z * V.Z));
   end Magnitude;

   function Normalize (V : Vector) return Vector is
      V_Magnitude : constant Value := Magnitude (V);
   begin
      return (
         X => V.X / V_Magnitude,
         Y => V.Y / V_Magnitude,
         Z => V.Z / V_Magnitude,
         W => V.W / V_Magnitude
      );
   end Normalize;

   function Dot_Product (L, R : Vector) return Value is
   begin
      return L.X * R.X + L.Y * R.Y + L.Z * R.Z;
   end Dot_Product;

   function Cross_Product (L, R : Vector) return Vector is
   begin
      return (
         X => L.Y * R.Z - L.Z * R.Y,
         Y => L.Z * R.X - L.X * R.Z,
         Z => L.X * R.Y - L.Y * R.X,
         W => 0.0
      );
   end Cross_Product;

   function Position (R : Ray; T : Value) return Point is
   begin
      return R.Origin + R.Direction * T;
   end Position;
end Radatracer;
