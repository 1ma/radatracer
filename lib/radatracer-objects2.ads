with Ada.Containers.Vectors;
with Radatracer.Matrices;

--  OOP version of Radatracer.Objects to eventually replace it.

package Radatracer.Objects2 is
   type Material is record
      Color : Radatracer.Color := Make_Color (1.0, 1.0, 1.0);
      Ambient : Value := 0.1;
      Diffuse : Value := 0.9;
      Specular : Value := 0.9;
      Shininess : Value := 200.0;
   end record;

   type Object is abstract tagged record
      Inverted_Transformation : Radatracer.Matrices.Matrix4 := Radatracer.Matrices.Identity_Matrix4;
      Material : Radatracer.Objects2.Material;
   end record;

   type Object_Access is access all Object'Class;

   type Intersection is record
      T_Value : Value;
      Object : Object_Access;
   end record;

   function "<" (L, R : Intersection) return Boolean;
   --  Only < is defined because its needed for sorting Intersection_Vectors

   package Intersection_Vectors is new Ada.Containers.Vectors (
      Index_Type => Natural,
      Element_Type => Intersection
   );

   function Hit (Intersections : Intersection_Vectors.Vector) return Intersection_Vectors.Cursor;

   procedure Set_Transformation (Self : in out Object; Transformation : Radatracer.Matrices.Matrix4);

   function Normal_At (Self : Object; World_Point : Point) return Vector is abstract
      with Post'Class => Magnitude (Normal_At'Result) = 1.0;

   function Intersect (Self : aliased in out Object; R : Ray) return Intersection_Vectors.Vector is abstract;

   function Reflect (V, Normal : Vector) return Vector;

   type Point_Light is record
      Intensity : Color := Make_Color (1.0, 1.0, 1.0);
      Position : Point := Make_Point (0, 0, 0);
   end record;

   function Lightning (
      Material : Radatracer.Objects2.Material;
      Light : Point_Light;
      Position : Point;
      Eye_Vector : Vector;
      Normal_Vector : Vector;
      In_Shadow : Boolean := False
   ) return Color;

   type Sphere is new Object with null record;

   overriding function Normal_At (Self : Sphere; World_Point : Point) return Vector;

   overriding function Intersect (Self : aliased in out Sphere; R : Ray) return Intersection_Vectors.Vector;

   type Plane is new Object with null record;

   overriding function Normal_At (Self : Plane; World_Point : Point) return Vector;

   overriding function Intersect (Self : aliased in out Plane; R : Ray) return Intersection_Vectors.Vector;

   package Object_Vectors is new Ada.Containers.Vectors (
      Index_Type => Natural,
      Element_Type => Object_Access
   );

   type World is record
      Light : Point_Light;
      Objects : Object_Vectors.Vector;
   end record;
end Radatracer.Objects2;
