with Ada.Text_IO;
with Radatracer.Images.IO;

--  Capstone project for Chapter 1 and 2

procedure Simple_Ballistics is
   use type Radatracer.Tuple;
   use type Radatracer.Value;

   type Projectile is record
      Position : Radatracer.Point;
      Velocity : Radatracer.Vector;
   end record;

   type Environment is record
      Gravity : Radatracer.Vector;
      Wind : Radatracer.Vector;
   end record;

   procedure Tick (E : Environment; P : in out Projectile);
   procedure Tick (E : Environment; P : in out Projectile) is
   begin
      P.Position := P.Position + P.Velocity;
      P.Velocity := P.Velocity + E.Gravity + E.Wind;
   end Tick;

   P : Projectile := (
      Position => Radatracer.Make_Point (0, 1, 0),
      Velocity => 11.25 * Radatracer.Normalize (Radatracer.Make_Vector (1.0, 1.8, 0.0))
   );

   E : constant Environment := (
      Gravity => Radatracer.Make_Vector (0.0, -0.1, 0.0),
      Wind => Radatracer.Make_Vector (-0.01, 0.0, 0.0)
   );

   Width : constant := 900;
   Height : constant := 550;
   Canvas : Radatracer.Images.Canvas (0 .. Width - 1, 0 .. Height - 1);

   X, Y : Integer;
begin
   loop
      X := Integer (P.Position.X);
      Y := Canvas'Length (2) - Integer (P.Position.Y);

      exit when (X not in Canvas'Range (1)) or (Y not in Canvas'Range (2));

      Canvas (X, Y) := Radatracer.Images.Red_Pixel;

      Tick (E, P);
   end loop;

   Radatracer.Images.IO.Write_PPM (Ada.Text_IO.Standard_Output, Canvas);
end Simple_Ballistics;
