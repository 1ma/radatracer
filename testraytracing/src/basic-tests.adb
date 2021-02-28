with AUnit.Assertions;
with Basic;

package body Basic.Tests is
   procedure Test_First (T : in out AUnit.Test_Cases.Test_Case'Class);
   procedure Test_First (T : in out AUnit.Test_Cases.Test_Case'Class) is
      pragma Unreferenced (T);
      P : constant Tuple := Basic.New_Point (4.0, -4.0, 3.0);
      V : constant Tuple := Basic.New_Vector (4.0, -4.0, 3.0);
   begin
      AUnit.Assertions.Assert (P.W = 1.0, "A Point's W component is 1.0");
      AUnit.Assertions.Assert (V.W = 0.0, "A Vector's W component is 1.0");
   end Test_First;

   overriding procedure Register_Tests (T : in out Test) is
      use AUnit.Test_Cases.Registration;
   begin
      Register_Routine (T, Test_First'Access, "Simple Tuple Tests");
   end Register_Tests;

   overriding function Name (T : Test) return AUnit.Message_String is
      pragma Unreferenced (T);
   begin
      return AUnit.Format ("Basic");
   end Name;
end Basic.Tests;
