with Ada.Text_IO;
with Radatracer;

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

   procedure Print_Tuple (T : Radatracer.Tuple);
   procedure Print_Tuple (T : Radatracer.Tuple) is
   begin
      Ada.Text_IO.Put ("X =>");
      Ada.Text_IO.Put (T.X'Image);
      Ada.Text_IO.Put (", Y =>");
      Ada.Text_IO.Put (T.Y'Image);
      Ada.Text_IO.Put (", Z =>");
      Ada.Text_IO.Put (T.Z'Image);
      Ada.Text_IO.Put (", W =>");
      Ada.Text_IO.Put (T.W'Image);
      Ada.Text_IO.New_Line;
   end Print_Tuple;

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
      Velocity => Radatracer.Normalize (Radatracer.Make_Vector (1.0, 0.0, 0.0))
   );

   E : constant Environment := (
      Gravity => Radatracer.Make_Vector (0.0, -0.1, 0.0),
      Wind => Radatracer.Make_Vector (-0.01, 0.0, 0.0)
   );
begin
   while P.Position.Y > 0.0 loop
      P := Tick (E, P);
      Print_Tuple (P.Position);
   end loop;
end Simple_Ballistics;
