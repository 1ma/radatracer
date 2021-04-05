with Ada.Numerics.Generic_Elementary_Functions;

package body Radatracer is
   package Value_Elementary_Functions is
      new Ada.Numerics.Generic_Elementary_Functions (Value);

   overriding function "=" (A, B : Value) return Boolean is
      Epsilon : constant Value := 0.00001;
   begin
      return abs (A - B) < Epsilon;
   end "=";

   overriding function "=" (A, B : Tuple) return Boolean is
   begin
      return A.X = B.X and A.Y = B.Y and A.Z = B.Z and A.W = B.W;
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

   function "*" (L, R : Tuple) return Tuple is
   begin
      return (
         X => L.X * R.X,
         Y => L.Y * R.Y,
         Z => L.Z * R.Z,
         W => L.W * R.W
      );
   end "*";

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

   function Magnitude (T : Tuple) return Value is
   begin
      return Value_Elementary_Functions.Sqrt (
         (T.X * T.X) + (T.Y * T.Y) + (T.Z * T.Z) + (T.W * T.W)
      );
   end Magnitude;

   function Normalize (T : Tuple) return Tuple is
      T_Magn : constant Value := Magnitude (T);
   begin
      return (
         X => T.X / T_Magn,
         Y => T.Y / T_Magn,
         Z => T.Z / T_Magn,
         W => T.W / T_Magn
      );
   end Normalize;

   function Dot_Product (L, R : Tuple) return Value is
   begin
      return L.X * R.X + L.Y * R.Y + L.Z * R.Z + L.W * R.W;
   end Dot_Product;

   function Cross_Product (L, R : Tuple) return Tuple is
   begin
      return (
         X => L.Y * R.Z - L.Z * R.Y,
         Y => L.Z * R.X - L.X * R.Z,
         Z => L.X * R.Y - L.Y * R.X,
         W => 0.0
      );
   end Cross_Product;

   function Make_Point (X, Y, Z : Value) return Tuple is
   begin
      return (X, Y, Z, 1.0);
   end Make_Point;

   function Make_Vector (X, Y, Z : Value) return Tuple is
   begin
      return (X, Y, Z, 0.0);
   end Make_Vector;

   function Make_Color (Red, Green, Blue : Value) return Tuple
      renames Make_Vector;
end Radatracer;
