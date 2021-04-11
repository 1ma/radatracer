package Radatracer.Rays is
   pragma Pure;

   type Ray is record
      Origin : Tuple;
      Direction : Tuple;
   end record;

   type Sphere is record
      Origin : Tuple := Make_Point (0, 0, 0);
   end record;

   type Value_Array is array (Natural range <>) of Value;

   function Position (R : Ray; T : Value) return Tuple;

   function Intersect (S : Sphere; R : Ray) return Value_Array;
end Radatracer.Rays;
