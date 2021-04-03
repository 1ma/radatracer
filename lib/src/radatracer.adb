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

   function "+" (A, B : Tuple) return Tuple is
      Result : constant Tuple := (
         X => A.X + B.X,
         Y => A.Y + B.Y,
         Z => A.Z + B.Z,
         W => A.W + B.W
      );
   begin
      return Result;
   end "+";

   function "-" (A, B : Tuple) return Tuple is
      Result : constant Tuple := (
         X => A.X - B.X,
         Y => A.Y - B.Y,
         Z => A.Z - B.Z,
         W => A.W - B.W
      );
   begin
      return Result;
   end "-";

   function "-" (A : Tuple) return Tuple is
      Result : constant Tuple := (
         X => -A.X,
         Y => -A.Y,
         Z => -A.Z,
         W => -A.W
      );
   begin
      return Result;
   end "-";

   function "*" (T : Tuple; V : Value) return Tuple is
      Result : constant Tuple := (
         X => T.X * V,
         Y => T.Y * V,
         Z => T.Z * V,
         W => T.W * V
      );
   begin
      return Result;
   end "*";

   function "*" (V : Value; T : Tuple) return Tuple is
      Result : constant Tuple := (
         X => T.X * V,
         Y => T.Y * V,
         Z => T.Z * V,
         W => T.W * V
      );
   begin
      return Result;
   end "*";

   function "/" (T : Tuple; V : Value) return Tuple is
      Result : constant Tuple := (
         X => T.X / V,
         Y => T.Y / V,
         Z => T.Z / V,
         W => T.W / V
      );
   begin
      return Result;
   end "/";

   function Magnitude (T : Tuple) return Value is
      Result : constant Value := Value_Elementary_Functions.Sqrt (
         (T.X * T.X) + (T.Y * T.Y) + (T.Z * T.Z) + (T.W * T.W)
      );
   begin
      return Result;
   end Magnitude;

   function Normalize (T : Tuple) return Tuple is
      T_Magn : constant Value := Magnitude (T);
      Result : constant Tuple := (
         X => T.X / T_Magn,
         Y => T.Y / T_Magn,
         Z => T.Z / T_Magn,
         W => T.W / T_Magn
      );
   begin
      return Result;
   end Normalize;

   function Dot_Product (A, B : Tuple) return Value is
      Result : constant Value := A.X * B.X + A.Y * B.Y + A.Z * B.Z + A.W * B.W;
   begin
      return Result;
   end Dot_Product;

   function Cross_Product (A, B : Tuple) return Tuple is
      Result : constant Tuple := (
         X => A.Y * B.Z - A.Z * B.Y,
         Y => A.Z * B.X - A.X * B.Z,
         Z => A.X * B.Y - A.Y * B.X,
         W => 0.0
      );
   begin
      return Result;
   end Cross_Product;

   function Make_Point (X, Y, Z : Value) return Tuple is
      Result : constant Tuple := (X, Y, Z, 1.0);
   begin
      return Result;
   end Make_Point;

   function Make_Vector (X, Y, Z : Value) return Tuple is
      Result : constant Tuple := (X, Y, Z, 0.0);
   begin
      return Result;
   end Make_Vector;
end Radatracer;
