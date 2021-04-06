with Ada.Text_IO;
with Radatracer.Matrices;

use type Radatracer.Value;
use type Radatracer.Matrices.Matrix;

procedure Test_Drive is
   package Value_IO is new Ada.Text_IO.Float_IO (Radatracer.Value);

   procedure Print_Matrix (M : Radatracer.Matrices.Matrix);
   procedure Print_Matrix (M : Radatracer.Matrices.Matrix) is
   begin
      for Row in M'Range (1) loop
         for Column in M'Range (2) loop
            Value_IO.Put (Item => M (Row, Column), Exp => 0);
            Ada.Text_IO.Put (" ");
         end loop;
         Ada.Text_IO.New_Line;
      end loop;
      Ada.Text_IO.New_Line;
   end Print_Matrix;

   M1 : constant Radatracer.Matrices.Matrix4 := (
      (1.0, 2.0, 3.0, 4.0),
      (5.0, 6.0, 7.0, 8.0),
      (9.0, 8.0, 7.0, 6.0),
      (5.0, 4.0, 3.0, 2.0)
   );

   M2 : constant Radatracer.Matrices.Matrix4 := (
      (-2.0, 1.0, 2.0, 3.0),
      (3.0, 2.0, 1.0, -1.0),
      (4.0, 3.0, 6.0, 5.0),
      (1.0, 2.0, 7.0, 8.0)
   );

   M3 : constant Radatracer.Matrices.Matrix4 := M1 * M2;
begin
   Print_Matrix (M3);
end Test_Drive;
