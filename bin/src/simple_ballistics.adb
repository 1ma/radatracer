with Ada.Text_IO;
with Basic;

use type Basic.Tuple;
use type Basic.Value;

procedure Simple_Ballistics is
   type Projectile is record
      Position : Basic.Tuple;
      Velocity : Basic.Tuple;
   end record;

   type Environment is record
      Gravity : Basic.Tuple;
      Wind : Basic.Tuple;
   end record;

   procedure Print_Tuple (T : Basic.Tuple);
   procedure Print_Tuple (T : Basic.Tuple) is
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
      Position => Basic.Make_Point (0.0, 1.0, 0.0),
      Velocity => Basic.Normalize (Basic.Make_Vector (1.0, 0.0, 0.0))
   );

   E : constant Environment := (
      Gravity => Basic.Make_Vector (0.0, -0.1, 0.0),
      Wind => Basic.Make_Vector (-0.01, 0.0, 0.0)
   );
begin
   while P.Position.Y > 0.0 loop
      P := Tick (E, P);
      Print_Tuple (P.Position);
   end loop;

   Print_Tuple (P.Position);
end Simple_Ballistics;
