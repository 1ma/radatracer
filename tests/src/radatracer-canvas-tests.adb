with Ada.Numerics.Elementary_Functions;
with AUnit.Assertions;

package body Radatracer.Canvas.Tests is
   procedure Test_Color_Conversion (T : in out AUnit.Test_Cases.Test_Case'Class);
   procedure Test_Color_Conversion (T : in out AUnit.Test_Cases.Test_Case'Class) is
      P : constant Pixel := To_Pixel (Make_Color (-0.5, 0.4, 1.7));
   begin
      AUnit.Assertions.Assert (P.Red = 0 and P.Green = 102 and P.Blue = 255, "Expected conversion");
   end Test_Color_Conversion;

   procedure Test_Canvas_Instantiation (T : in out AUnit.Test_Cases.Test_Case'Class);
   procedure Test_Canvas_Instantiation (T : in out AUnit.Test_Cases.Test_Case'Class) is
      Black_Pixel : constant Pixel := (Red => 0, Green => 0, Blue => 0);
      C : constant Canvas := Make_Canvas (10, 20);
   begin
      for Width in C'Range (1) loop
         for Height in C'Range (2) loop
            AUnit.Assertions.Assert (C (Width, Height) = Black_Pixel, "All pixels of a fresh canvas are black");
         end loop;
      end loop;
   end Test_Canvas_Instantiation;

   overriding procedure Register_Tests (T : in out Test) is
      use AUnit.Test_Cases.Registration;
   begin
      Register_Routine (T, Test_Color_Conversion'Access, "Color conversion tests");
      Register_Routine (T, Test_Canvas_Instantiation'Access, "Canvas tests");
   end Register_Tests;

   overriding function Name (T : Test) return AUnit.Message_String is
      pragma Unreferenced (T);
   begin
      return AUnit.Format ("Radatracer.Canvas");
   end Name;
end Radatracer.Canvas.Tests;
