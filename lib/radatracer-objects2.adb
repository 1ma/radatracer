with Ada.Numerics.Generic_Elementary_Functions;

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

   function Reflect (V, Normal : Vector) return Vector is
   begin
      return V - Normal * 2.0 * Dot_Product (V, Normal);
   end Reflect;

   function Lightning (
      Material : Radatracer.Objects2.Material;
      Light : Point_Light;
      Position : Point;
      Eye_Vector : Vector;
      Normal_Vector : Vector;
      In_Shadow : Boolean := False
   ) return Color is
      Effective_Color : constant Color := Material.Color * Light.Intensity;
      Ambient : constant Color := Effective_Color * Material.Ambient;
   begin
      if In_Shadow then
         return Ambient;
      end if;

      declare
         Light_Vector : constant Vector := Normalize (Light.Position - Position);
         Light_Dot_Normal : constant Value := Dot_Product (Light_Vector, Normal_Vector);
      begin
         if Light_Dot_Normal < 0.0 then
            return Ambient;
         end if;

         declare
            Reflect_Vector : constant Vector := Reflect (-Light_Vector, Normal_Vector);
            Reflect_Dot_Eye : constant Value := Dot_Product (Reflect_Vector, Eye_Vector);

            Diffuse : constant Color := Effective_Color * Material.Diffuse * Light_Dot_Normal;
         begin
            if Reflect_Dot_Eye <= 0.0 then
               return Ambient + Diffuse;
            end if;

            declare
               package Math is new Ada.Numerics.Generic_Elementary_Functions (Value);
               use Math;

               Specular : constant Color := Light.Intensity * Material.Specular * (Reflect_Dot_Eye ** Material.Shininess);
            begin
               return Ambient + Diffuse + Specular;
            end;
         end;
      end;
   end Lightning;

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

   overriding function Intersect (Self : aliased in out Sphere; R : Ray) return Intersection_Vectors.Vector is
      package Math is new Ada.Numerics.Generic_Elementary_Functions (Value);

      Result : Intersection_Vectors.Vector;

      Sphere_Origin : constant Point := Make_Point (0, 0, 0);

      Transformed_Ray : constant Ray := Radatracer.Matrices.Transform (R, Self.Inverted_Transformation);

      Sphere_Ray_Vector : constant Vector := Transformed_Ray.Origin - Sphere_Origin;
      A : constant Value := 2.0 * Dot_Product (Transformed_Ray.Direction, Transformed_Ray.Direction);
      B : constant Value := 2.0 * Dot_Product (Transformed_Ray.Direction, Sphere_Ray_Vector);
      C : constant Value := Dot_Product (Sphere_Ray_Vector, Sphere_Ray_Vector) - 1.0;
      Discriminant : constant Value := (B * B) - (2.0 * A * C);
   begin
      if Discriminant >= 0.0 then
         Result.Append ((T_Value => (-B - Math.Sqrt (Discriminant)) / A, Object => Self'Access));
         Result.Append ((T_Value => (-B + Math.Sqrt (Discriminant)) / A, Object => Self'Access));
      end if;

      return Result;
   end Intersect;

   overriding function Normal_At (Self : Plane; World_Point : Point) return Vector is
      pragma Unreferenced (Self, World_Point);
   begin
      return Make_Vector (0, 1, 0);
   end Normal_At;

   overriding function Intersect (Self : aliased in out Plane; R : Ray) return Intersection_Vectors.Vector is
      pragma Unreferenced (Self, R);

      Result : Intersection_Vectors.Vector;
   begin
      return Result;
      --  Not implemented yet
   end Intersect;
end Radatracer.Objects2;
