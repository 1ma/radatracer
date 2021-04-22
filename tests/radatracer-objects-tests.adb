with Ada.Numerics;
with AUnit.Assertions;
with Radatracer.Matrices;

package body Radatracer.Objects.Tests is
   function Default_World return World;
   function Default_World return World is
      use type Sphere_Vectors.Vector;

      Sphere1 : constant Sphere := (
         Inverted_Transformation => <>,
         Material => (
            Color => Make_Color (0.8, 1.0, 0.6),
            Ambient => <>,
            Diffuse => 0.7,
            Specular => 0.2,
            Shininess => <>
         )
      );

      Sphere2 : constant Sphere := (
         Inverted_Transformation => Radatracer.Matrices.Invert (Radatracer.Matrices.Scaling (0.5, 0.5, 0.5)),
         Material => <>
      );
   begin
      return (
         Light => (Position => Make_Point (-10, 10, -10), Intensity => <>),
         Objects => Sphere1 & Sphere2
      );
   end Default_World;

   procedure Test_Ray_Sphere_Intersections (T : in out AUnit.Test_Cases.Test_Case'Class);
   procedure Test_Ray_Sphere_Intersections (T : in out AUnit.Test_Cases.Test_Case'Class) is
      pragma Unreferenced (T);

      use type Radatracer.Objects.Intersection_Vectors.Vector;

      S1 : constant Sphere := (Inverted_Transformation => <>, others => <>);
      S2 : constant Sphere := (Inverted_Transformation => Radatracer.Matrices.Invert (Radatracer.Matrices.Scaling (2.0, 2.0, 2.0)), others => <>);
      S3 : constant Sphere := (Inverted_Transformation => Radatracer.Matrices.Invert (Radatracer.Matrices.Translation (5.0, 0.0, 0.0)), others => <>);

      R1 : constant Ray := (Make_Point (0, 0, -5), Make_Vector (0, 0, 1));
      R2 : constant Ray := (Make_Point (0, 1, -5), Make_Vector (0, 0, 1));
      R3 : constant Ray := (Make_Point (0, 2, -5), Make_Vector (0, 0, 1));
      R4 : constant Ray := (Make_Point (0, 0, 0), Make_Vector (0, 0, 1));
      R5 : constant Ray := (Make_Point (0, 0, 5), Make_Vector (0, 0, 1));
      R6 : constant Ray := (Make_Point (0, 0, -5), Make_Vector (0, 0, 1));
      R7 : constant Ray := (Make_Point (0, 0, -5), Make_Vector (0, 0, 1));

      V1 : constant Intersection_Vectors.Vector := (4.0, S1) & (6.0, S1);
      V2 : constant Intersection_Vectors.Vector := (5.0, S1) & (5.0, S1);
      V3 : Intersection_Vectors.Vector;
      V4 : constant Intersection_Vectors.Vector := (-1.0, S1) & (1.0, S1);
      V5 : constant Intersection_Vectors.Vector := (-6.0, S1) & (-4.0, S1);
      V6 : constant Intersection_Vectors.Vector := (3.0, S2) & (7.0, S2);
      V7 : Intersection_Vectors.Vector;
   begin
      AUnit.Assertions.Assert (Intersect (S1, R1) = V1, "Ray-Sphere intersection test 1 - intersection at 2 points");
      AUnit.Assertions.Assert (Intersect (S1, R2) = V2, "Ray-Sphere intersection test 2 - intersection at 1 point (tangent point)");
      AUnit.Assertions.Assert (Intersect (S1, R3) = V3, "Ray-Sphere intersection test 3 - no intersection");
      AUnit.Assertions.Assert (Intersect (S1, R4) = V4, "Ray-Sphere intersection test 4 - ray originates inside the sphere");
      AUnit.Assertions.Assert (Intersect (S1, R5) = V5, "Ray-Sphere intersection test 5 - sphere is behind the ray");
      AUnit.Assertions.Assert (Intersect (S2, R6) = V6, "Ray-Sphere intersection test 6 - sphere is scaled");
      AUnit.Assertions.Assert (Intersect (S3, R7) = V7, "Ray-Sphere intersection test 7 - sphere is translated away from the ray");
   end Test_Ray_Sphere_Intersections;

   procedure Test_Intersection_Hits (T : in out AUnit.Test_Cases.Test_Case'Class);
   procedure Test_Intersection_Hits (T : in out AUnit.Test_Cases.Test_Case'Class) is
      pragma Unreferenced (T);

      use type Intersection_Vectors.Cursor;
      use type Intersection_Vectors.Vector;

      S : constant Sphere := (Inverted_Transformation => <>, others => <>);

      I1_1 : constant Intersection := (1.0, S);
      I1_2 : constant Intersection := (2.0, S);
      V1 : constant Intersection_Vectors.Vector := I1_1 & I1_2;

      I2_1 : constant Intersection := (-1.0, S);
      I2_2 : constant Intersection := (1.0, S);
      V2 : constant Intersection_Vectors.Vector := I2_1 & I2_2;

      I3_1 : constant Intersection := (-2.0, S);
      I3_2 : constant Intersection := (-1.0, S);
      V3 : constant Intersection_Vectors.Vector := I3_1 & I3_2;

      I4_1 : constant Intersection := (5.0, S);
      I4_2 : constant Intersection := (7.0, S);
      I4_3 : constant Intersection := (-3.0, S);
      I4_4 : constant Intersection := (2.0, S);
      V4 : constant Intersection_Vectors.Vector := I4_1 & I4_2 & I4_3 & I4_4;
   begin
      AUnit.Assertions.Assert (V1 (Hit (V1)) = I1_1, "Ray-Sphere hit test 1 - sorted positive T_Values");
      AUnit.Assertions.Assert (V2 (Hit (V2)) = I2_2, "Ray-Sphere hit test 2 - sorted positive and negative T_Values");
      AUnit.Assertions.Assert (Hit (V3) = Intersection_Vectors.No_Element, "Ray-Sphere hit test 3 - only negative T_Values");
      AUnit.Assertions.Assert (V4 (Hit (V4)) = I4_4, "Ray-Sphere hit test 3 - unsorted positive and negative T_Values");
   end Test_Intersection_Hits;

   procedure Test_Sphere_Normals (T : in out AUnit.Test_Cases.Test_Case'Class);
   procedure Test_Sphere_Normals (T : in out AUnit.Test_Cases.Test_Case'Class) is
      pragma Unreferenced (T);

      use type Radatracer.Matrices.Matrix4;

      S : Sphere := (Inverted_Transformation => Radatracer.Matrices.Identity_Matrix4, others => <>);
   begin
      AUnit.Assertions.Assert (Normal_At (S, Make_Point (1, 0, 0)) = Make_Vector (1, 0, 0), "Sphere normal test 1");
      AUnit.Assertions.Assert (Normal_At (S, Make_Point (0, 1, 0)) = Make_Vector (0, 1, 0), "Sphere normal test 2");
      AUnit.Assertions.Assert (Normal_At (S, Make_Point (0, 0, 1)) = Make_Vector (0, 0, 1), "Sphere normal test 3");
      AUnit.Assertions.Assert (Normal_At (S, Make_Point (0.57735, 0.57735, 0.57735)) = Make_Vector (0.57735, 0.57735, 0.57735), "Sphere normal test 4");

      Set_Transformation (S, Radatracer.Matrices.Translation (0.0, 1.0, 0.0));
      AUnit.Assertions.Assert (Normal_At (S, Make_Point (0.0, 1.70711, -0.70711)) = Make_Vector (0.0, 0.70711, -0.70711), "Sphere normal test 5");

      Set_Transformation (S, Radatracer.Matrices.Scaling (1.0, 0.5, 1.0) * Radatracer.Matrices.Rotation_Z (Ada.Numerics.Pi / 5.0));
      AUnit.Assertions.Assert (Normal_At (S, Make_Point (0.0, 0.70711, -0.70711)) = Make_Vector (0.0, 0.97014, -0.24254), "Sphere normal test 6");
   end Test_Sphere_Normals;

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

      Material : constant Radatracer.Objects.Material := (others => <>);
      Position : constant Point := Make_Point (0, 0, 0);

      Eye_Vector_1 : constant Vector := Make_Vector (0, 0, -1);
      Normal_Vector_1 : constant Vector := Make_Vector (0, 0, -1);
      Light_1 : constant Point_Light := (Intensity => Make_Color (1.0, 1.0, 1.0), Position => Make_Point (0, 0, -10));

      Eye_Vector_2 : constant Vector := Make_Vector (0.0, 0.70711, -0.70711);
      Normal_Vector_2 : constant Vector := Make_Vector (0, 0, -1);
      Light_2 : constant Point_Light := (Intensity => Make_Color (1.0, 1.0, 1.0), Position => Make_Point (0, 0, -10));

      Eye_Vector_3 : constant Vector := Make_Vector (0, 0, -1);
      Normal_Vector_3 : constant Vector := Make_Vector (0, 0, -1);
      Light_3 : constant Point_Light := (Intensity => Make_Color (1.0, 1.0, 1.0), Position => Make_Point (0, 10, -10));

      Eye_Vector_4 : constant Vector := Make_Vector (0.0, -0.70711, -0.70711);
      Normal_Vector_4 : constant Vector := Make_Vector (0, 0, -1);
      Light_4 : constant Point_Light := (Intensity => Make_Color (1.0, 1.0, 1.0), Position => Make_Point (0, 10, -10));

      Eye_Vector_5 : constant Vector := Make_Vector (0, 0, -1);
      Normal_Vector_5 : constant Vector := Make_Vector (0, 0, -1);
      Light_5 : constant Point_Light := (Intensity => Make_Color (1.0, 1.0, 1.0), Position => Make_Point (0, 0, 10));

      Eye_Vector_6 : constant Vector := Make_Vector (0, 0, -1);
      Normal_Vector_6 : constant Vector := Make_Vector (0, 0, -1);
      Light_6 : constant Point_Light := (Intensity => Make_Color (1.0, 1.0, 1.0), Position => Make_Point (0, 0, -10));
   begin
      AUnit.Assertions.Assert (
         Lightning (Material, Light_1, Position, Eye_Vector_1, Normal_Vector_1) = Make_Color (1.9, 1.9, 1.9),
         "Lightning with the eye between the light and the surface"
      );

      AUnit.Assertions.Assert (
         Lightning (Material, Light_2, Position, Eye_Vector_2, Normal_Vector_2) = Make_Color (1.0, 1.0, 1.0),
         "Lightning with the eye between light and surface, eye offset 45º"
      );

      AUnit.Assertions.Assert (
         Lightning (Material, Light_3, Position, Eye_Vector_3, Normal_Vector_3) = Make_Color (0.7364, 0.7364, 0.7364),
         "Lightning with the eye opposite surface, light offset 45º"
      );

      AUnit.Assertions.Assert (
         Lightning (Material, Light_4, Position, Eye_Vector_4, Normal_Vector_4) = Make_Color (1.63721, 1.63721, 1.63721),
         "Lightning with the eye in the path of the reflection vector"
      );

      AUnit.Assertions.Assert (
         Lightning (Material, Light_5, Position, Eye_Vector_5, Normal_Vector_5) = Make_Color (0.1, 0.1, 0.1),
         "Lightning with the eye in the path of the reflection vector"
      );

      AUnit.Assertions.Assert (
         Lightning (Material, Light_6, Position, Eye_Vector_6, Normal_Vector_6, True) = Make_Color (0.1, 0.1, 0.1),
         "Lightning with the surface in shadow"
      );
   end Test_Lightning;

   procedure Test_World_Intersections (T : in out AUnit.Test_Cases.Test_Case'Class);
   procedure Test_World_Intersections (T : in out AUnit.Test_Cases.Test_Case'Class) is
      pragma Unreferenced (T);

      use type Ada.Containers.Count_Type;

      W : constant World := Default_World;
      R : constant Ray := (Origin => Make_Point (0, 0, -5), Direction => Make_Vector (0, 0, 1));

      I : constant Intersection_Vectors.Vector := Intersect (W, R);
   begin
      AUnit.Assertions.Assert (I.Length = 4, "World intersection test 1 - part 1");
      AUnit.Assertions.Assert (I (0).T_Value = 4.0, "World intersection test 1 - part 2");
      AUnit.Assertions.Assert (I (1).T_Value = 4.5, "World intersection test 1 - part 3");
      AUnit.Assertions.Assert (I (2).T_Value = 5.5, "World intersection test 1 - part 4");
      AUnit.Assertions.Assert (I (3).T_Value = 6.0, "World intersection test 1 - part 5");
   end Test_World_Intersections;

   procedure Test_Prepare_Calculations (T : in out AUnit.Test_Cases.Test_Case'Class);
   procedure Test_Prepare_Calculations (T : in out AUnit.Test_Cases.Test_Case'Class) is
      pragma Unreferenced (T);

      R1 : constant Ray := (Origin => Make_Point (0, 0, -5), Direction => Make_Vector (0, 0, 1));
      R2 : constant Ray := (Origin => Make_Point (0, 0, 0), Direction => Make_Vector (0, 0, 1));

      I1 : constant Intersection := (T_Value => 4.0, Object => (others => <>));
      I2 : constant Intersection := (T_Value => 1.0, Object => (others => <>));

      PII1 : constant Precomputed_Intersection_Info := Prepare_Calculations (I1, R1);
      PII2 : constant Precomputed_Intersection_Info := Prepare_Calculations (I2, R2);
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
   end Test_Prepare_Calculations;

   procedure Test_Shade_Hit (T : in out AUnit.Test_Cases.Test_Case'Class);
   procedure Test_Shade_Hit (T : in out AUnit.Test_Cases.Test_Case'Class) is
      pragma Unreferenced (T);

      W : World := Default_World;
      R1 : constant Ray := (Origin => Make_Point (0, 0, -5), Direction => Make_Vector (0, 0, 1));
      I1 : constant Intersection := (T_Value => 4.0, Object => W.Objects (0));
      PII1 : constant Precomputed_Intersection_Info := Prepare_Calculations (I1, R1);

      R2 : constant Ray := (Origin => Make_Point (0, 0, 0), Direction => Make_Vector (0, 0, 1));
      I2 : constant Intersection := (T_Value => 0.5, Object => W.Objects (1));
      PII2 : constant Precomputed_Intersection_Info := Prepare_Calculations (I2, R2);
   begin
      AUnit.Assertions.Assert (Shade_Hit (W, PII1) = Make_Color (0.38066, 0.47583, 0.2855), "Shading an intersection");

      W.Light := (Position => Make_Point (0.0, 0.25, 0.0), Intensity => Make_Color (1.0, 1.0, 1.0));

      AUnit.Assertions.Assert (Shade_Hit (W, PII2) = Make_Color (0.90498, 0.90498, 0.90498), "Shading an intersection from the inside");
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

      use type Radatracer.Canvas.Pixel;
      use type Radatracer.Matrices.Matrix4;

      C1 : constant Camera := Make_Camera (160, 120, Ada.Numerics.Pi / 2.0);
      C2 : constant Camera := Make_Camera (200, 125, Ada.Numerics.Pi / 2.0);
      C3 : constant Camera := Make_Camera (125, 200, Ada.Numerics.Pi / 2.0);
      C4 : Camera := Make_Camera (201, 101, Ada.Numerics.Pi / 2.0);

      W : constant World := Default_World;
      C5 : constant Camera := Make_Camera (11, 11, Ada.Numerics.Pi / 2.0, Make_Point (0, 0, -5), Make_Point (0, 0, 0), Make_Vector (0, 1, 0));
   begin
      AUnit.Assertions.Assert (
         C1.H_Size = 160 and C1.V_Size = 120 and C1.FOV = Ada.Numerics.Pi / 2.0 and C1.Inverted_Transformation = Radatracer.Matrices.Identity_Matrix4,
         "Constructing a camera"
      );

      AUnit.Assertions.Assert (C2.Pixel_Size = 0.01, "The pixel size for a horizontal camera");
      AUnit.Assertions.Assert (C3.Pixel_Size = 0.01, "The pixel size for a vertical camera");

      AUnit.Assertions.Assert (
         Ray_For_Pixel (C4, 100, 50) = (Make_Point (0, 0, 0), Make_Vector (0, 0, -1)),
         "Constructing a ray through the center of the canvas"
      );

      AUnit.Assertions.Assert (
         Ray_For_Pixel (C4, 0, 0) = (Make_Point (0, 0, 0), Make_Vector (0.66519, 0.33259, -0.66851)),
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
         Render (C5, W) (5, 5) = Radatracer.Canvas.To_Pixel (Make_Color (0.38066, 0.47583, 0.2855)),
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

   overriding procedure Register_Tests (T : in out Test) is
      use AUnit.Test_Cases.Registration;
   begin
      Register_Routine (T, Test_Ray_Sphere_Intersections'Access, "Ray-Sphere intersection tests");
      Register_Routine (T, Test_Intersection_Hits'Access, "Ray-Sphere hits tests");
      Register_Routine (T, Test_Sphere_Normals'Access, "Sphere normal vector tests");
      Register_Routine (T, Test_Reflections'Access, "Reflection tests");
      Register_Routine (T, Test_Lightning'Access, "Lightning tests");
      Register_Routine (T, Test_World_Intersections'Access, "World intersection tests");
      Register_Routine (T, Test_Prepare_Calculations'Access, "Prepare Calculations tests");
      Register_Routine (T, Test_Shade_Hit'Access, "Shade hit tests");
      Register_Routine (T, Test_Color_At'Access, "Color at tests");
      Register_Routine (T, Test_Camera'Access, "Camera tests");
      Register_Routine (T, Test_Shadows'Access, "Shadow tests");
   end Register_Tests;

   overriding function Name (T : Test) return AUnit.Message_String is
      pragma Unreferenced (T);
   begin
      return AUnit.Format ("Radatracer.Objects");
   end Name;
end Radatracer.Objects.Tests;
