with Ada.Numerics.Generic_Elementary_Functions;

package body Radatracer.Objects is
   function "<" (L, R : Intersection) return Boolean is
   begin
      return L.T_Value < R.T_Value;
   end "<";

   procedure Set_Transformation (Self : in out Object; Transformation : Radatracer.Matrices.Matrix4) is
   begin
      Self.Inverted_Transformation := Radatracer.Matrices.Invert (Transformation);
   end Set_Transformation;

   function Normal_At (Self : Object'Class; World_Point : Point) return Vector is
      use type Radatracer.Matrices.Matrix4;

      Local_Point : constant Point := Self.Inverted_Transformation * World_Point;
      Local_Normal : constant Vector := Self.Local_Normal_At (Local_Point);
      World_Normal : Tuple := Radatracer.Matrices.Transpose (Self.Inverted_Transformation) * Local_Normal;
   begin
      World_Normal.W := 0.0;

      return Normalize (Vector (World_Normal));
   end Normal_At;

   function Intersect (Self : in out Object'Class; Ray : Radatracer.Ray) return Intersections.Set is
      Local_Ray : constant Radatracer.Ray := Radatracer.Matrices.Transform (Ray, Self.Inverted_Transformation);
   begin
      return Self.Local_Intersect (Local_Ray);
   end Intersect;

   function Pattern_At_Object (
      Pattern : Radatracer.Objects.Pattern'Class;
      Object : Radatracer.Objects.Object'Class;
      World_Point : Point
   ) return Color is
      use type Radatracer.Matrices.Matrix4;

      Object_Point : constant Point := Object.Inverted_Transformation * World_Point;
      Pattern_Point : constant Point := Pattern.Inverted_Transformation * Object_Point;
   begin
      return Pattern_At (Pattern, Pattern_Point);
   end Pattern_At_Object;

   function Hit (XS : Intersections.Set) return Intersections.Cursor is
   begin
      for Cursor in XS.Iterate loop
         if XS (Cursor).T_Value >= 0.0 then
            return Cursor;
         end if;
      end loop;

      return Intersections.No_Element;
   end Hit;

   function Reflect (V, Normal : Vector) return Vector is
   begin
      return V - Normal * 2.0 * Dot_Product (V, Normal);
   end Reflect;

   function Lightning (
      Material : Radatracer.Objects.Material;
      Object : Radatracer.Objects.Object'Class;
      Light : Point_Light;
      Position : Point;
      Eye_Vector : Vector;
      Normal_Vector : Vector;
      In_Shadow : Boolean := False
   ) return Color is
      Base_Color : constant Color := (if Material.Has_Pattern
         then Pattern_At_Object (Material.Pattern.all, Object, Position)
         else Material.Color
      );
      Effective_Color : constant Color := Base_Color * Light.Intensity;
      Ambient : constant Color := Effective_Color * Material.Ambient;
   begin
      if In_Shadow then
         return Ambient;
      end if;

      declare
         Light_Vector : constant Vector := Normalize (Light.Position - Position);
         Light_Dot_Normal : constant Value := Dot_Product (Light_Vector, Normal_Vector);
      begin
         if Light_Dot_Normal < 0.0 then
            return Ambient;
         end if;

         declare
            Reflect_Vector : constant Vector := Reflect (-Light_Vector, Normal_Vector);
            Reflect_Dot_Eye : constant Value := Dot_Product (Reflect_Vector, Eye_Vector);

            Diffuse : constant Color := Effective_Color * Material.Diffuse * Light_Dot_Normal;
         begin
            if Reflect_Dot_Eye <= 0.0 then
               return Ambient + Diffuse;
            end if;

            declare
               package Math is new Ada.Numerics.Generic_Elementary_Functions (Value);
               use Math;

               Specular : constant Color := Light.Intensity * Material.Specular * (Reflect_Dot_Eye ** Material.Shininess);
            begin
               return Ambient + Diffuse + Specular;
            end;
         end;
      end;
   end Lightning;

   function Is_Shadowed (W : World; P : Point) return Boolean is
      use type Intersections.Cursor;

      Shadow_Vector : constant Vector := W.Light.Position - P;
      Shadow_Ray : constant Ray := (P, Normalize (Shadow_Vector));
      Distance : constant Value := Magnitude (Shadow_Vector);
      XS : constant Intersections.Set := Intersect (W, Shadow_Ray);
      Hit : constant Intersections.Cursor := Radatracer.Objects.Hit (XS);
   begin
      return Hit /= Intersections.No_Element and then XS (Hit).T_Value < Distance;
   end Is_Shadowed;

   function Intersect (W : World; R : Ray) return Intersections.Set is
      XS : Intersections.Set;
   begin
      for Cursor in W.Objects.Iterate loop
         XS.Union (W.Objects (Cursor).all.Intersect (R));
      end loop;

      return XS;
   end Intersect;

   function Prepare_Calculations (
      Ray : Radatracer.Ray;
      XS : Intersections.Set;
      Hit_Index : Intersections.Cursor
   ) return Precomputed_Intersection_Info is
      use type Intersections.Cursor;
      use type Object_Vectors.Cursor;

      Hit : constant Intersection := XS (Hit_Index);
      Eye_Vector : constant Vector := -Ray.Direction;
      Intersection_Point : constant Point := Position (Ray, Hit.T_Value);
      Normal_Vector : Vector := Hit.Object.all.Normal_At (Intersection_Point);
      Inside_Hit : constant Boolean := Dot_Product (Normal_Vector, Eye_Vector) < 0.0;

      N_1, N_2 : Value;
      Containers : Object_Vectors.Vector := Object_Vectors.Empty_Vector;
   begin
      for I in XS.Iterate loop
         if I = Hit_Index then
            N_1 := (if Containers.Is_Empty
               then 1.0
               else Containers (Containers.Last).all.Material.Refractive_Index);
         end if;

         declare
            Seen_Object : Object_Vectors.Cursor := Containers.Find (XS (I).Object);
         begin
            if Seen_Object /= Object_Vectors.No_Element then
               Containers.Delete (Seen_Object);
            else
               Containers.Append (XS (I).Object);
            end if;
         end;

         if I = Hit_Index then
            N_2 := (if Containers.Is_Empty
               then 1.0
               else Containers (Containers.Last).all.Material.Refractive_Index
            );

            exit;
         end if;
      end loop;

      if Inside_Hit then
         Normal_Vector := -Normal_Vector;
      end if;

      return (
         T_Value => Hit.T_Value,
         N_1 => N_1,
         N_2 => N_2,
         Object => Hit.Object,
         Point => Intersection_Point,
         Over_Point => Intersection_Point + Normal_Vector * Epsilon,
         Under_Point => Intersection_Point - Normal_Vector * Epsilon,
         Eye_Vector => Eye_Vector,
         Normal_Vector => Normal_Vector,
         Reflect_Vector => Reflect (Ray.Direction, Normal_Vector),
         Inside_Hit => Inside_Hit
      );
   end Prepare_Calculations;

   function Reflected_Color (W : World; PII : Precomputed_Intersection_Info; Remaining : Natural := Default_Max_Recursion) return Color is
   begin
      if PII.Object.Material.Reflective = 0.0 or Remaining = 0 then
         return Black;
      end if;

      declare
         Reflected_Ray : constant Ray := (PII.Over_Point, PII.Reflect_Vector);
      begin
         return Color_At (W, Reflected_Ray, Remaining - 1) * PII.Object.Material.Reflective;
      end;
   end Reflected_Color;

   function Refracted_Color (W : World; PII : Precomputed_Intersection_Info; Remaining : Natural := Default_Max_Recursion) return Color is
   begin
      if PII.Object.Material.Transparency = 0.0 or Remaining = 0 then
         return Black;
      end if;

      declare
         N_Ratio : constant Value := PII.N_1 / PII.N_2;
         Cos_I : constant Value := Dot_Product (PII.Eye_Vector, PII.Normal_Vector);
         Sin2_T : constant Value := (N_Ratio * N_Ratio) * (1.0 - (Cos_I * Cos_I));
      begin
         if Sin2_T > 1.0 then
            return Black;
         end if;

         declare
            package Math is new Ada.Numerics.Generic_Elementary_Functions (Value);

            Cos_T : constant Value := Math.Sqrt (1.0 - Sin2_T);
            Direction : constant Vector := (PII.Normal_Vector * (N_Ratio * Cos_I - Cos_T)) - (PII.Eye_Vector * N_Ratio);
            Refract_Ray : constant Ray := (PII.Under_Point, Direction);
         begin
            return Color_At (W, Refract_Ray, Remaining - 1) * PII.Object.Material.Transparency;
         end;
      end;
   end Refracted_Color;

   function Shade_Hit (W : World; I : Precomputed_Intersection_Info; Remaining : Natural := Default_Max_Recursion) return Color is
      Surface_Color : constant Color := Lightning (
         Material => I.Object.Material,
         Object => I.Object.all,
         Light => W.Light,
         Position => I.Over_Point,
         Eye_Vector => I.Eye_Vector,
         Normal_Vector => I.Normal_Vector,
         In_Shadow => Is_Shadowed (W, I.Over_Point)
      );

      Reflected_Color : constant Color := Radatracer.Objects.Reflected_Color (W, I, Remaining);
      Refracted_Color : constant Color := Radatracer.Objects.Refracted_Color (W, I, Remaining);
   begin
      return Surface_Color + Reflected_Color + Refracted_Color;
   end Shade_Hit;

   function Color_At (W : World; R : Ray; Remaining : Natural := Default_Max_Recursion) return Color is
      use type Intersections.Cursor;

      XS : constant Intersections.Set := Intersect (W, R);
      Hit_Index : constant Intersections.Cursor := Hit (XS);
   begin
      if Hit_Index = Intersections.No_Element then
         return Black;
      end if;

      return Shade_Hit (W, Prepare_Calculations (R, XS, Hit_Index), Remaining);
   end Color_At;

   function Make_Camera (
      H_Size, V_Size : Positive;
      FOV : Value;
      From : Point := Origin;
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

      Origin : constant Point := C.Inverted_Transformation * Radatracer.Origin;
      Direction : constant Vector := Normalize (Pixel - Origin);
   begin
      return (Origin, Direction);
   end Ray_For_Pixel;

   function Render (C : Camera; W : World) return Radatracer.Images.Canvas is
      Canvas : Radatracer.Images.Canvas (0 .. C.H_Size - 1, 0 .. C.V_Size - 1);
   begin
      for Y in Canvas'Range (2) loop
         for X in Canvas'Range (1) loop
            Canvas (X, Y) := Radatracer.Images.To_Pixel (Color_At (W, Ray_For_Pixel (C, X, Y)));
         end loop;
      end loop;

      return Canvas;
   end Render;
end Radatracer.Objects;
