with Ada.Text_IO;
with Ada.Numerics.Elementary_Functions;
with AUnit.Assertions;

package body Radatracer.Canvas.IO.Tests is
   procedure Test_Color_Conversion (T : in out AUnit.Test_Cases.Test_Case'Class);
   procedure Test_Color_Conversion (T : in out AUnit.Test_Cases.Test_Case'Class) is
      P : constant Pixel := To_Pixel (Make_Color (-0.5, 0.4, 1.7));
   begin
      AUnit.Assertions.Assert (P.Red = 0 and P.Green = 102 and P.Blue = 255, "Expected conversion");
   end Test_Color_Conversion;

   procedure Test_Canvas_Instantiation (T : in out AUnit.Test_Cases.Test_Case'Class);
   procedure Test_Canvas_Instantiation (T : in out AUnit.Test_Cases.Test_Case'Class) is
      Black_Pixel : constant Pixel := (Red => 0, Green => 0, Blue => 0);
      C : Canvas (1 .. 10, 1 .. 20);
   begin
      for Width in C'Range (1) loop
         for Height in C'Range (2) loop
            AUnit.Assertions.Assert (C (Width, Height) = Black_Pixel, "All pixels of a fresh canvas are black");
         end loop;
      end loop;

      C (2, 3) := Red_Pixel;
      AUnit.Assertions.Assert (C (2, 3) = Red_Pixel, "Pixels can be rewritten on the canvas");
   end Test_Canvas_Instantiation;

   procedure Test_Canvas_IO (T : in out AUnit.Test_Cases.Test_Case'Class);
   procedure Test_Canvas_IO (T : in out AUnit.Test_Cases.Test_Case'Class) is
      FT : Ada.Text_IO.File_Type;
      C1 : Canvas (0 .. 4, 0 .. 2);
      C2 : constant Canvas (0 .. 9, 0 .. 1) := (others => (others => To_Pixel (Make_Color (1.0, 0.8, 0.6))));
   begin
      Ada.Text_IO.Create (File => FT, Mode => Ada.Text_IO.Out_File);

      C1 (0, 0) := To_Pixel (Make_Color (1.5, 0.0, 0.0));
      C1 (2, 1) := To_Pixel (Make_Color (0.0, 0.5, 0.0));
      C1 (4, 2) := To_Pixel (Make_Color (-0.5, 0.0, 1.0));

      Write_PPM (FT, C1);

      Ada.Text_IO.Reset (File => FT, Mode => Ada.Text_IO.In_File);

      AUnit.Assertions.Assert (Ada.Text_IO.Get_Line (FT) = "P3", "");
      AUnit.Assertions.Assert (Ada.Text_IO.Get_Line (FT) = "5 3", "");
      AUnit.Assertions.Assert (Ada.Text_IO.Get_Line (FT) = "255", "");
      AUnit.Assertions.Assert (Ada.Text_IO.Get_Line (FT) = "255 0 0 0 0 0 0 0 0 0 0 0 0 0 0", "");
      AUnit.Assertions.Assert (Ada.Text_IO.Get_Line (FT) = "0 0 0 0 0 0 0 128 0 0 0 0 0 0 0", "");
      AUnit.Assertions.Assert (Ada.Text_IO.Get_Line (FT) = "0 0 0 0 0 0 0 0 0 0 0 0 0 0 255", "");
      AUnit.Assertions.Assert (Ada.Text_IO.End_Of_File (FT), "");

      Ada.Text_IO.Reset (File => FT, Mode => Ada.Text_IO.Out_File);

      Write_PPM (FT, C2);

      Ada.Text_IO.Reset (File => FT, Mode => Ada.Text_IO.In_File);

      AUnit.Assertions.Assert (Ada.Text_IO.Get_Line (FT) = "P3", "");
      AUnit.Assertions.Assert (Ada.Text_IO.Get_Line (FT) = "10 2", "");
      AUnit.Assertions.Assert (Ada.Text_IO.Get_Line (FT) = "255", "");
      AUnit.Assertions.Assert (Ada.Text_IO.Get_Line (FT) = "255 204 153 255 204 153 255 204 153 255 204 153 255 204 153 255 204", "");
      AUnit.Assertions.Assert (Ada.Text_IO.Get_Line (FT) = "153 255 204 153 255 204 153 255 204 153 255 204 153", "");
      AUnit.Assertions.Assert (Ada.Text_IO.Get_Line (FT) = "255 204 153 255 204 153 255 204 153 255 204 153 255 204 153 255 204", "");
      AUnit.Assertions.Assert (Ada.Text_IO.Get_Line (FT) = "153 255 204 153 255 204 153 255 204 153 255 204 153", "");
      AUnit.Assertions.Assert (Ada.Text_IO.End_Of_File (FT), "");
   end Test_Canvas_IO;

   overriding procedure Register_Tests (T : in out Test) is
      use AUnit.Test_Cases.Registration;
   begin
      Register_Routine (T, Test_Color_Conversion'Access, "Color conversion tests");
      Register_Routine (T, Test_Canvas_Instantiation'Access, "Canvas tests");
      Register_Routine (T, Test_Canvas_IO'Access, "Canvas IO tests");
   end Register_Tests;

   overriding function Name (T : Test) return AUnit.Message_String is
      pragma Unreferenced (T);
   begin
      return AUnit.Format ("Radatracer.Canvas");
   end Name;
end Radatracer.Canvas.IO.Tests;
