package Radatracer.Objects is
   type Object is tagged null record;
   type Object_Access is access constant Object'Class;

   type Intersection is record
      T_Value : Value;
      Object : Object_Access;
   end record;

   type Intersection_Array is array (Natural range <>) of Intersection;

   function Hit (IA : Intersection_Array) return Integer;

   type Sphere is new Object with record
      Origin : Tuple := Make_Point (0, 0, 0);
   end record;

   --  Not part of the project, added to aid experimentation
   --  Delete after completing Chapter 5
   type Square is new Objects.Object with record
      Lower_Left_Corner : Tuple := Make_Point (0, 0, 0);
      Side_Length : Value := 1.0;
   end record;

   function Intersect (S : aliased Sphere; R : Ray) return Intersection_Array;
end Radatracer.Objects;
