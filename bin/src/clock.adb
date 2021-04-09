with Ada.Numerics;
with Ada.Text_IO;
with Radatracer.Canvas.IO;
with Radatracer.Matrices;

use type Radatracer.Matrices.Matrix4;
use type Radatracer.Value;

procedure Clock is
   Side_Length : constant := 100;
   Canvas : Radatracer.Canvas.Canvas := Radatracer.Canvas.Make_Canvas (Side_Length, Side_Length);

   Hour : Radatracer.Tuple;
   Midnight : constant Radatracer.Tuple := Radatracer.Make_Point (0.0, 1.0, 0.0);

   Radians : Float;

   Translation : constant Radatracer.Matrices.Matrix4 := Radatracer.Matrices.Translation (
      Radatracer.Value (Side_Length) / 2.0,
      Radatracer.Value (Side_Length) / 2.0,
      0.0
   );

   Scaling : constant Radatracer.Matrices.Matrix4 := Radatracer.Matrices.Scaling (
      Radatracer.Value (Side_Length) * 3.0 / 8.0,
      Radatracer.Value (Side_Length) * 3.0 / 8.0,
      0.0
   );
begin
   for I in 1 .. 12 loop
      Radians := Float (I) * Ada.Numerics.Pi / 6.0;

      Hour := Translation * Scaling * Radatracer.Matrices.Rotation_Z (Radians) * Midnight;

      Canvas (Positive (Hour.X), Positive (Hour.Y)) := Radatracer.Canvas.Red_Pixel;
   end loop;

   Radatracer.Canvas.IO.Write_PPM (Ada.Text_IO.Standard_Output, Canvas);
end Clock;
