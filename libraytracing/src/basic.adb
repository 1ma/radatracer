package body Basic is
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

   function New_Point (X, Y, Z : Value) return Tuple is
      Point : constant Tuple := (X, Y, Z, 1.0);
   begin
      return Point;
   end New_Point;

   function New_Vector (X, Y, Z : Value) return Tuple is
      Vector : constant Tuple := (X, Y, Z, 0.0);
   begin
      return Vector;
   end New_Vector;
end Basic;
