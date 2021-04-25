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

   procedure Set_Transformation (Self : in out Object; Transformation : Radatracer.Matrices.Matrix4);

   function Normal_At (Self : Object; World_Point : Point) return Vector is abstract
      with Post'Class => Magnitude (Normal_At'Result) = 1.0;

   type Object_Access is access Object'Class;

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

   type Sphere is new Object with null record;

   overriding function Normal_At (Self : Sphere; World_Point : Point) return Vector;

   type Plane is new Object with null record;

   overriding function Normal_At (Self : Plane; World_Point : Point) return Vector;
end Radatracer.Objects2;
