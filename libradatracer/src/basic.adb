package body Basic is
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
