with Ada.Text_IO;
with Radatracer.Objects;

procedure Test_Drive is
   A : constant Radatracer.Objects.Intersection_Array := (
      (
         T_Value => 1.0,
         Object => new Radatracer.Objects.Sphere'(
            Origin => Radatracer.Make_Point (1, 2, 3)
         )
      ),
      (
         T_Value => 3.0,
         Object => new Radatracer.Objects.Square'(
            Lower_Left_Corner => Radatracer.Make_Point (2, 2, 2),
            Side_Length => 10.5
         )
      )
   );

begin
   for I in A'Range loop
      Ada.Text_IO.Put ("Element # " & Integer'Image (I) & " - Class: ");

      if A (I).Object.all in Radatracer.Objects.Sphere'Class then
         Ada.Text_IO.Put_Line ("Sphere");
      end if;

      if A (I).Object.all in Radatracer.Objects.Square'Class then
         Ada.Text_IO.Put_Line ("Square");
      end if;
   end loop;
end Test_Drive;
