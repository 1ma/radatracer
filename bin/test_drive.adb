with Ada.Containers;
with Ada.Text_IO;
with Radatracer.Objects;

--  Playground executable to try out parts of the library

procedure Test_Drive is
   use type Radatracer.Objects.Intersection_Vectors.Vector;

   I : constant Radatracer.Objects.Intersection := (
      T_Value => 1.0,
      Object => (Inverted_Transformation => <>, Material => <>)
   );

   A : Radatracer.Objects.Intersection_Vectors.Vector := I & I;
   A2 : constant Radatracer.Objects.Intersection_Vectors.Vector := A;
begin
   A.Append (I);

   Ada.Text_IO.Put_Line ("Vector has" & Ada.Containers.Count_Type'Image (A.Length) & " elements");
   Ada.Text_IO.Put_Line ("Vector has" & Ada.Containers.Count_Type'Image (A2.Length) & " elements");
end Test_Drive;
