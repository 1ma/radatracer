with Ada.Text_IO;
with Radatracer;

use type Radatracer.Tuple;

procedure Test_Drive is
   A : constant Radatracer.Tuple := (1.0, 1.0, 1.0, 1.0);
   B : constant Radatracer.Tuple := (1.0, 2.0, 3.0, 0.0);
   C : constant Radatracer.Tuple := A + B;
   D : constant Radatracer.Tuple := B - A;
   E : constant Radatracer.Tuple := -B;

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
begin
   Print_Tuple (A);
   Print_Tuple (B);
   Print_Tuple (C);
   Print_Tuple (D);
   Print_Tuple (E);
end Test_Drive;
