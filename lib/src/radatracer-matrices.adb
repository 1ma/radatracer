package body Radatracer.Matrices is
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

   function Determinant (M : Matrix2) return Value is
   begin
      return M (0, 0) * M (1, 1) - M (0, 1) * M (1, 0);
   end Determinant;

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
end Radatracer.Matrices;
