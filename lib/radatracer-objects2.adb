package body Radatracer.Objects2 is
   procedure Set_Transformation (Self : in out Object; Transformation : Radatracer.Matrices.Matrix4) is
   begin
      Self.Inverted_Transformation := Radatracer.Matrices.Invert (Transformation);
   end Set_Transformation;

   function "<" (L, R : Intersection) return Boolean is
   begin
      return L.T_Value < R.T_Value;
   end "<";

   function Hit (Intersections : Intersection_Vectors.Vector) return Intersection_Vectors.Cursor is
      package Intersection_Vector_Sorting is new Intersection_Vectors.Generic_Sorting;

      Sorted_Intersections : Intersection_Vectors.Vector := Intersections;
   begin
      Intersection_Vector_Sorting.Sort (Sorted_Intersections);

      for Cursor in Sorted_Intersections.Iterate loop
         if Sorted_Intersections (Cursor).T_Value >= 0.0 then
            return Intersections.Find (Sorted_Intersections (Cursor));
         end if;
      end loop;

      return Intersection_Vectors.No_Element;
   end Hit;

   overriding function Normal_At (Self : Sphere; World_Point : Point) return Vector is
      use type Radatracer.Matrices.Matrix4;

      Sphere_Origin : constant Point := Make_Point (0, 0, 0);
      Object_Point : constant Point := Self.Inverted_Transformation * World_Point;
      Object_Normal : constant Vector := Object_Point - Sphere_Origin;
      World_Normal : Tuple := Radatracer.Matrices.Transpose (Self.Inverted_Transformation) * Object_Normal;
   begin
      World_Normal.W := 0.0;
      return Normalize (Vector (World_Normal));
   end Normal_At;

   overriding function Normal_At (Self : Plane; World_Point : Point) return Vector is
      pragma Unreferenced (Self, World_Point);
   begin
      return Make_Vector (0, 1, 0);
   end Normal_At;
end Radatracer.Objects2;
