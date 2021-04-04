with Ada.Text_IO;
with Radatracer;
with Radatracer.Canvas;
with Radatracer.Canvas.IO;

procedure Test_Drive is
   C : Radatracer.Canvas.Canvas := Radatracer.Canvas.Make_Canvas (3, 3);
begin
   C (1, 1) := Radatracer.Canvas.To_Pixel (Radatracer.Make_Color (1.0, 0.0, 0.0));
   C (2, 2) := Radatracer.Canvas.To_Pixel (Radatracer.Make_Color (0.0, 1.0, 0.0));
   C (3, 3) := Radatracer.Canvas.To_Pixel (Radatracer.Make_Color (0.0, 0.0, 1.0));

   Radatracer.Canvas.IO.Write_PPM (Ada.Text_IO.Standard_Output, C);
end Test_Drive;
