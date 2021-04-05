with Ada.Text_IO;
with Radatracer.Canvas;
with Radatracer.Canvas.IO;

procedure Test_Drive is
   C : Radatracer.Canvas.Canvas := Radatracer.Canvas.Make_Canvas (3, 3);
begin
   C (1, 1) := (255, 0, 0);
   C (2, 2) := (0, 255, 0);
   C (3, 3) := (0, 0, 255);

   Radatracer.Canvas.IO.Write_PPM (Ada.Text_IO.Standard_Output, C);
end Test_Drive;
