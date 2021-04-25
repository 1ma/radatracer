with Ada.Text_IO;
with Radatracer.Matrices;
with Radatracer.Objects2;

--  Playground executable to try out parts of the library

procedure Test_Drive is
   use Ada.Text_IO;
   use Radatracer;
   use Radatracer.Matrices;
   use Radatracer.Objects2;

   procedure Print_Tuple (T : Tuple);
   procedure Print_Tuple (T : Tuple) is
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
   S : constant not null Object_Access := new Sphere;
   I : constant Intersection := (T_Value => 1.0, Object => S);
   V : Intersection_Vectors.Vector;
   C : Intersection_Vectors.Cursor;
begin
   S.Set_Transformation (Scaling (10.0, 1.0, 10.0));
   --  Check that Sphere inherits the Set_Transformation method

   V.Append ((T_Value => -2.0, Object => new Sphere));
   V.Append ((T_Value => 2.0, Object => new Plane));
   V.Append (I);
   --  Append Intersections to different kinds of objects

   C := Hit (V);

   Put_Line (V (C).T_Value'Image);
   New_Line;
   --  Check that Hit works, returning a Cursor to the Intersection
   --  with the lowest non-negative T_Value, in this case 1.0

   for Cursor in V.Iterate loop
      Put_Line (V (Cursor).T_Value'Image);
      Print_Tuple (V (Cursor).Object.all.Normal_At (P));
      --  Dispatching calls to Normal_At method
   end loop;
end Test_Drive;
