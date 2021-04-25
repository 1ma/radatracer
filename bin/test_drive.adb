with Ada.Text_IO;
with Radatracer.Matrices;
with Radatracer.Objects2;

--  Playground executable to try out parts of the library

procedure Test_Drive is
   use Radatracer;
   use Radatracer.Matrices;
   use Radatracer.Objects2;

   procedure Print_Tuple (T : Tuple);
   procedure Print_Tuple (T : Tuple) is
      use Ada.Text_IO;
   begin
      Put ("X =>");
      Put (T.X'Image);
      Put (", Y =>");
      Put (T.Y'Image);
      Put (", Z =>");
      Put (T.Z'Image);
      Put (", W =>");
      Put (T.W'Image);
      New_Line;
   end Print_Tuple;

   P : constant Point := Make_Point (0, 0, 1);
   S : Sphere;
begin
   S.Set_Transformation (Scaling (10.0, 1.0, 10.0));
   --  Check that Sphere inherits the Set_Transformation method

   Print_Tuple (S.Normal_At (P));
end Test_Drive;
