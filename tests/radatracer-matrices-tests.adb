with Ada.Numerics;
with AUnit.Assertions;

package body Radatracer.Matrices.Tests is
   procedure Test_Matrix_Operations (T : in out AUnit.Test_Cases.Test_Case'Class);
   procedure Test_Matrix_Operations (T : in out AUnit.Test_Cases.Test_Case'Class) is
      pragma Unreferenced (T);

      M1 : constant Matrix4 := (
         (1.0, 2.0, 3.0, 4.0),
         (5.0, 6.0, 7.0, 8.0),
         (9.0, 8.0, 7.0, 6.0),
         (5.0, 4.0, 3.0, 2.0)
      );

      M2 : constant Matrix4 := (
         (-2.0, 1.0, 2.0, 3.0),
         (3.0, 2.0, 1.0, -1.0),
         (4.0, 3.0, 6.0, 5.0),
         (1.0, 2.0, 7.0, 8.0)
      );

      M3 : constant Matrix4 := (
         (20.0, 22.0, 50.0, 48.0),
         (44.0, 54.0, 114.0, 108.0),
         (40.0, 58.0, 110.0, 102.0),
         (16.0, 26.0, 46.0, 42.0)
      );

      M4 : constant Matrix4 := (
         (1.0, 2.0, 3.0, 4.0),
         (2.0, 4.0, 4.0, 2.0),
         (8.0, 6.0, 4.0, 1.0),
         (0.0, 0.0, 0.0, 1.0)
      );

      T1 : constant Tuple := (1.0, 2.0, 3.0, 1.0);
      T2 : constant Tuple := (18.0, 24.0, 33.0, 1.0);

      M5 : constant Matrix4 := (
         (0.0, 9.0, 3.0, 0.0),
         (9.0, 8.0, 0.0, 8.0),
         (1.0, 8.0, 5.0, 3.0),
         (0.0, 0.0, 5.0, 8.0)
      );

      M6 : constant Matrix4 := (
         (0.0, 9.0, 1.0, 0.0),
         (9.0, 8.0, 8.0, 0.0),
         (3.0, 0.0, 5.0, 5.0),
         (0.0, 8.0, 3.0, 8.0)
      );

      M7 : constant Matrix2 := (
         (1.0, 5.0),
         (-3.0, 2.0)
      );

      M8 : constant Matrix3 := (
         (1.0, 5.0, 0.0),
         (-3.0, 2.0, 7.0),
         (0.0, 6.0, -3.0)
      );

      M9 : constant Matrix2 := (
         (-3.0, 2.0),
         (0.0, 6.0)
      );

      M10 : constant Matrix4 := (
         (-6.0, 1.0, 1.0, 6.0),
         (-8.0, 5.0, 8.0, 6.0),
         (-1.0, 0.0, 8.0, 2.0),
         (-7.0, 1.0, -1.0, 1.0)
      );

      M11 : constant Matrix3 := (
         (-6.0, 1.0, 6.0),
         (-8.0, 8.0, 6.0),
         (-7.0, -1.0, 1.0)
      );

      M12 : constant Matrix3 := (
         (3.0, 5.0, 0.0),
         (2.0, -1.0, -7.0),
         (6.0, -1.0, 5.0)
      );

      M13 : constant Matrix3 := (
         (1.0, 2.0, 6.0),
         (-5.0, 8.0, -4.0),
         (2.0, 6.0, 4.0)
      );

      M14 : constant Matrix4 := (
         (-2.0, -8.0, 3.0, 5.0),
         (-3.0, 1.0, 7.0, 3.0),
         (1.0, 2.0, -9.0, 6.0),
         (-6.0, 7.0, 7.0, -9.0)
      );

      M15 : constant Matrix4 := (
         (6.0, 4.0, 4.0, 4.0),
         (5.0, 5.0, 7.0, 6.0),
         (4.0, -9.0, 3.0, -7.0),
         (9.0, 1.0, 7.0, -6.0)
      );

      M16 : constant Matrix4 := (
         (-4.0, 2.0, -2.0, -3.0),
         (9.0, 6.0, 2.0, 6.0),
         (0.0, -5.0, 1.0, -5.0),
         (0.0, 0.0, 0.0, 0.0)
      );

      M17 : constant Matrix4 := (
         (-5.0, 2.0, 6.0, -8.0),
         (1.0, -5.0, 1.0, 8.0),
         (7.0, 7.0, -6.0, -7.0),
         (1.0, -3.0, 7.0, 4.0)
      );

      M18 : constant Matrix4 := Invert (M17);

      M19 : constant Matrix4 := (
         (0.21805, 0.45113, 0.24060, -0.04511),
         (-0.80827, -1.45677, -0.44361, 0.52068),
         (-0.07895, -0.22368, -0.05263, 0.19737),
         (-0.52256, -0.81391, -0.30075, 0.30639)
      );

      M20 : constant Matrix4 := (
         (8.0, -5.0, 9.0, 2.0),
         (7.0, 5.0, 6.0, 1.0),
         (-6.0, 0.0, 9.0, 6.0),
         (-3.0, 0.0, -9.0, -4.0)
      );

      M21 : constant Matrix4 := (
         (-0.15385, -0.15385, -0.28205, -0.53846),
         (-0.07692, 0.12308, 0.02564, 0.03077),
         (0.35897, 0.35897, 0.43590, 0.92308),
         (-0.69231, -0.69231, -0.76923, -1.92308)
      );

      M22 : constant Matrix4 := (
         (9.0, 3.0, 0.0, 9.0),
         (-5.0, -2.0, -6.0, -3.0),
         (-4.0, 9.0, 6.0, 4.0),
         (-7.0, 6.0, 6.0, 2.0)
      );

      M23 : constant Matrix4 := (
         (-0.04074, -0.07778, 0.14444, -0.22222),
         (-0.07778, 0.03333, 0.36667, -0.33333),
         (-0.02901, -0.14630, -0.10926, 0.12963),
         (0.17778, 0.06667, -0.26667, 0.33333)
      );

      M24 : constant Matrix4 := (
         (3.0, -9.0, 7.0, 3.0),
         (3.0, -8.0, 2.0, -9.0),
         (-4.0, 4.0, 4.0, 1.0),
         (-6.0, 5.0, -1.0, 1.0)
      );

      M25 : constant Matrix4 := (
         (8.0, 2.0, 2.0, 2.0),
         (3.0, -1.0, 7.0, 0.0),
         (7.0, 0.0, 5.0, 4.0),
         (6.0, -2.0, 0.0, 5.0)
      );

      M26 : constant Matrix4 := M24 * M25;
   begin
      AUnit.Assertions.Assert (M1 * M2 = M3, "Matrix4 multiplication test");

      AUnit.Assertions.Assert (M4 * T1 = T2, "Matrix4 * Tuple multiplication test");

      AUnit.Assertions.Assert (Identity_Matrix4 * M1 = M1, "Identity Matrix4 multiplication test 1");
      AUnit.Assertions.Assert (M1 * Identity_Matrix4 = M1, "Identity Matrix4 multiplication test 2");
      AUnit.Assertions.Assert (Identity_Matrix4 * T1 = T1, "Identity Matrix4 multiplication test 3");

      AUnit.Assertions.Assert (Transpose (M5) = M6, "Matrix4 transposition multiplication test 1");
      AUnit.Assertions.Assert (Transpose (Identity_Matrix4) = Identity_Matrix4, "Matrix4 transposition multiplication test 2");

      AUnit.Assertions.Assert (Determinant (M7) = 17.0, "Matrix2 determinant test");

      AUnit.Assertions.Assert (Submatrix (M8, 0, 2) = M9, "Submatrix3 test");
      AUnit.Assertions.Assert (Submatrix (M10, 2, 1) = M11, "Submatrix4 test");

      AUnit.Assertions.Assert (Determinant (Submatrix (M12, 1, 0)) = 25.0, "Minor Matrix3 test 1");
      AUnit.Assertions.Assert (Minor (M12, 1, 0) = 25.0, "Minor Matrix3 test 2");

      AUnit.Assertions.Assert (Minor (M12, 0, 0) = -12.0, "Cofactor Matrix3 test 1");
      AUnit.Assertions.Assert (Cofactor (M12, 0, 0) = -12.0, "Cofactor Matrix3 test 2");
      AUnit.Assertions.Assert (Minor (M12, 1, 0) = 25.0, "Cofactor Matrix3 test 3");
      AUnit.Assertions.Assert (Cofactor (M12, 1, 0) = -25.0, "Cofactor Matrix3 test 4");

      AUnit.Assertions.Assert (Cofactor (M13, 0, 0) = 56.0, "Determinant Matrix3 test 1");
      AUnit.Assertions.Assert (Cofactor (M13, 0, 1) = 12.0, "Determinant Matrix3 test 2");
      AUnit.Assertions.Assert (Cofactor (M13, 0, 2) = -46.0, "Determinant Matrix3 test 3");
      AUnit.Assertions.Assert (Determinant (M13) = -196.0, "Determinant Matrix3 test 4");

      AUnit.Assertions.Assert (Cofactor (M14, 0, 0) = 690.0, "Determinant Matrix4 test 1");
      AUnit.Assertions.Assert (Cofactor (M14, 0, 1) = 447.0, "Determinant Matrix4 test 2");
      AUnit.Assertions.Assert (Cofactor (M14, 0, 2) = 210.0, "Determinant Matrix4 test 3");
      AUnit.Assertions.Assert (Cofactor (M14, 0, 3) = 51.0, "Determinant Matrix4 test 4");
      AUnit.Assertions.Assert (Determinant (M14) = -4071.0, "Determinant Matrix4 test 5");

      AUnit.Assertions.Assert (Determinant (M15) = -2120.0, "Invertibility Matrix4 test 1");
      AUnit.Assertions.Assert (Is_Invertible (M15), "Invertibility Matrix4 test 2");
      AUnit.Assertions.Assert (Determinant (M16) = 0.0, "Invertibility Matrix4 test 3");
      AUnit.Assertions.Assert (not Is_Invertible (M16), "Invertibility Matrix4 test 4");

      AUnit.Assertions.Assert (Determinant (M17) = 532.0, "Inversion Matrix4 test 1");
      AUnit.Assertions.Assert (Cofactor (M17, 2, 3) = -160.0, "Inversion Matrix4 test 2");
      AUnit.Assertions.Assert (M18 (3, 2) = -160.0 / 532.0, "Inversion Matrix4 test 3");
      AUnit.Assertions.Assert (Cofactor (M17, 3, 2) = 105.0, "Inversion Matrix4 test 4");
      AUnit.Assertions.Assert (M18 (2, 3) = 105.0 / 532.0, "Inversion Matrix4 test 5");
      AUnit.Assertions.Assert (M18 = M19, "Inversion Matrix4 test 6");
      AUnit.Assertions.Assert (Invert (M20) = M21, "Inversion Matrix4 test 7");
      AUnit.Assertions.Assert (Invert (M22) = M23, "Inversion Matrix4 test 8");
      AUnit.Assertions.Assert (M26 * Invert (M25) = M24, "Inversion Matrix4 test 9");

      AUnit.Assertions.Assert (Identity_Matrix4 = Invert (Identity_Matrix4), "Extra tests from end of Chapter III, test 1");
      AUnit.Assertions.Assert (M2 * Invert (M2) = Identity_Matrix4, "Extra tests from end of Chapter III, test 2");
      AUnit.Assertions.Assert (Transpose (Invert (M2)) = Invert (Transpose (M2)), "Extra tests from end of Chapter III, test 3");
   end Test_Matrix_Operations;

   procedure Test_Matrix_Transformations (T : in out AUnit.Test_Cases.Test_Case'Class);
   procedure Test_Matrix_Transformations (T : in out AUnit.Test_Cases.Test_Case'Class) is
      pragma Unreferenced (T);

      T1 : constant Matrix4 := Translation (5.0, -3.0, 2.0);
      P1 : constant Point := Make_Point (-3, 4, 5);
      V1 : constant Vector := Make_Vector (-3, 4, 5);

      T2 : constant Matrix4 := Scaling (2.0, 3.0, 4.0);
      P2 : constant Point := Make_Point (2, 3, 4);
      V2 : constant Vector := Make_Vector (-4, 6, 8);

      Half_Quarter : constant Float := Ada.Numerics.Pi / 4.0;
      Full_Quarter : constant Float := Ada.Numerics.Pi / 2.0;
      P3 : constant Point := Make_Point (0, 1, 0);
      P4 : constant Point := Make_Point (0, 0, 1);
   begin
      AUnit.Assertions.Assert (T1 * P1 = Make_Point (2, 1, 7), "Translation test 1");
      AUnit.Assertions.Assert (Invert (T1) * P1 = Make_Point (-8, 7, 3), "Translation test 2");
      AUnit.Assertions.Assert (T1 * V1 = V1, "Translation test 3");

      AUnit.Assertions.Assert (T2 * Make_Point (-4, 6, 8) = Make_Point (-8, 18, 32), "Scaling test 1");
      AUnit.Assertions.Assert (T2 * V2 = Make_Vector (-8, 18, 32), "Scaling test 2");
      AUnit.Assertions.Assert (Invert (T2) * V2 = Make_Vector (-2, 2, 2), "Scaling test 3");
      AUnit.Assertions.Assert (Scaling (-1.0, 1.0, 1.0) * P2 = Make_Point (-2, 3, 4), "Scaling test 4");

      AUnit.Assertions.Assert (Rotation_X (Half_Quarter) * P3 = Make_Point (0.0, 0.70711, 0.70711), "Rotation_X test 1");
      AUnit.Assertions.Assert (Rotation_X (Full_Quarter) * P3 = Make_Point (0, 0, 1), "Rotation_X test 2");
      AUnit.Assertions.Assert (Invert (Rotation_X (Half_Quarter)) * P3 = Make_Point (0.0, 0.70711, -0.70711), "Rotation_X test 3");

      AUnit.Assertions.Assert (Rotation_Y (Half_Quarter) * P4 = Make_Point (0.70711, 0.0, 0.70711), "Rotation_Y test 1");
      AUnit.Assertions.Assert (Rotation_Y (Full_Quarter) * P4 = Make_Point (1, 0, 0), "Rotation_Y test 2");

      AUnit.Assertions.Assert (Rotation_Z (Half_Quarter) * P3 = Make_Point (-0.70711, 0.70711, 0.0), "Rotation_Z test 1");
      AUnit.Assertions.Assert (Rotation_Z (Full_Quarter) * P3 = Make_Point (-1, 0, 0), "Rotation_Z test 2");

      AUnit.Assertions.Assert (Shearing (0.0, 1.0, 0.0, 0.0, 0.0, 0.0) * P2 = Make_Point (6, 3, 4), "Shearing test 1");
      AUnit.Assertions.Assert (Shearing (0.0, 0.0, 1.0, 0.0, 0.0, 0.0) * P2 = Make_Point (2, 5, 4), "Shearing test 2");
      AUnit.Assertions.Assert (Shearing (0.0, 0.0, 0.0, 1.0, 0.0, 0.0) * P2 = Make_Point (2, 7, 4), "Shearing test 3");
      AUnit.Assertions.Assert (Shearing (0.0, 0.0, 0.0, 0.0, 1.0, 0.0) * P2 = Make_Point (2, 3, 6), "Shearing test 4");
      AUnit.Assertions.Assert (Shearing (0.0, 0.0, 0.0, 0.0, 0.0, 1.0) * P2 = Make_Point (2, 3, 7), "Shearing test 5");
   end Test_Matrix_Transformations;

   procedure Test_Ray_Transformations (T : in out AUnit.Test_Cases.Test_Case'Class);
   procedure Test_Ray_Transformations (T : in out AUnit.Test_Cases.Test_Case'Class) is
      pragma Unreferenced (T);

      R : constant Ray := (Make_Point (1, 2, 3), Make_Vector (0, 1, 0));

      M1 : constant Matrix4 := Translation (3.0, 4.0, 5.0);
      T1 : constant Ray := (Make_Point (4, 6, 8), Make_Vector (0, 1, 0));

      M2 : constant Matrix4 := Scaling (2.0, 3.0, 4.0);
      T2 : constant Ray := (Make_Point (2, 6, 12), Make_Vector (0, 3, 0));
   begin
      AUnit.Assertions.Assert (Transform (R, M1) = T1, "Ray transformation test 1 - translation - Ray.Direction stays the same");
      AUnit.Assertions.Assert (Transform (R, M2) = T2, "Ray transformation test 2 - scaling - Ray.Direction is scaled too");
   end Test_Ray_Transformations;

   overriding procedure Register_Tests (T : in out Test) is
      use AUnit.Test_Cases.Registration;
   begin
      Register_Routine (T, Test_Matrix_Operations'Access, "Matrix operations tests");
      Register_Routine (T, Test_Matrix_Transformations'Access, "Matrix transformations tests");
      Register_Routine (T, Test_Ray_Transformations'Access, "Ray transformations tests");
   end Register_Tests;

   overriding function Name (T : Test) return AUnit.Message_String is
      pragma Unreferenced (T);
   begin
      return AUnit.Format ("Radatracer.Matrices");
   end Name;
end Radatracer.Matrices.Tests;
