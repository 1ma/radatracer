with Ada.Text_IO;
with Radatracer;
with Radatracer.Canvas;
with Radatracer.Canvas.IO;

use type Radatracer.Tuple;
use type Radatracer.Value;

procedure Simple_Ballistics is
   type Projectile is record
      Position : Radatracer.Tuple;
      Velocity : Radatracer.Tuple;
   end record;

   type Environment is record
      Gravity : Radatracer.Tuple;
      Wind : Radatracer.Tuple;
   end record;

   function Tick (E : Environment; P : Projectile) return Projectile;
   function Tick (E : Environment; P : Projectile) return Projectile is
      P2 : constant Projectile := (
         Position => P.Position + P.Velocity,
         Velocity => P.Velocity + E.Gravity + E.Wind
      );
   begin
      return P2;
   end Tick;

   P : Projectile := (
      Position => Radatracer.Make_Point (0.0, 1.0, 0.0),
      Velocity => 11.25 * Radatracer.Normalize (Radatracer.Make_Vector (1.0, 1.8, 0.0))
   );

   E : constant Environment := (
      Gravity => Radatracer.Make_Vector (0.0, -0.1, 0.0),
      Wind => Radatracer.Make_Vector (-0.01, 0.0, 0.0)
   );

   Red_Pixel : constant Radatracer.Canvas.Pixel := (255, 0, 0);

   C : Radatracer.Canvas.Canvas := Radatracer.Canvas.Make_Canvas (900, 550);
begin
   while True loop
      P := Tick (E, P);

      declare
         X : constant Integer := Integer (P.Position.X);
         Y : constant Integer := C'Length (2) - Integer (P.Position.Y);
      begin
         exit when X < 0 or X > C'Length (1) or Y < 0 or Y > C'Length (2);

         C (X, Y) := Red_Pixel;
      end;
   end loop;

   Radatracer.Canvas.IO.Write_PPM (Ada.Text_IO.Standard_Output, C);
end Simple_Ballistics;
