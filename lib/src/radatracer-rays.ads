with Ada.Containers.Vectors;

package Radatracer.Rays is
   package Value_Vectors is new Ada.Containers.Vectors (
      Index_Type => Natural,
      Element_Type => Value
   );

   type Ray is record
      Origin : Tuple;
      Direction : Tuple;
   end record;

   type Sphere is record
      Origin : Tuple;
   end record;

   function Position (R : Ray; T : Value) return Tuple;

   function Intersect (S : Sphere; R : Ray) return Value_Vectors.Vector;
end Radatracer.Rays;
