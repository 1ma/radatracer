with Ada.Containers;
with Ada.Text_IO;
with Radatracer.Objects;

use type Radatracer.Objects.Intersection_Vectors.Vector;

procedure Test_Drive is
   I : constant Radatracer.Objects.Intersection := (
      T_Value => 1.0,
      Object => (Origin => Radatracer.Make_Point (0, 0, 0))
   );

   A : Radatracer.Objects.Intersection_Vectors.Vector := I & I;
   A2 : constant Radatracer.Objects.Intersection_Vectors.Vector := A;
begin
   A.Append (I);

   Ada.Text_IO.Put_Line ("Vector has" & Ada.Containers.Count_Type'Image (A.Length) & " elements");
   Ada.Text_IO.Put_Line ("Vector has" & Ada.Containers.Count_Type'Image (A2.Length) & " elements");
end Test_Drive;
