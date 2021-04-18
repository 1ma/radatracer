with Ada.Numerics.Generic_Elementary_Functions;

package body Radatracer.Objects is
   procedure Set_Transformation (S : in out Sphere; Transformation : Radatracer.Matrices.Matrix4) is
   begin
      S.Inverted_Transformation := Radatracer.Matrices.Invert (Transformation);
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

   function Intersect (S : Sphere; R : Ray) return Intersection_Vectors.Vector is
      package Math is new Ada.Numerics.Generic_Elementary_Functions (Value);
      Result : Intersection_Vectors.Vector;

      Sphere_Origin : constant Point := Make_Point (0, 0, 0);

      Transformed_Ray : constant Ray := Radatracer.Matrices.Transform (R, S.Inverted_Transformation);

      Sphere_Ray_Vector : constant Vector := Transformed_Ray.Origin - Sphere_Origin;
      A : constant Value := 2.0 * Dot_Product (Transformed_Ray.Direction, Transformed_Ray.Direction);
      B : constant Value := 2.0 * Dot_Product (Transformed_Ray.Direction, Sphere_Ray_Vector);
      C : constant Value := Dot_Product (Sphere_Ray_Vector, Sphere_Ray_Vector) - 1.0;
      Discriminant : constant Value := (B * B) - (2.0 * A * C);
   begin
      if Discriminant >= 0.0 then
         Result.Append ((T_Value => (-B - Math.Sqrt (Discriminant)) / A, Object => S));
         Result.Append ((T_Value => (-B + Math.Sqrt (Discriminant)) / A, Object => S));
      end if;

      return Result;
   end Intersect;

   function Normal_At (S : Sphere; World_Point : Point) return Vector is
      use type Radatracer.Matrices.Matrix4;

      Object_Origin : constant Point := Make_Point (0, 0, 0);
      Object_Point : constant Point := S.Inverted_Transformation * World_Point;
      Object_Normal : constant Vector := Object_Point - Object_Origin;
      World_Normal : Tuple := Radatracer.Matrices.Transpose (S.Inverted_Transformation) * Object_Normal;
   begin
      World_Normal.W := 0.0;
      return Normalize (Vector (World_Normal));
   end Normal_At;

   function Reflect (V, Normal : Vector) return Vector is
   begin
      return V - Normal * 2.0 * Dot_Product (V, Normal);
   end Reflect;

   function Lightning (M : Material; PL : Point_Light; Position : Point; Eye_Vector : Vector; Normal_Vector : Vector) return Color is
      Light_Vector : constant Vector := Normalize (PL.Position - Position);
      Light_Dot_Normal : constant Value := Dot_Product (Light_Vector, Normal_Vector);

      Effective_Color : constant Color := M.Color * PL.Intensity;
      Ambient : constant Color := Effective_Color * M.Ambient;
   begin
      if Light_Dot_Normal < 0.0 then
         return Ambient;
      end if;

      declare
         Reflect_Vector : constant Vector := Reflect (-Light_Vector, Normal_Vector);
         Reflect_Dot_Eye : constant Value := Dot_Product (Reflect_Vector, Eye_Vector);

         Diffuse : constant Color := Effective_Color * M.Diffuse * Light_Dot_Normal;
         Specular : Color := Make_Color (0.0, 0.0, 0.0);
      begin
         if Reflect_Dot_Eye > 0.0 then
            Specular := PL.Intensity * M.Specular * (Reflect_Dot_Eye ** Natural (M.Shininess));
         end if;

         return Ambient + Diffuse + Specular;
      end;
   end Lightning;

   function Intersect (W : World; R : Ray) return Intersection_Vectors.Vector is
      use type Intersection_Vectors.Vector;

      package Intersection_Vector_Sorting is new Intersection_Vectors.Generic_Sorting;

      Intersections : Intersection_Vectors.Vector;
   begin
      for Cursor in W.Objects.Iterate loop
         Intersections := Intersections & Intersect (W.Objects (Cursor), R);
      end loop;

      Intersection_Vector_Sorting.Sort (Intersections);

      return Intersections;
   end Intersect;

end Radatracer.Objects;
