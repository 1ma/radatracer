with Ada.Containers.Vectors;

package Radatracer.Objects is
   type Sphere is record
      Origin : Tuple := Make_Point (0, 0, 0);
   end record;

   type Intersection is record
      T_Value : Value;
      Object : Sphere;
   end record;

   package Intersection_Vectors is new Ada.Containers.Vectors (
      Index_Type => Natural,
      Element_Type => Intersection
   );

   function Hit (Intersections : Intersection_Vectors.Vector) return Integer;

   function Intersect (S : Sphere; R : Ray) return Intersection_Vectors.Vector;
end Radatracer.Objects;
