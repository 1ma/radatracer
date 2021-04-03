with Ada.Numerics.Generic_Elementary_Functions;

package body Basic is
   package Value_Elementary_Functions is new Ada.Numerics.Generic_Elementary_Functions (Value);

   overriding function "=" (A, B : Value) return Boolean is
      Epsilon : constant := 0.00001;
   begin
      return abs (A - B) < Epsilon;
   end "=";

   overriding function "=" (A, B : Tuple) return Boolean is
   begin
      return A.X = B.X and A.Y = B.Y and A.Z = B.Z and A.W = B.W;
   end "=";

   function "+" (A, B : Tuple) return Tuple is
      C : constant Tuple := (
         X => A.X + B.X,
         Y => A.Y + B.Y,
         Z => A.Z + B.Z,
         W => A.W + B.W
      );
   begin
      return C;
   end "+";

   function "-" (A, B : Tuple) return Tuple is
      C : constant Tuple := (
         X => A.X - B.X,
         Y => A.Y - B.Y,
         Z => A.Z - B.Z,
         W => A.W - B.W
      );
   begin
      return C;
   end "-";

   function "-" (A : Tuple) return Tuple is
      NotA : constant Tuple := (-A.X, -A.Y, -A.Z, -A.W);
   begin
      return NotA;
   end "-";

   function "*" (T : Tuple; V : Value) return Tuple is
      Mult : constant Tuple := (T.X * V, T.Y * V, T.Z * V, T.W * V);
   begin
      return Mult;
   end "*";

   function "*" (V : Value; T : Tuple) return Tuple is
      Mult : constant Tuple := (T.X * V, T.Y * V, T.Z * V, T.W * V);
   begin
      return Mult;
   end "*";

   function "/" (T : Tuple; V : Value) return Tuple is
      Div : constant Tuple := (T.X / V, T.Y / V, T.Z / V, T.W / V);
   begin
      return Div;
   end "/";

   function Magnitude (T : Tuple) return Value is
   begin
      return Value_Elementary_Functions.Sqrt ((T.X * T.X) + (T.Y * T.Y) + (T.Z * T.Z) + (T.W * T.W));
   end Magnitude;

   function Normalize (T : Tuple) return Tuple is
      M : constant Value := Magnitude (T);
      Normalized : constant Tuple := (T.X / M, T.Y / M, T.Z / M, T.W / M);
   begin
      return Normalized;
   end Normalize;

   function Dot_Product (A, B : Tuple) return Value is
      Dot : constant Value := A.X * B.X + A.Y * B.Y + A.Z * B.Z + A.W * B.W;
   begin
      return Dot;
   end Dot_Product;

   function Cross_Product (A, B : Tuple) return Tuple is
      Cross : constant Tuple := (
         X => A.Y * B.Z - A.Z * B.Y,
         Y => A.Z * B.X - A.X * B.Z,
         Z => A.X * B.Y - A.Y * B.X,
         W => 0.0
      );
   begin
      return Cross;
   end Cross_Product;

   function Make_Point (X, Y, Z : Value) return Tuple is
      Point : constant Tuple := (X, Y, Z, 1.0);
   begin
      return Point;
   end Make_Point;

   function Make_Vector (X, Y, Z : Value) return Tuple is
      Vector : constant Tuple := (X, Y, Z, 0.0);
   begin
      return Vector;
   end Make_Vector;
end Basic;
