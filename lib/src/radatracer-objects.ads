with Ada.Containers.Vectors;

package Radatracer.Objects is
   type Sphere is record
      Origin : Tuple := Make_Point (0, 0, 0);
   end record;

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
