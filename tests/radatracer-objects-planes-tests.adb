with AUnit.Assertions;

package body Radatracer.Objects.Planes.Tests is
   procedure Test_One (T : in out AUnit.Test_Cases.Test_Case'Class);
   procedure Test_One (T : in out AUnit.Test_Cases.Test_Case'Class) is
      pragma Unreferenced (T);
   begin
      AUnit.Assertions.Assert (True, "First test");
   end Test_One;

   overriding procedure Register_Tests (T : in out Test) is
      use AUnit.Test_Cases.Registration;
   begin
      Register_Routine (T, Test_One'Access, "First test");
   end Register_Tests;

   overriding function Name (T : Test) return AUnit.Message_String is
      pragma Unreferenced (T);
   begin
      return AUnit.Format ("Radatracer.Objects.Planes");
   end Name;
end Radatracer.Objects.Planes.Tests;
