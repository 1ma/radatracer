package Radatracer.Objects is
   type Object is tagged null record;
   type Object_Access is access constant Object'Class;

   type Intersection is record
      T : Value;
      O : Object_Access;
   end record;

   type Intersection_Array is array (Natural range <>) of Intersection;

   function Hit (IA : Intersection_Array) return Integer;

   type Sphere is new Object with record
      Origin : Tuple := Make_Point (0, 0, 0);
   end record;

   function Intersect (S : aliased Sphere; R : Ray) return Intersection_Array;
end Radatracer.Objects;
