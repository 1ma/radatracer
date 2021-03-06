with Ada.Numerics;
with AUnit.Assertions;
with Radatracer.Matrices;
with Radatracer.Objects.Patterns;
with Radatracer.Objects.Planes;
with Radatracer.Objects.Spheres;

package body Radatracer.Objects.Tests is
   use Radatracer.Objects.Planes;
   use Radatracer.Objects.Spheres;

   type Test_Object is new Object with record
      Saved_Ray : Ray;
   end record;

   overriding function Local_Normal_At (Self : Test_Object; Local_Point : Point) return Vector;
   overriding function Local_Intersect (Self : aliased in out Test_Object; Local_Ray : Radatracer.Ray) return Intersections.Set;

   overriding function Local_Normal_At (Self : Test_Object; Local_Point : Point) return Vector is
      pragma Unreferenced (Self);
   begin
      return Make_Vector (Local_Point.X, Local_Point.Y, Local_Point.Z);
   end Local_Normal_At;

   overriding function Local_Intersect (Self : aliased in out Test_Object; Local_Ray : Radatracer.Ray) return Intersections.Set is
      Result : Intersections.Set;
   begin
      Self.Saved_Ray := Local_Ray;

      return Result;
   end Local_Intersect;

   function Default_World return World;
   function Default_World return World is
      Outer_Sphere : constant Object_Access := new Sphere'(
         Inverted_Transformation => <>,
         Material => (
            Color => Make_Color (0.8, 1.0, 0.6),
            Diffuse => 0.7,
            Specular => 0.2,
            others => <>
         )
      );

      Inner_Sphere : constant Object_Access := new Sphere'(
         Inverted_Transformation => Radatracer.Matrices.Invert (Radatracer.Matrices.Scaling (0.5, 0.5, 0.5)),
         Material => <>
      );

      World : Radatracer.Objects.World := (
         Light => (Position => Make_Point (-10, 10, -10), Intensity => <>),
         Objects => <>
      );
   begin
      World.Objects.Append (Outer_Sphere);
      World.Objects.Append (Inner_Sphere);

      return World;
   end Default_World;

   procedure Test_Intersection_Hits (T : in out AUnit.Test_Cases.Test_Case'Class);
   procedure Test_Intersection_Hits (T : in out AUnit.Test_Cases.Test_Case'Class) is
      pragma Unreferenced (T);

      use type Intersections.Cursor;
      use type Intersections.Set;

      S : constant Object_Access := new Sphere'(Inverted_Transformation => <>, others => <>);

      I1_1 : constant Intersection := (1.0, S);
      I1_2 : constant Intersection := (2.0, S);
      V1 : constant Intersections.Set := Intersections.To_Set (I1_1) or Intersections.To_Set (I1_2);

      I2_1 : constant Intersection := (-1.0, S);
      I2_2 : constant Intersection := (1.0, S);
      V2 : constant Intersections.Set := Intersections.To_Set (I2_1) or Intersections.To_Set (I2_2);

      I3_1 : constant Intersection := (-2.0, S);
      I3_2 : constant Intersection := (-1.0, S);
      V3 : constant Intersections.Set := Intersections.To_Set (I3_1) or Intersections.To_Set (I3_2);

      I4_1 : constant Intersection := (5.0, S);
      I4_2 : constant Intersection := (7.0, S);
      I4_3 : constant Intersection := (-3.0, S);
      I4_4 : constant Intersection := (2.0, S);
      V4 : constant Intersections.Set :=
         Intersections.To_Set (I4_1) or
         Intersections.To_Set (I4_2) or
         Intersections.To_Set (I4_3) or
         Intersections.To_Set (I4_4);
   begin
      AUnit.Assertions.Assert (V1 (Hit (V1)) = I1_1, "Ray-Sphere hit test 1 - sorted positive T_Values");
      AUnit.Assertions.Assert (V2 (Hit (V2)) = I2_2, "Ray-Sphere hit test 2 - sorted positive and negative T_Values");
      AUnit.Assertions.Assert (Hit (V3) = Intersections.No_Element, "Ray-Sphere hit test 3 - only negative T_Values");
      AUnit.Assertions.Assert (V4 (Hit (V4)) = I4_4, "Ray-Sphere hit test 3 - unsorted positive and negative T_Values");
   end Test_Intersection_Hits;

   procedure Test_Reflections (T : in out AUnit.Test_Cases.Test_Case'Class);
   procedure Test_Reflections (T : in out AUnit.Test_Cases.Test_Case'Class) is
      pragma Unreferenced (T);
   begin
      AUnit.Assertions.Assert (Reflect (Make_Vector (1, -1, 0), Make_Vector (0, 1, 0)) = Make_Vector (1, 1, 0), "Reflection test 1");
      AUnit.Assertions.Assert (Reflect (Make_Vector (0, -1, 0), Make_Vector (0.70711, 0.70711, 0.0)) = Make_Vector (1, 0, 0), "Reflection test 2");
   end Test_Reflections;

   procedure Test_Lightning (T : in out AUnit.Test_Cases.Test_Case'Class);
   procedure Test_Lightning (T : in out AUnit.Test_Cases.Test_Case'Class) is
      pragma Unreferenced (T);

      Object : Test_Object;

      Material : constant Radatracer.Objects.Material := (others => <>);
      Position : constant Point := Origin;

      Eye_Vector_1 : constant Vector := Make_Vector (0, 0, -1);
      Normal_Vector_1 : constant Vector := Make_Vector (0, 0, -1);
      Light_1 : constant Point_Light := (Intensity => White, Position => Make_Point (0, 0, -10));

      Eye_Vector_2 : constant Vector := Make_Vector (0.0, 0.70711, -0.70711);
      Normal_Vector_2 : constant Vector := Make_Vector (0, 0, -1);
      Light_2 : constant Point_Light := (Intensity => White, Position => Make_Point (0, 0, -10));

      Eye_Vector_3 : constant Vector := Make_Vector (0, 0, -1);
      Normal_Vector_3 : constant Vector := Make_Vector (0, 0, -1);
      Light_3 : constant Point_Light := (Intensity => White, Position => Make_Point (0, 10, -10));

      Eye_Vector_4 : constant Vector := Make_Vector (0.0, -0.70711, -0.70711);
      Normal_Vector_4 : constant Vector := Make_Vector (0, 0, -1);
      Light_4 : constant Point_Light := (Intensity => White, Position => Make_Point (0, 10, -10));

      Eye_Vector_5 : constant Vector := Make_Vector (0, 0, -1);
      Normal_Vector_5 : constant Vector := Make_Vector (0, 0, -1);
      Light_5 : constant Point_Light := (Intensity => White, Position => Make_Point (0, 0, 10));

      Eye_Vector_6 : constant Vector := Make_Vector (0, 0, -1);
      Normal_Vector_6 : constant Vector := Make_Vector (0, 0, -1);
      Light_6 : constant Point_Light := (Intensity => White, Position => Make_Point (0, 0, -10));

      Material_2 : constant Radatracer.Objects.Material := (
         Has_Pattern => True,
         Pattern => new Radatracer.Objects.Patterns.Stripe'(A => White, B => Black, others => <>),
         Ambient => 1.0,
         Diffuse => 0.0,
         Specular => 0.0,
         others => <>
      );
   begin
      AUnit.Assertions.Assert (
         Lightning (Material, Object, Light_1, Position, Eye_Vector_1, Normal_Vector_1) = Make_Color (1.9, 1.9, 1.9),
         "Lightning with the eye between the light and the surface"
      );

      AUnit.Assertions.Assert (
         Lightning (Material, Object, Light_2, Position, Eye_Vector_2, Normal_Vector_2) = White,
         "Lightning with the eye between light and surface, eye offset 45??"
      );

      AUnit.Assertions.Assert (
         Lightning (Material, Object, Light_3, Position, Eye_Vector_3, Normal_Vector_3) = Make_Color (0.7364, 0.7364, 0.7364),
         "Lightning with the eye opposite surface, light offset 45??"
      );

      AUnit.Assertions.Assert (
         Lightning (Material, Object, Light_4, Position, Eye_Vector_4, Normal_Vector_4) = Make_Color (1.63721, 1.63721, 1.63721),
         "Lightning with the eye in the path of the reflection vector"
      );

      AUnit.Assertions.Assert (
         Lightning (Material, Object, Light_5, Position, Eye_Vector_5, Normal_Vector_5) = Make_Color (0.1, 0.1, 0.1),
         "Lightning with the eye in the path of the reflection vector"
      );

      AUnit.Assertions.Assert (
         Lightning (Material, Object, Light_6, Position, Eye_Vector_6, Normal_Vector_6, True) = Make_Color (0.1, 0.1, 0.1),
         "Lightning with the surface in shadow"
      );

      AUnit.Assertions.Assert (
         Lightning (Material_2, Object, Light_6, Make_Point (0.9, 0.0, 0.0), Eye_Vector_6, Normal_Vector_6, True) = White,
         "Lightning with a pattern applied - part 1"
      );

      AUnit.Assertions.Assert (
         Lightning (Material_2, Object, Light_6, Make_Point (1.1, 0.0, 0.0), Eye_Vector_6, Normal_Vector_6, True) = Black,
         "Lightning with a pattern applied - part 2"
      );
   end Test_Lightning;

   procedure Test_World_Intersections (T : in out AUnit.Test_Cases.Test_Case'Class);
   procedure Test_World_Intersections (T : in out AUnit.Test_Cases.Test_Case'Class) is
      pragma Unreferenced (T);

      use type Ada.Containers.Count_Type;

      W : constant World := Default_World;
      R : constant Ray := (Origin => Make_Point (0, 0, -5), Direction => Make_Vector (0, 0, 1));

      XS : constant Intersections.Set := Intersect (W, R);
      Cursor : Intersections.Cursor := XS.First;
   begin
      AUnit.Assertions.Assert (XS.Length = 4, "World intersection test 1 - part 1");
      AUnit.Assertions.Assert (XS (Cursor).T_Value = 4.0, "World intersection test 1 - part 2");
      Cursor := Intersections.Next (Cursor);
      AUnit.Assertions.Assert (XS (Cursor).T_Value = 4.5, "World intersection test 1 - part 3");
      Cursor := Intersections.Next (Cursor);
      AUnit.Assertions.Assert (XS (Cursor).T_Value = 5.5, "World intersection test 1 - part 4");
      Cursor := Intersections.Next (Cursor);
      AUnit.Assertions.Assert (XS (Cursor).T_Value = 6.0, "World intersection test 1 - part 5");
   end Test_World_Intersections;

   procedure Test_Prepare_Calculations (T : in out AUnit.Test_Cases.Test_Case'Class);
   procedure Test_Prepare_Calculations (T : in out AUnit.Test_Cases.Test_Case'Class) is
      pragma Unreferenced (T);

      R1 : constant Ray := (Origin => Make_Point (0, 0, -5), Direction => Make_Vector (0, 0, 1));
      R2 : constant Ray := (Origin => Origin, Direction => Make_Vector (0, 0, 1));

      I1 : constant Intersection := (T_Value => 4.0, Object => new Sphere);
      I2 : constant Intersection := (T_Value => 1.0, Object => new Sphere);

      VI1 : constant Intersections.Set := Intersections.To_Set (I1);
      VI2 : constant Intersections.Set := Intersections.To_Set (I2);

      PII1 : constant Precomputed_Intersection_Info := Prepare_Calculations (R1, VI1, VI1.First);
      PII2 : constant Precomputed_Intersection_Info := Prepare_Calculations (R2, VI2, VI2.First);

      R3 : constant Ray := (Origin => Make_Point (0, 0, -5), Direction => Make_Vector (0, 0, 1));
      S1 : constant Object_Access := new Sphere'(
         Inverted_Transformation => Radatracer.Matrices.Invert (
            Radatracer.Matrices.Translation (0.0, 0.0, 1.0)
         ),
         Material => <>
      );
      I3 : constant Intersection := (T_Value => 5.0, Object => S1);
      VI3 : constant Intersections.Set := Intersections.To_Set (I3);
      PII3 : constant Precomputed_Intersection_Info := Prepare_Calculations (R3, VI3, VI3.First);
   begin
      AUnit.Assertions.Assert (PII1.T_Value = I1.T_Value, "Prepare calculations test 1 - part 1");
      AUnit.Assertions.Assert (PII1.Object = I1.Object, "Prepare calculations test 1 - part 2");
      AUnit.Assertions.Assert (PII1.Point = Make_Point (0, 0, -1), "Prepare calculations test 1 - part 3");
      AUnit.Assertions.Assert (PII1.Eye_Vector = Make_Vector (0, 0, -1), "Prepare calculations test 1 - part 4");
      AUnit.Assertions.Assert (PII1.Normal_Vector = Make_Vector (0, 0, -1), "Prepare calculations test 1 - part 5");
      AUnit.Assertions.Assert (PII1.Inside_Hit = False, "Prepare calculations test 1 - part 6");

      AUnit.Assertions.Assert (PII2.T_Value = I2.T_Value, "Prepare calculations test 2 - part 1");
      AUnit.Assertions.Assert (PII2.Object = I2.Object, "Prepare calculations test 2 - part 2");
      AUnit.Assertions.Assert (PII2.Point = Make_Point (0, 0, 1), "Prepare calculations test 2 - part 3");
      AUnit.Assertions.Assert (PII2.Eye_Vector = Make_Vector (0, 0, -1), "Prepare calculations test 2 - part 4");
      AUnit.Assertions.Assert (PII2.Normal_Vector = Make_Vector (0, 0, -1), "Prepare calculations test 2 - part 5");
      AUnit.Assertions.Assert (PII2.Inside_Hit, "Prepare calculations test 2 - part 6");

      AUnit.Assertions.Assert (PII3.Over_Point.Z < -Epsilon / 2.0, "The hit should offset the point - part 1");
      AUnit.Assertions.Assert (PII3.Over_Point.Z < PII3.Point.Z, "The hit should offset the point - part 2");
   end Test_Prepare_Calculations;

   procedure Test_Shade_Hit (T : in out AUnit.Test_Cases.Test_Case'Class);
   procedure Test_Shade_Hit (T : in out AUnit.Test_Cases.Test_Case'Class) is
      pragma Unreferenced (T);

      use type Object_Vectors.Vector;

      W : World := Default_World;
      R1 : constant Ray := (Origin => Make_Point (0, 0, -5), Direction => Make_Vector (0, 0, 1));
      I1 : constant Intersection := (T_Value => 4.0, Object => W.Objects (0));
      VI1 : constant Intersections.Set := Intersections.To_Set (I1);
      PII1 : constant Precomputed_Intersection_Info := Prepare_Calculations (R1, VI1, VI1.First);

      R2 : constant Ray := (Origin => Radatracer.Origin, Direction => Make_Vector (0, 0, 1));
      I2 : constant Intersection := (T_Value => 0.5, Object => W.Objects (1));
      VI2 : constant Intersections.Set := Intersections.To_Set (I2);
      PII2 : constant Precomputed_Intersection_Info := Prepare_Calculations (R2, VI2, VI2.First);

      S1 : constant Object_Access := new Sphere;
      S2 : constant Object_Access := new Sphere'(
         Inverted_Transformation => Radatracer.Matrices.Invert (Radatracer.Matrices.Translation (0.0, 0.0, 10.0)),
         Material => <>
      );

      W2 : constant World := (
         Light => (Position => Make_Point (0, 0, -10), Intensity => White),
         Objects => S1 & S2
      );
      R3 : constant Ray := (Origin => Make_Point (0, 0, 5), Direction => Make_Vector (0, 0, 1));
      I3 : constant Intersection := (T_Value => 4.0, Object => W2.Objects (1));
      VI3 : constant Intersections.Set := Intersections.To_Set (I3);
      Comps : constant Precomputed_Intersection_Info := Prepare_Calculations (R3, VI3, VI3.First);
   begin
      AUnit.Assertions.Assert (Shade_Hit (W, PII1) = Make_Color (0.38066, 0.47583, 0.2855), "Shading an intersection");

      W.Light := (Position => Make_Point (0.0, 0.25, 0.0), Intensity => White);

      AUnit.Assertions.Assert (Shade_Hit (W, PII2) = Make_Color (0.90498, 0.90498, 0.90498), "Shading an intersection from the inside");

      AUnit.Assertions.Assert (Shade_Hit (W2, Comps) = Make_Color (0.1, 0.1, 0.1), "Shade hit is given an intersection in a shadow");
   end Test_Shade_Hit;

   procedure Test_Color_At (T : in out AUnit.Test_Cases.Test_Case'Class);
   procedure Test_Color_At (T : in out AUnit.Test_Cases.Test_Case'Class) is
      pragma Unreferenced (T);

      W : World := Default_World;
      R1 : constant Ray := (Origin => Make_Point (0, 0, -5), Direction => Make_Vector (0, 1, 0));
      R2 : constant Ray := (Origin => Make_Point (0, 0, -5), Direction => Make_Vector (0, 0, 1));
      R3 : constant Ray := (Origin => Make_Point (0.0, 0.0, 0.75), Direction => Make_Vector (0, 0, -1));
   begin
      AUnit.Assertions.Assert (Color_At (W, R1) = Make_Color (0.0, 0.0, 0.0), "The color when a ray misses");
      AUnit.Assertions.Assert (Color_At (W, R2) = Make_Color (0.38066, 0.47583, 0.2855), "The color when a ray hits");

      W.Objects (0).Material.Ambient := 1.0;
      W.Objects (1).Material.Ambient := 1.0;

      AUnit.Assertions.Assert (Color_At (W, R3) = W.Objects (1).Material.Color, "The with an intersection behind the ray");
   end Test_Color_At;

   procedure Test_Camera (T : in out AUnit.Test_Cases.Test_Case'Class);
   procedure Test_Camera (T : in out AUnit.Test_Cases.Test_Case'Class) is
      pragma Unreferenced (T);

      use type Radatracer.Images.Pixel;
      use type Radatracer.Matrices.Matrix4;

      C1 : constant Camera := Make_Camera (160, 120, Ada.Numerics.Pi / 2.0);
      C2 : constant Camera := Make_Camera (200, 125, Ada.Numerics.Pi / 2.0);
      C3 : constant Camera := Make_Camera (125, 200, Ada.Numerics.Pi / 2.0);
      C4 : Camera := Make_Camera (201, 101, Ada.Numerics.Pi / 2.0);

      W : constant World := Default_World;
      C5 : constant Camera := Make_Camera (11, 11, Ada.Numerics.Pi / 2.0, Make_Point (0, 0, -5), Origin, Make_Vector (0, 1, 0));
   begin
      AUnit.Assertions.Assert (
         C1.H_Size = 160 and C1.V_Size = 120 and C1.FOV = Ada.Numerics.Pi / 2.0 and C1.Inverted_Transformation = Radatracer.Matrices.Identity_Matrix4,
         "Constructing a camera"
      );

      AUnit.Assertions.Assert (C2.Pixel_Size = 0.01, "The pixel size for a horizontal camera");
      AUnit.Assertions.Assert (C3.Pixel_Size = 0.01, "The pixel size for a vertical camera");

      AUnit.Assertions.Assert (
         Ray_For_Pixel (C4, 100, 50) = (Origin, Make_Vector (0, 0, -1)),
         "Constructing a ray through the center of the canvas"
      );

      AUnit.Assertions.Assert (
         Ray_For_Pixel (C4, 0, 0) = (Origin, Make_Vector (0.66519, 0.33259, -0.66851)),
         "Constructing a ray through a corner of the canvas"
      );

      C4.Inverted_Transformation := Radatracer.Matrices.Invert (
         Radatracer.Matrices.Rotation_Y (Ada.Numerics.Pi / 4.0) *
         Radatracer.Matrices.Translation (0.0, -2.0, 5.0)
      );

      AUnit.Assertions.Assert (
         Ray_For_Pixel (C4, 100, 50) = (Make_Point (0, 2, -5), Make_Vector (0.70711, 0.0, -0.70711)),
         "Constructing a ray when the camera is transformed"
      );

      AUnit.Assertions.Assert (
         Render (C5, W) (5, 5) = Radatracer.Images.To_Pixel (Make_Color (0.38066, 0.47583, 0.2855)),
         "Rendering a world with a camera"
      );
   end Test_Camera;

   procedure Test_Shadows (T : in out AUnit.Test_Cases.Test_Case'Class);
   procedure Test_Shadows (T : in out AUnit.Test_Cases.Test_Case'Class) is
      pragma Unreferenced (T);

      W : constant World := Default_World;
      P1 : constant Point := Make_Point (0, 10, 0);
      P2 : constant Point := Make_Point (10, -10, 10);
      P3 : constant Point := Make_Point (-20, 20, -20);
      P4 : constant Point := Make_Point (-2, 2, -2);
   begin
      AUnit.Assertions.Assert (not Is_Shadowed (W, P1), "There is no shadow when nothing is collinear with point and light");
      AUnit.Assertions.Assert (Is_Shadowed (W, P2), "The shadow when an object is between the point and the light");
      AUnit.Assertions.Assert (not Is_Shadowed (W, P3), "There is no shadow when the object is behind the light");
      AUnit.Assertions.Assert (not Is_Shadowed (W, P4), "There is no shadow when the object is behind the point");
   end Test_Shadows;

   procedure Test_Fake_Object (T : in out AUnit.Test_Cases.Test_Case'Class);
   procedure Test_Fake_Object (T : in out AUnit.Test_Cases.Test_Case'Class) is
      pragma Unreferenced (T);
      use type Radatracer.Matrices.Matrix4;

      S : Test_Object;
      R : constant Ray := (Origin => Make_Point (0, 0, -5), Direction => Make_Vector (0, 0, 1));
      XS : Intersections.Set;
   begin
      AUnit.Assertions.Assert (XS.Is_Empty, "Useless test so that GNAT doesn't complain that XS is never read");

      AUnit.Assertions.Assert (S.Inverted_Transformation = Radatracer.Matrices.Identity_Matrix4, "The default transformation of a derived Object");

      S.Set_Transformation (Radatracer.Matrices.Scaling (2.0, 2.0, 2.0));
      XS := S.Intersect (R);
      AUnit.Assertions.Assert (
         S.Saved_Ray = (Origin => Make_Point (0.0, 0.0, -2.5), Direction => Make_Vector (0.0, 0.0, 0.5)),
         "Intersecting a scaled object with a ray"
      );

      S.Set_Transformation (Radatracer.Matrices.Translation (5.0, 0.0, 0.0));
      XS := S.Intersect (R);
      AUnit.Assertions.Assert (
         S.Saved_Ray = (Origin => Make_Point (-5.0, 0.0, -5.0), Direction => R.Direction),
         "Intersecting a translated object with a ray"
      );

      S.Set_Transformation (Radatracer.Matrices.Translation (0.0, 1.0, 0.0));
      AUnit.Assertions.Assert (
         S.Normal_At (Make_Point (0.0, 1.70711, -0.70711)) = Make_Vector (0.0, 0.70711, -0.70711),
         "Computing the normal on a translated object"
      );

      S.Set_Transformation (Radatracer.Matrices.Scaling (1.0, 0.5, 1.0) * Radatracer.Matrices.Rotation_Z (Ada.Numerics.Pi / 5.0));
      AUnit.Assertions.Assert (
         S.Normal_At (Make_Point (0.0, 0.70711, -0.70711)) = Make_Vector (0.0, 0.97014, -0.24254),
         "Computing the normal on a transformed object"
      );
   end Test_Fake_Object;

   procedure Test_Reflected_Color (T : in out AUnit.Test_Cases.Test_Case'Class);
   procedure Test_Reflected_Color (T : in out AUnit.Test_Cases.Test_Case'Class) is
      pragma Unreferenced (T);

      W : World := Default_World;
      R : Ray := (Origin, Make_Vector (0, 0, 1));
      I : constant Intersection := (1.0, W.Objects (1));
      VI : constant Intersections.Set := Intersections.To_Set (I);
      PII : Precomputed_Intersection_Info := Prepare_Calculations (R, VI, VI.First);
      P : constant Object_Access := new Plane'(
         Inverted_Transformation => Radatracer.Matrices.Invert (
            Radatracer.Matrices.Translation (0.0, -1.0, 0.0)
         ),
         Material => (
            Reflective => 0.5,
            others => <>
         )
      );
      I2 : constant Intersection := (1.41421, P);
      VI2 : constant Intersections.Set := Intersections.To_Set (I2);
   begin
      W.Objects (1).Material.Ambient := 1.0;

      AUnit.Assertions.Assert (Reflected_Color (W, PII, 1) = Black, "The reflected color for a nonreflective material");

      W.Objects.Append (P);

      R := (Make_Point (0, 0, -3), Make_Vector (0.0, -0.70711, 0.70711));
      PII := Prepare_Calculations (R, VI2, VI2.First);

      AUnit.Assertions.Assert (Reflected_Color (W, PII, 1) = Make_Color (0.19033, 0.23791, 0.14274), "The reflected color for a reflective material");
      AUnit.Assertions.Assert (Shade_Hit (W, PII) = Make_Color (0.87675, 0.92433, 0.82917), "Shade_Hit with a reflective material");
   end Test_Reflected_Color;

   procedure Test_Refracted_Color (T : in out AUnit.Test_Cases.Test_Case'Class);
   procedure Test_Refracted_Color (T : in out AUnit.Test_Cases.Test_Case'Class) is
      pragma Unreferenced (T);
      use type Intersections.Set;

      W : constant World := Default_World;
      R : constant Ray := (Make_Point (0, 0, -5), Make_Vector (0, 0, 1));
      XS : constant Intersections.Set :=
         Intersections.To_Set (Intersection'(4.0, W.Objects (0))) or
         Intersections.To_Set (Intersection'(6.0, W.Objects (0)));
      PII : Precomputed_Intersection_Info := Prepare_Calculations (Ray => R, XS => XS, Hit_Index => XS.First);

      R2 : constant Ray := (Make_Point (0.0, 0.0, 0.70711), Make_Vector (0, 1, 0));
      XS2 : constant Intersections.Set :=
         Intersections.To_Set (Intersection'(-0.70711, W.Objects (0))) or
         Intersections.To_Set (Intersection'(0.70711, W.Objects (0)));
   begin
      AUnit.Assertions.Assert (Refracted_Color (W, PII, Default_Max_Recursion) = Black, "The refracted color with an opaque surface");

      W.Objects (0).Material.Transparency := 1.0;
      W.Objects (0).Material.Refractive_Index := 1.5;

      AUnit.Assertions.Assert (Refracted_Color (W, PII, 0) = Black, "The refracted color at the maximum recursive depth");

      PII := Prepare_Calculations (Ray => R2, XS => XS2, Hit_Index => Intersections.Next (XS2.First));

      AUnit.Assertions.Assert (Refracted_Color (W, PII, Default_Max_Recursion) = Black, "The refracted color under total internal reflection");
   end Test_Refracted_Color;

   procedure Test_Inifinite_Recursion_Protection (T : in out AUnit.Test_Cases.Test_Case'Class);
   procedure Test_Inifinite_Recursion_Protection (T : in out AUnit.Test_Cases.Test_Case'Class) is
      pragma Unreferenced (T);

      use type Object_Vectors.Vector;

      Lower_Plane : constant Object_Access := new Plane'(
         Inverted_Transformation => Radatracer.Matrices.Invert (
            Radatracer.Matrices.Translation (0.0, -1.0, 0.0)
         ),
         Material => (
            Reflective => 1.0,
            others => <>
         )
      );

      Upper_Plane : constant Object_Access := new Plane'(
         Inverted_Transformation => Radatracer.Matrices.Invert (
            Radatracer.Matrices.Translation (0.0, 1.0, 0.0)
         ),
         Material => (
            Reflective => 1.0,
            others => <>
         )
      );

      World : constant Radatracer.Objects.World := (
         Light => (Intensity => White, Position => Origin),
         Objects => Lower_Plane & Upper_Plane
      );

      Ray : constant Radatracer.Ray := (
         Origin => Radatracer.Origin,
         Direction => Make_Vector (0, 1, 0)
      );
   begin
      AUnit.Assertions.Assert (Color_At (World, Ray).W = 0.0, "Color_At terminates successfully");
   end Test_Inifinite_Recursion_Protection;

   overriding procedure Register_Tests (T : in out Test) is
      use AUnit.Test_Cases.Registration;
   begin
      Register_Routine (T, Test_Intersection_Hits'Access, "Ray-Sphere hits tests");
      Register_Routine (T, Test_Reflections'Access, "Reflection tests");
      Register_Routine (T, Test_Lightning'Access, "Lightning tests");
      Register_Routine (T, Test_World_Intersections'Access, "World intersection tests");
      Register_Routine (T, Test_Prepare_Calculations'Access, "Prepare Calculations tests");
      Register_Routine (T, Test_Shade_Hit'Access, "Shade hit tests");
      Register_Routine (T, Test_Color_At'Access, "Color at tests");
      Register_Routine (T, Test_Camera'Access, "Camera tests");
      Register_Routine (T, Test_Shadows'Access, "Shadow tests");
      Register_Routine (T, Test_Fake_Object'Access, "Fake Object that tests Chapter 9 refactor");
      Register_Routine (T, Test_Reflected_Color'Access, "Reflected_Color function tests");
      Register_Routine (T, Test_Refracted_Color'Access, "Refracted_Color function tests");
      Register_Routine (T, Test_Inifinite_Recursion_Protection'Access, "Inifinite recursion avoidance test");
   end Register_Tests;

   overriding function Name (T : Test) return AUnit.Message_String is
      pragma Unreferenced (T);
   begin
      return AUnit.Format ("Radatracer.Objects");
   end Name;
end Radatracer.Objects.Tests;
