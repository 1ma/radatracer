with Ada.Numerics;
with AUnit.Assertions;

package body Radatracer.Rays.Tests is
   procedure Test_Ray_Calculations (T : in out AUnit.Test_Cases.Test_Case'Class);
   procedure Test_Ray_Calculations (T : in out AUnit.Test_Cases.Test_Case'Class) is
      R1 : constant Ray := (Origin => Make_Point (2.0, 3.0, 4.0), Direction => Make_Vector (1.0, 0.0, 0.0));
   begin
      AUnit.Assertions.Assert (Position (R1, 0.0) = Make_Point (2.0, 3.0, 4.0), "Ray position test 1");
      AUnit.Assertions.Assert (Position (R1, 1.0) = Make_Point (3.0, 3.0, 4.0), "Ray position test 2");
      AUnit.Assertions.Assert (Position (R1, -1.0) = Make_Point (1.0, 3.0, 4.0), "Ray position test 3");
      AUnit.Assertions.Assert (Position (R1, 2.5) = Make_Point (4.5, 3.0, 4.0), "Ray position test 4");
   end Test_Ray_Calculations;

   overriding procedure Register_Tests (T : in out Test) is
      use AUnit.Test_Cases.Registration;
   begin
      Register_Routine (T, Test_Ray_Calculations'Access, "Ray calculations tests");
   end Register_Tests;

   overriding function Name (T : Test) return AUnit.Message_String is
      pragma Unreferenced (T);
   begin
      return AUnit.Format ("Radatracer.Rays");
   end Name;
end Radatracer.Rays.Tests;
