with Ada.Containers.Vectors;
with Radatracer.Matrices;

package Radatracer.Objects is
   type Point_Light is record
      Intensity : Tuple;
      Position : Tuple;
   end record
      with Dynamic_Predicate => Is_Point (Position);

   type Material is record
      Color : Tuple := (1.0, 1.0, 1.0, 0.0);
      Ambient : Value := 0.1;
      Diffuse : Value := 0.9;
      Specular : Value := 0.9;
      Shininess : Value := 200.0;
   end record;

   type Sphere is record
      Inverted_Transformation : Radatracer.Matrices.Matrix4 := Radatracer.Matrices.Identity_Matrix4;
      M : Material;
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

   function Normal_At (S : Sphere; World_Point : Tuple) return Tuple
      with Pre => Is_Point (World_Point),
           Post => Is_Vector (Normal_At'Result) and Magnitude (Normal_At'Result) = 1.0;

   function Reflect (V, Normal : Tuple) return Tuple
      with Pre =>  Is_Vector (V) and Is_Vector (Normal),
           Post => Is_Vector (Reflect'Result);

   function Lightning (M : Material; PL : Point_Light; Position : Tuple; Eye_Vector : Tuple; Normal_Vector : Tuple) return Tuple;
end Radatracer.Objects;
