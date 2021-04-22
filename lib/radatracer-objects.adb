with Ada.Numerics.Generic_Elementary_Functions;

package body Radatracer.Objects is
   procedure Set_Transformation (S : in out Sphere; Transformation : Radatracer.Matrices.Matrix4) is
   begin
      S.Inverted_Transformation := Radatracer.Matrices.Invert (Transformation);
   end Set_Transformation;

   function "<" (L, R : Intersection) return Boolean is
   begin
      return L.T_Value < R.T_Value;
   end "<";

   function Hit (Intersections : Intersection_Vectors.Vector) return Intersection_Vectors.Cursor is
      package Intersection_Vector_Sorting is new Intersection_Vectors.Generic_Sorting;

      Sorted_Intersections : Intersection_Vectors.Vector := Intersections;
   begin
      Intersection_Vector_Sorting.Sort (Sorted_Intersections);

      for Cursor in Sorted_Intersections.Iterate loop
         if Sorted_Intersections (Cursor).T_Value >= 0.0 then
            return Intersections.Find (Sorted_Intersections (Cursor));
         end if;
      end loop;

      return Intersection_Vectors.No_Element;
   end Hit;

   function Intersect (S : Sphere; R : Ray) return Intersection_Vectors.Vector is
      package Math is new Ada.Numerics.Generic_Elementary_Functions (Value);
      Result : Intersection_Vectors.Vector;

      Sphere_Origin : constant Point := Make_Point (0, 0, 0);

      Transformed_Ray : constant Ray := Radatracer.Matrices.Transform (R, S.Inverted_Transformation);

      Sphere_Ray_Vector : constant Vector := Transformed_Ray.Origin - Sphere_Origin;
      A : constant Value := 2.0 * Dot_Product (Transformed_Ray.Direction, Transformed_Ray.Direction);
      B : constant Value := 2.0 * Dot_Product (Transformed_Ray.Direction, Sphere_Ray_Vector);
      C : constant Value := Dot_Product (Sphere_Ray_Vector, Sphere_Ray_Vector) - 1.0;
      Discriminant : constant Value := (B * B) - (2.0 * A * C);
   begin
      if Discriminant >= 0.0 then
         Result.Append ((T_Value => (-B - Math.Sqrt (Discriminant)) / A, Object => S));
         Result.Append ((T_Value => (-B + Math.Sqrt (Discriminant)) / A, Object => S));
      end if;

      return Result;
   end Intersect;

   function Normal_At (S : Sphere; World_Point : Point) return Vector is
      use type Radatracer.Matrices.Matrix4;

      Object_Origin : constant Point := Make_Point (0, 0, 0);
      Object_Point : constant Point := S.Inverted_Transformation * World_Point;
      Object_Normal : constant Vector := Object_Point - Object_Origin;
      World_Normal : Tuple := Radatracer.Matrices.Transpose (S.Inverted_Transformation) * Object_Normal;
   begin
      World_Normal.W := 0.0;
      return Normalize (Vector (World_Normal));
   end Normal_At;

   function Reflect (V, Normal : Vector) return Vector is
   begin
      return V - Normal * 2.0 * Dot_Product (V, Normal);
   end Reflect;

   function Lightning (
      Material : Radatracer.Objects.Material;
      Light : Point_Light;
      Position : Point;
      Eye_Vector : Vector;
      Normal_Vector : Vector;
      In_Shadow : Boolean := False
   ) return Color is
      Light_Vector : constant Vector := Normalize (Light.Position - Position);
      Light_Dot_Normal : constant Value := Dot_Product (Light_Vector, Normal_Vector);

      Effective_Color : constant Color := Material.Color * Light.Intensity;
      Ambient : constant Color := Effective_Color * Material.Ambient;
   begin
      if Light_Dot_Normal < 0.0 or In_Shadow then
         return Ambient;
      end if;

      declare
         Reflect_Vector : constant Vector := Reflect (-Light_Vector, Normal_Vector);
         Reflect_Dot_Eye : constant Value := Dot_Product (Reflect_Vector, Eye_Vector);

         Diffuse : constant Color := Effective_Color * Material.Diffuse * Light_Dot_Normal;
         Specular : Color := Make_Color (0.0, 0.0, 0.0);
      begin
         if Reflect_Dot_Eye > 0.0 then
            Specular := Light.Intensity * Material.Specular * (Reflect_Dot_Eye ** Natural (Material.Shininess));
         end if;

         return Ambient + Diffuse + Specular;
      end;
   end Lightning;

   function Is_Shadowed (W : World; P : Point) return Boolean is
      use type Intersection_Vectors.Cursor;

      Shadow_Vector : constant Vector := W.Light.Position - P;
      Shadow_Ray : constant Ray := (P, Normalize (Shadow_Vector));
      Distance : constant Value := Magnitude (Shadow_Vector);
      Intersections : constant Intersection_Vectors.Vector := Intersect (W, Shadow_Ray);
      Hit : constant Intersection_Vectors.Cursor := Radatracer.Objects.Hit (Intersections);
   begin
      return Hit /= Intersection_Vectors.No_Element and then Intersections (Hit).T_Value < Distance;
   end Is_Shadowed;

   function Intersect (W : World; R : Ray) return Intersection_Vectors.Vector is
      package Intersection_Vector_Sorting is new Intersection_Vectors.Generic_Sorting;

      Intersections : Intersection_Vectors.Vector;
   begin
      for Cursor in W.Objects.Iterate loop
         Intersections.Append (Intersect (W.Objects (Cursor), R));
      end loop;

      Intersection_Vector_Sorting.Sort (Intersections);

      return Intersections;
   end Intersect;

   function Prepare_Calculations (I : Intersection; R : Ray) return Precomputed_Intersection_Info is
      P : constant Point := Position (R, I.T_Value);
      Eye_Vector : constant Vector := -R.Direction;
      Normal_Vector : Vector := Normal_At (I.Object, P);

      Inside_Hit : constant Boolean := Dot_Product (Normal_Vector, Eye_Vector) < 0.0;
   begin
      if Inside_Hit then
         Normal_Vector := -Normal_Vector;
      end if;

      return (
         T_Value => I.T_Value,
         Object => I.Object,
         Point => P,
         Eye_Vector => Eye_Vector,
         Normal_Vector => Normal_Vector,
         Inside_Hit => Inside_Hit
      );
   end Prepare_Calculations;

   function Shade_Hit (W : World; I : Precomputed_Intersection_Info) return Color is
   begin
      return Lightning (
         Material => I.Object.Material,
         Light => W.Light,
         Position => I.Point,
         Eye_Vector => I.Eye_Vector,
         Normal_Vector => I.Normal_Vector
      );
   end Shade_Hit;

   function Color_At (W : World; R : Ray) return Color is
      use type Intersection_Vectors.Cursor;

      Intersections : constant Intersection_Vectors.Vector := Intersect (W, R);
      Hit : constant Intersection_Vectors.Cursor := Radatracer.Objects.Hit (Intersections);
   begin
      if Hit = Intersection_Vectors.No_Element then
         return Make_Color (0.0, 0.0, 0.0);
      end if;

      return Shade_Hit (W, Prepare_Calculations (Intersections (Hit), R));
   end Color_At;

   function Make_Camera (
      H_Size, V_Size : Positive;
      FOV : Value;
      From : Point := Make_Point (0, 0, 0);
      To : Point := Make_Point (0, 0, -1);
      Up : Vector := Make_Vector (0, 1, 0)
   ) return Camera is
      package Math is new Ada.Numerics.Generic_Elementary_Functions (Value);

      Half_View : constant Value := Math.Tan (FOV / 2.0);
      Aspect : constant Value := Value (H_Size) / Value (V_Size);

      Camera : Radatracer.Objects.Camera := (
         H_Size => H_Size,
         V_Size => V_Size,
         FOV =>  FOV,
         Inverted_Transformation => Radatracer.Matrices.Invert (
            Radatracer.Matrices.View_Transform (From, To, Up)
         ),
         others => <>
      );
   begin
      if Aspect < 1.0 then
         Camera.Half_Height := Half_View;
         Camera.Half_Width := Half_View * Aspect;
      else
         Camera.Half_Height := Half_View / Aspect;
         Camera.Half_Width := Half_View;
      end if;

      Camera.Pixel_Size := (Camera.Half_Width * 2.0) / Value (Camera.H_Size);

      return Camera;
   end Make_Camera;

   function Ray_For_Pixel (C : Camera; X, Y : Natural) return Ray is
      use type Radatracer.Matrices.Matrix4;

      X_Offset : constant Value := (Value (X) + 0.5) * C.Pixel_Size;
      Y_Offset : constant Value := (Value (Y) + 0.5) * C.Pixel_Size;

      World_X : constant Value := C.Half_Width - X_Offset;
      World_Y : constant Value := C.Half_Height - Y_Offset;

      Pixel : constant Point := C.Inverted_Transformation * Make_Point (World_X, World_Y, -1.0);

      Origin : constant Point := C.Inverted_Transformation * Make_Point (0, 0, 0);
      Direction : constant Vector := Normalize (Pixel - Origin);
   begin
      return (Origin, Direction);
   end Ray_For_Pixel;

   function Render (C : Camera; W : World) return Radatracer.Canvas.Canvas is
      Canvas : Radatracer.Canvas.Canvas (0 .. C.H_Size - 1, 0 .. C.V_Size - 1);
   begin
      for Y in Canvas'Range (2) loop
         for X in Canvas'Range (1) loop
            Canvas (X, Y) := Radatracer.Canvas.To_Pixel (Color_At (W, Ray_For_Pixel (C, X, Y)));
         end loop;
      end loop;

      return Canvas;
   end Render;
end Radatracer.Objects;
