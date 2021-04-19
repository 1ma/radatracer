with Ada.Containers.Vectors;
with Ada.Numerics;
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

   type Precomputed_Intersection_Info is record
      T_Value : Value;
      Object : Radatracer.Objects.Sphere;
      Point : Radatracer.Point;
      Eye_Vector : Vector;
      Normal_Vector : Vector;
      Inside_Hit : Boolean;
   end record;
   --  This data structure reeks of implementation detail. I'll leave it in the
   --  package specification for now, until I see how it is used.

   function Prepare_Calculations (I : Intersection; R : Ray) return Precomputed_Intersection_Info;
   --  Ditto.

   function Shade_Hit (W : World; I : Precomputed_Intersection_Info) return Color;

   function Color_At (W : World; R : Ray) return Color;

   type Camera is record
      H_Size, V_Size : Positive;
      FOV : Value range 0.0 .. Ada.Numerics.Pi := Ada.Numerics.Pi / 2.0;
      Inverted_Transformation : Radatracer.Matrices.Matrix4 := Radatracer.Matrices.Identity_Matrix4;
      Half_Width, Half_Height, Pixel_Size : Value;
   end record;

   function Make_Camera (H_Size, V_Size : Positive; FOV : Value) return Camera;
   procedure Set_Transformation (C : in out Camera; T : Radatracer.Matrices.Matrix4);

   function Ray_For_Pixel (C : Camera; X, Y : Natural) return Ray;
end Radatracer.Objects;
