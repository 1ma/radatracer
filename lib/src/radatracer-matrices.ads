package Radatracer.Matrices is
   pragma Pure;

   type Matrix2 is array (0 .. 1, 0 .. 1) of Value;
   type Matrix3 is array (0 .. 2, 0 .. 2) of Value;
   type Matrix4 is array (0 .. 3, 0 .. 3) of Value;

   overriding function "=" (L, R : Matrix2) return Boolean;
   overriding function "=" (L, R : Matrix3) return Boolean;
   overriding function "=" (L, R : Matrix4) return Boolean;
end Radatracer.Matrices;
