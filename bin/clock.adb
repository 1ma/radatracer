with Ada.Numerics;
with Ada.Text_IO;
with Radatracer.Images.IO;
with Radatracer.Matrices;

--  Capstone project for Chapter 4

procedure Clock is
   use type Radatracer.Matrices.Matrix4;
   use type Radatracer.Value;

   Side_Length : constant := 100;
   Canvas : Radatracer.Images.Canvas (1 .. Side_Length, 1 .. Side_Length);

   Hour : Radatracer.Point := Radatracer.Make_Point (0, 0, 0);
   Midnight : constant Radatracer.Point := Radatracer.Make_Point (0, 1, 0);

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

      Canvas (Positive (Hour.X), Positive (Hour.Y)) := Radatracer.Images.Red_Pixel;
   end loop;

   Radatracer.Images.IO.Write_PPM (Ada.Text_IO.Standard_Output, Canvas);
end Clock;
