package body Basic is
   function Answer return String is
   begin
      return "42";
   end Answer;

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
      Zero : constant Tuple := (0.0, 0.0, 0.0, 0.0);
      Negated : constant Tuple := Zero - A;
   begin
      return Negated;
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
