with Ada.Containers.Vectors;
with Radatracer.Matrices;

package Radatracer.Objects is
   type Sphere is record
      Inverted_Transformation : Radatracer.Matrices.Matrix4 := Radatracer.Matrices.Identity_Matrix4;
   end record;

   procedure Set_Transformation (S : in out Sphere; Transformation : Radatracer.Matrices.Matrix4);

   type Intersection is record
      T_Value : Value;
      Object : Sphere;
   end record;

   function "<" (L, R : Intersection) return Boolean;
   --  Only < is defined because its needed for sorting Intersection_Vectors

   package Intersection_Vectors is new Ada.Containers.Vectors (
      Index_Type => Natural,
      Element_Type => Intersection
   );

   function Hit (Intersections : Intersection_Vectors.Vector) return Intersection_Vectors.Cursor;
   --  A Cursor may be No_Element, meaning the function didn't find a hit.
   --  This is how Vector.Find is designed in the Ada.Containers.Vector package.

   function Intersect (S : Sphere; R : Ray) return Intersection_Vectors.Vector;
end Radatracer.Objects;
