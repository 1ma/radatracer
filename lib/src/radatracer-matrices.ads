package Radatracer.Matrices is
   pragma Pure;

   type Matrix is array (Natural range <>, Natural range <>) of Value;
   subtype Matrix2 is Matrix (0 .. 1, 0 .. 1);
   subtype Matrix3 is Matrix (0 .. 2, 0 .. 2);
   subtype Matrix4 is Matrix (0 .. 3, 0 .. 3);

   Identity_Matrix4 : constant Matrix4 := (
      (1.0, 0.0, 0.0, 0.0),
      (0.0, 1.0, 0.0, 0.0),
      (0.0, 0.0, 1.0, 0.0),
      (0.0, 0.0, 0.0, 1.0)
   );

   overriding function "=" (L, R : Matrix) return Boolean;

   function "*" (L, R : Matrix4) return Matrix4;
   function "*" (L : Matrix4; R : Tuple) return Tuple;
end Radatracer.Matrices;
