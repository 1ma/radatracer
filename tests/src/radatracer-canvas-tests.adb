with Ada.Numerics.Elementary_Functions;
with AUnit.Assertions;

package body Radatracer.Canvas.Tests is
   procedure Test_Color_Conversion (T : in out AUnit.Test_Cases.Test_Case'Class);
   procedure Test_Color_Conversion (T : in out AUnit.Test_Cases.Test_Case'Class) is
      P : constant Pixel := To_Pixel (Make_Color (-0.5, 0.4, 1.7));
   begin
      AUnit.Assertions.Assert (P.Red = 0 and P.Green = 102 and P.Blue = 255, "Expected conversion");
   end Test_Color_Conversion;

   overriding procedure Register_Tests (T : in out Test) is
      use AUnit.Test_Cases.Registration;
   begin
      Register_Routine (T, Test_Color_Conversion'Access, "Color conversion tests");
   end Register_Tests;

   overriding function Name (T : Test) return AUnit.Message_String is
      pragma Unreferenced (T);
   begin
      return AUnit.Format ("Radatracer.Canvas");
   end Name;
end Radatracer.Canvas.Tests;
