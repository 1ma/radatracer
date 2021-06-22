with Ada.Containers.Vectors;
with Ada.Numerics;
with Radatracer.Canvas;
with Radatracer.Matrices;

package Radatracer.Objects is
   type Pattern is abstract tagged record
      Inverted_Transformation : Radatracer.Matrices.Matrix4 := Radatracer.Matrices.Identity_Matrix4;
   end record;

   type Pattern_Access is access all Pattern'Class;

   function Pattern_At (Self : Pattern; Point : Radatracer.Point) return Color is abstract;

   type Material (Has_Pattern : Boolean := False) is record
      Ambient : Value := 0.1;
      Diffuse : Value := 0.9;
      Specular : Value := 0.9;
      Shininess : Value := 200.0;
      Reflective : Value range 0.0 .. 1.0 := 0.0;

      case Has_Pattern is
         when True =>
            Pattern : Pattern_Access;
         when False =>
            Color : Radatracer.Color := White;
      end case;
   end record;

   type Object is abstract tagged record
      Inverted_Transformation : Radatracer.Matrices.Matrix4 := Radatracer.Matrices.Identity_Matrix4;
      Material : Radatracer.Objects.Material;
   end record;

   type Object_Access is access all Object'Class;

   function Pattern_At_Object (
      Pattern : Radatracer.Objects.Pattern'Class;
      Object : Radatracer.Objects.Object'Class;
      World_Point : Point
   ) return Color;

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

   function Normal_At (Self : Object'Class; World_Point : Point) return Vector
      with Post => Magnitude (Normal_At'Result) = 1.0;

   function Local_Normal_At (Self : Object; Local_Point : Point) return Vector is abstract;

   function Intersect (Self : in out Object'Class; Ray : Radatracer.Ray) return Intersection_Vectors.Vector;

   function Local_Intersect (Self : aliased in out Object; Local_Ray : Radatracer.Ray) return Intersection_Vectors.Vector is abstract;

   function Reflect (V, Normal : Vector) return Vector;

   type Point_Light is record
      Intensity : Color := Make_Color (1.0, 1.0, 1.0);
      Position : Point := Make_Point (0, 0, 0);
   end record;

   function Lightning (
      Material : Radatracer.Objects.Material;
      Object : Radatracer.Objects.Object'Class;
      Light : Point_Light;
      Position : Point;
      Eye_Vector : Vector;
      Normal_Vector : Vector;
      In_Shadow : Boolean := False
   ) return Color;

   package Object_Vectors is new Ada.Containers.Vectors (
      Index_Type => Natural,
      Element_Type => Object_Access
   );

   type World is record
      Light : Point_Light;
      Objects : Object_Vectors.Vector;
   end record;

   function Is_Shadowed (W : World; P : Point) return Boolean;

   function Intersect (W : World; R : Ray) return Intersection_Vectors.Vector;

   type Precomputed_Intersection_Info is record
      T_Value : Value;
      Object : Object_Access;
      Point : Radatracer.Point;
      Over_Point : Radatracer.Point;
      Eye_Vector : Vector;
      Normal_Vector : Vector;
      Reflect_Vector : Vector;
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

   function Make_Camera (
      H_Size, V_Size : Positive;
      FOV : Value;
      From : Point := Make_Point (0, 0, 0);
      To : Point := Make_Point (0, 0, -1);
      Up : Vector := Make_Vector (0, 1, 0)
   ) return Camera;

   function Ray_For_Pixel (C : Camera; X, Y : Natural) return Ray;

   function Render (C : Camera; W : World) return Radatracer.Canvas.Canvas;
end Radatracer.Objects;
