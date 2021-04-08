with Ada.Numerics.Generic_Elementary_Functions;

package body Radatracer.Matrices is
   package Value_Elementary_Functions is
      new Ada.Numerics.Generic_Elementary_Functions (Value);

   function Translation (X, Y, Z : Value) return Matrix4 is
   begin
      return (
         (1.0, 0.0, 0.0, X),
         (0.0, 1.0, 0.0, Y),
         (0.0, 0.0, 1.0, Z),
         (0.0, 0.0, 0.0, 1.0)
      );
   end Translation;

   function Scaling (X, Y, Z : Value) return Matrix4 is
   begin
      return (
         (X, 0.0, 0.0, 0.0),
         (0.0, Y, 0.0, 0.0),
         (0.0, 0.0, Z, 0.0),
         (0.0, 0.0, 0.0, 1.0)
      );
   end Scaling;

   function Rotation_X (R : Radian) return Matrix4 is
      Cos_R : constant Value := Value_Elementary_Functions.Cos (Value (R));
      Sin_R : constant Value := Value_Elementary_Functions.Sin (Value (R));
   begin
      return (
         (1.0, 0.0, 0.0, 0.0),
         (0.0, Cos_R, -Sin_R, 0.0),
         (0.0, Sin_R, Cos_R, 0.0),
         (0.0, 0.0, 0.0, 1.0)
      );
   end Rotation_X;

   function Rotation_Y (R : Radian) return Matrix4 is
      Cos_R : constant Value := Value_Elementary_Functions.Cos (Value (R));
      Sin_R : constant Value := Value_Elementary_Functions.Sin (Value (R));
   begin
      return (
         (Cos_R, 0.0, Sin_R, 0.0),
         (0.0, 1.0, 0.0, 0.0),
         (-Sin_R, 0.0, Cos_R, 0.0),
         (0.0, 0.0, 0.0, 1.0)
      );
   end Rotation_Y;

   function Rotation_Z (R : Radian) return Matrix4 is
      Cos_R : constant Value := Value_Elementary_Functions.Cos (Value (R));
      Sin_R : constant Value := Value_Elementary_Functions.Sin (Value (R));
   begin
      return (
         (Cos_R, -Sin_R, 0.0, 0.0),
         (Sin_R, Cos_R, 0.0, 0.0),
         (0.0, 0.0, 1.0, 0.0),
         (0.0, 0.0, 0.0, 1.0)
      );
   end Rotation_Z;

   function Shearing (X_Y, X_Z, Y_X, Y_Z, Z_X, Z_Y : Value) return Matrix4 is
   begin
      return (
         (1.0, X_Y, X_Z, 0.0),
         (Y_X, 1.0, Y_Z, 0.0),
         (Z_X, Z_Y, 1.0, 0.0),
         (0.0, 0.0, 0.0, 1.0)
      );
   end Shearing;

   overriding function "=" (L, R : Matrix2) return Boolean is
   begin
      return
        L (0, 0) = R (0, 0) and
        L (0, 1) = R (0, 1) and
        L (1, 0) = R (1, 0) and
        L (1, 1) = R (1, 1);
   end "=";

   overriding function "=" (L, R : Matrix3) return Boolean is
   begin
      return
        L (0, 0) = R (0, 0) and
        L (0, 1) = R (0, 1) and
        L (0, 2) = R (0, 2) and
        L (1, 0) = R (1, 0) and
        L (1, 1) = R (1, 1) and
        L (1, 2) = R (1, 2) and
        L (2, 0) = R (2, 0) and
        L (2, 1) = R (2, 1) and
        L (2, 2) = R (2, 2);
   end "=";

   overriding function "=" (L, R : Matrix4) return Boolean is
   begin
      return
        L (0, 0) = R (0, 0) and
        L (0, 1) = R (0, 1) and
        L (0, 2) = R (0, 2) and
        L (0, 3) = R (0, 3) and
        L (1, 0) = R (1, 0) and
        L (1, 1) = R (1, 1) and
        L (1, 2) = R (1, 2) and
        L (1, 3) = R (1, 3) and
        L (2, 0) = R (2, 0) and
        L (2, 1) = R (2, 1) and
        L (2, 2) = R (2, 2) and
        L (2, 3) = R (2, 3) and
        L (3, 0) = R (3, 0) and
        L (3, 1) = R (3, 1) and
        L (3, 2) = R (3, 2) and
        L (3, 3) = R (3, 3);
   end "=";

   function "*" (L, R : Matrix4) return Matrix4 is
   begin
      return (
         (
            L (0, 0) * R (0, 0) + L (0, 1) * R (1, 0) + L (0, 2) * R (2, 0) + L (0, 3) * R (3, 0),
            L (0, 0) * R (0, 1) + L (0, 1) * R (1, 1) + L (0, 2) * R (2, 1) + L (0, 3) * R (3, 1),
            L (0, 0) * R (0, 2) + L (0, 1) * R (1, 2) + L (0, 2) * R (2, 2) + L (0, 3) * R (3, 2),
            L (0, 0) * R (0, 3) + L (0, 1) * R (1, 3) + L (0, 2) * R (2, 3) + L (0, 3) * R (3, 3)
         ),
         (
            L (1, 0) * R (0, 0) + L (1, 1) * R (1, 0) + L (1, 2) * R (2, 0) + L (1, 3) * R (3, 0),
            L (1, 0) * R (0, 1) + L (1, 1) * R (1, 1) + L (1, 2) * R (2, 1) + L (1, 3) * R (3, 1),
            L (1, 0) * R (0, 2) + L (1, 1) * R (1, 2) + L (1, 2) * R (2, 2) + L (1, 3) * R (3, 2),
            L (1, 0) * R (0, 3) + L (1, 1) * R (1, 3) + L (1, 2) * R (2, 3) + L (1, 3) * R (3, 3)
         ),
         (
            L (2, 0) * R (0, 0) + L (2, 1) * R (1, 0) + L (2, 2) * R (2, 0) + L (2, 3) * R (3, 0),
            L (2, 0) * R (0, 1) + L (2, 1) * R (1, 1) + L (2, 2) * R (2, 1) + L (2, 3) * R (3, 1),
            L (2, 0) * R (0, 2) + L (2, 1) * R (1, 2) + L (2, 2) * R (2, 2) + L (2, 3) * R (3, 2),
            L (2, 0) * R (0, 3) + L (2, 1) * R (1, 3) + L (2, 2) * R (2, 3) + L (2, 3) * R (3, 3)
         ),
         (
            L (3, 0) * R (0, 0) + L (3, 1) * R (1, 0) + L (3, 2) * R (2, 0) + L (3, 3) * R (3, 0),
            L (3, 0) * R (0, 1) + L (3, 1) * R (1, 1) + L (3, 2) * R (2, 1) + L (3, 3) * R (3, 1),
            L (3, 0) * R (0, 2) + L (3, 1) * R (1, 2) + L (3, 2) * R (2, 2) + L (3, 3) * R (3, 2),
            L (3, 0) * R (0, 3) + L (3, 1) * R (1, 3) + L (3, 2) * R (2, 3) + L (3, 3) * R (3, 3)
         )
      );
   end "*";

   function "*" (L : Matrix4; R : Tuple) return Tuple is
   begin
      return (
         X => L (0, 0) * R.X + L (0, 1) * R.Y + L (0, 2) * R.Z + L (0, 3) * R.W,
         Y => L (1, 0) * R.X + L (1, 1) * R.Y + L (1, 2) * R.Z + L (1, 3) * R.W,
         Z => L (2, 0) * R.X + L (2, 1) * R.Y + L (2, 2) * R.Z + L (2, 3) * R.W,
         W => L (3, 0) * R.X + L (3, 1) * R.Y + L (3, 2) * R.Z + L (3, 3) * R.W
      );
   end "*";

   function Transpose (M : Matrix4) return Matrix4 is
   begin
      return (
         (M (0, 0), M (1, 0), M (2, 0), M (3, 0)),
         (M (0, 1), M (1, 1), M (2, 1), M (3, 1)),
         (M (0, 2), M (1, 2), M (2, 2), M (3, 2)),
         (M (0, 3), M (1, 3), M (2, 3), M (3, 3))
      );
   end Transpose;

   function Submatrix (M : Matrix3; Row, Column : Natural) return Matrix2 is
      I_Offset, J_Offset : Natural range 0 .. 1 := 0;
      S : Matrix2;
   begin
      for I in M'Range (1) loop
         J_Offset := 0;
         if I = Row then
            I_Offset := 1;
         else
            for J in M'Range (2) loop
               if J = Column then
                  J_Offset := 1;
               else
                  S (I - I_Offset, J - J_Offset) := M (I, J);
               end if;
            end loop;
         end if;
      end loop;

      return S;
   end Submatrix;

   function Submatrix (M : Matrix4; Row, Column : Natural) return Matrix3 is
      I_Offset, J_Offset : Natural range 0 .. 1 := 0;
      S : Matrix3;
   begin
      for I in M'Range (1) loop
         J_Offset := 0;
         if I = Row then
            I_Offset := 1;
         else
            for J in M'Range (2) loop
               if J = Column then
                  J_Offset := 1;
               else
                  S (I - I_Offset, J - J_Offset) := M (I, J);
               end if;
            end loop;
         end if;
      end loop;

      return S;
   end Submatrix;

   function Minor (M : Matrix3; Row, Column : Natural) return Value is
   begin
      return Determinant (Submatrix (M, Row, Column));
   end Minor;

   function Minor (M : Matrix4; Row, Column : Natural) return Value is
   begin
      return Determinant (Submatrix (M, Row, Column));
   end Minor;

   function Cofactor (M : Matrix3; Row, Column : Natural) return Value is
      Negate : constant Boolean := (Row + Column) mod 2 = 1;
      Result : constant Value := Minor (M, Row, Column);
   begin
      if Negate then
         return -Result;
      end if;

      return Result;
   end Cofactor;

   function Cofactor (M : Matrix4; Row, Column : Natural) return Value is
      Negate : constant Boolean := (Row + Column) mod 2 = 1;
      Result : constant Value := Minor (M, Row, Column);
   begin
      if Negate then
         return -Result;
      end if;

      return Result;
   end Cofactor;

   function Determinant (M : Matrix2) return Value is
   begin
      return M (0, 0) * M (1, 1) - M (0, 1) * M (1, 0);
   end Determinant;

   function Determinant (M : Matrix3) return Value is
      Result : Value := 0.0;
   begin
      for J in M'Range (2) loop
         Result := Result + M (0, J) * Cofactor (M, 0, J);
      end loop;

      return Result;
   end Determinant;

   function Determinant (M : Matrix4) return Value is
      Result : Value := 0.0;
   begin
      for J in M'Range (2) loop
         Result := Result + M (0, J) * Cofactor (M, 0, J);
      end loop;

      return Result;
   end Determinant;

   function Is_Invertible (M : Matrix4) return Boolean is
   begin
      return Determinant (M) /= 0.0;
   end Is_Invertible;

   function Invert (M : Matrix4) return Matrix4 is
      D : constant Value := Determinant (M);
      Result : Matrix4;
   begin
      for R in M'Range (1) loop
         for C in M'Range (2) loop
            Result (C, R) := Cofactor (M, R, C) / D;
         end loop;
      end loop;
      return Result;
   end Invert;
end Radatracer.Matrices;
