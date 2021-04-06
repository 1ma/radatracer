with Ada.Numerics.Elementary_Functions;
with AUnit.Assertions;

package body Radatracer.Matrices.Tests is
   procedure Test_Matrix_Operations (T : in out AUnit.Test_Cases.Test_Case'Class);
   procedure Test_Matrix_Operations (T : in out AUnit.Test_Cases.Test_Case'Class) is
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
   begin
      AUnit.Assertions.Assert (M1 * M2 = M3, "Matrix4 multiplication test");

      AUnit.Assertions.Assert (M4 * T1 = T2, "Matrix4 * Tuple multiplication test");

      AUnit.Assertions.Assert (Identity_Matrix4 * M1 = M1, "Identity Matrix4 multiplication test 1");
      AUnit.Assertions.Assert (M1 * Identity_Matrix4 = M1, "Identity Matrix4 multiplication test 2");

      AUnit.Assertions.Assert (Transpose (M5) = M6, "Matrix4 transposition multiplication test 1");
      AUnit.Assertions.Assert (Transpose (Identity_Matrix4) = Identity_Matrix4, "Matrix4 transposition multiplication test 2");
   end Test_Matrix_Operations;

   overriding procedure Register_Tests (T : in out Test) is
      use AUnit.Test_Cases.Registration;
   begin
      Register_Routine (T, Test_Matrix_Operations'Access, "Matrix operations tests");
   end Register_Tests;

   overriding function Name (T : Test) return AUnit.Message_String is
      pragma Unreferenced (T);
   begin
      return AUnit.Format ("Radatracer.Matrices");
   end Name;
end Radatracer.Matrices.Tests;
