with Ada.Containers.Vectors;
with Radatracer.Matrices;

package Radatracer.Objects is
   type Point_Light is record
      Intensity : Color := Make_Color (1.0, 1.0, 1.0);
      Position : Point := Make_Point (0, 0, 0);
   end record;

   type Material is record
      Color : Radatracer.Color := Make_Color (1.0, 1.0, 1.0);
      Ambient : Value := 0.1;
      Diffuse : Value := 0.9;
      Specular : Value := 0.9;
      Shininess : Value := 200.0;
   end record;

   type Sphere is record
      Inverted_Transformation : Radatracer.Matrices.Matrix4 := Radatracer.Matrices.Identity_Matrix4;
      Material : Radatracer.Objects.Material;
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

   function Normal_At (S : Sphere; World_Point : Point) return Vector
      with Post => Magnitude (Normal_At'Result) = 1.0;

   function Reflect (V, Normal : Vector) return Vector;

   function Lightning (M : Material; PL : Point_Light; Position : Point; Eye_Vector : Vector; Normal_Vector : Vector) return Color;

   package Sphere_Vectors is new Ada.Containers.Vectors (
      Index_Type => Natural,
      Element_Type => Sphere
   );

   type World is record
      Light : Point_Light;
      Objects : Sphere_Vectors.Vector;
   end record;

   function Intersect (W : World; R : Ray) return Intersection_Vectors.Vector;
end Radatracer.Objects;
