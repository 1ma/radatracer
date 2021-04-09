package Radatracer.Matrices is
   pragma Pure;

   type Matrix is array (Natural range <>, Natural range <>) of Value;
   type Matrix2 is new Matrix (0 .. 1, 0 .. 1);
   type Matrix3 is new Matrix (0 .. 2, 0 .. 2);
   type Matrix4 is new Matrix (0 .. 3, 0 .. 3);

   Identity_Matrix4 : constant Matrix4 := (
      (1.0, 0.0, 0.0, 0.0),
      (0.0, 1.0, 0.0, 0.0),
      (0.0, 0.0, 1.0, 0.0),
      (0.0, 0.0, 0.0, 1.0)
   );

   function Translation (X, Y, Z : Value) return Matrix4;

   function Scaling (X, Y, Z : Value) return Matrix4;

   function Rotation_X (R : Float) return Matrix4;
   function Rotation_Y (R : Float) return Matrix4;
   function Rotation_Z (R : Float) return Matrix4;

   function Shearing (X_Y, X_Z, Y_X, Y_Z, Z_X, Z_Y : Value) return Matrix4;

   overriding function "=" (L, R : Matrix2) return Boolean;
   overriding function "=" (L, R : Matrix3) return Boolean;
   overriding function "=" (L, R : Matrix4) return Boolean;

   function "*" (L, R : Matrix4) return Matrix4;
   function "*" (L : Matrix4; R : Tuple) return Tuple;

   function Transpose (M : Matrix4) return Matrix4;

   function Submatrix (M : Matrix3; Row, Column : Natural) return Matrix2;
   function Submatrix (M : Matrix4; Row, Column : Natural) return Matrix3;

   function Minor (M : Matrix3; Row, Column : Natural) return Value;
   function Minor (M : Matrix4; Row, Column : Natural) return Value;

   function Cofactor (M : Matrix3; Row, Column : Natural) return Value;
   function Cofactor (M : Matrix4; Row, Column : Natural) return Value;

   function Determinant (M : Matrix2) return Value;
   function Determinant (M : Matrix3) return Value;
   function Determinant (M : Matrix4) return Value;

   function Is_Invertible (M : Matrix4) return Boolean;

   function Invert (M : Matrix4) return Matrix4
      with Pre => Is_Invertible (M);
end Radatracer.Matrices;
