with Ada.Numerics;
with AUnit.Assertions;
with Radatracer.Canvas;
with Radatracer.Matrices;

package body Radatracer.Objects.Tests is

   procedure Test_Ray_Sphere_Intersections (T : in out AUnit.Test_Cases.Test_Case'Class);
   procedure Test_Ray_Sphere_Intersections (T : in out AUnit.Test_Cases.Test_Case'Class) is
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
   begin
      AUnit.Assertions.Assert (Reflect (Make_Vector (1, -1, 0), Make_Vector (0, 1, 0)) = Make_Vector (1, 1, 0), "Reflection test 1");
      AUnit.Assertions.Assert (Reflect (Make_Vector (0, -1, 0), Make_Vector (0.70711, 0.70711, 0.0)) = Make_Vector (1, 0, 0), "Reflection test 2");
   end Test_Reflections;

   procedure Test_Lightning (T : in out AUnit.Test_Cases.Test_Case'Class);
   procedure Test_Lightning (T : in out AUnit.Test_Cases.Test_Case'Class) is
      M : constant Material := (others => <>);
      Position : constant Tuple := Make_Point (0, 0, 0);

      Eye_Vector_1 : constant Tuple := Make_Vector (0, 0, -1);
      Normal_Vector_1 : constant Tuple := Make_Vector (0, 0, -1);
      Light_1 : constant Point_Light := (Intensity => Radatracer.Canvas.Make_Color (1.0, 1.0, 1.0), Position => Make_Point (0, 0, -10));

      Eye_Vector_2 : constant Tuple := Make_Vector (0.0, 0.70711, -0.70711);
      Normal_Vector_2 : constant Tuple := Make_Vector (0, 0, -1);
      Light_2 : constant Point_Light := (Intensity => Radatracer.Canvas.Make_Color (1.0, 1.0, 1.0), Position => Make_Point (0, 0, -10));

      Eye_Vector_3 : constant Tuple := Make_Vector (0, 0, -1);
      Normal_Vector_3 : constant Tuple := Make_Vector (0, 0, -1);
      Light_3 : constant Point_Light := (Intensity => Radatracer.Canvas.Make_Color (1.0, 1.0, 1.0), Position => Make_Point (0, 10, -10));

      Eye_Vector_4 : constant Tuple := Make_Vector (0.0, -0.70711, -0.70711);
      Normal_Vector_4 : constant Tuple := Make_Vector (0, 0, -1);
      Light_4 : constant Point_Light := (Intensity => Radatracer.Canvas.Make_Color (1.0, 1.0, 1.0), Position => Make_Point (0, 10, -10));

      Eye_Vector_5 : constant Tuple := Make_Vector (0, 0, -1);
      Normal_Vector_5 : constant Tuple := Make_Vector (0, 0, -1);
      Light_5 : constant Point_Light := (Intensity => Radatracer.Canvas.Make_Color (1.0, 1.0, 1.0), Position => Make_Point (0, 0, 10));
   begin
      AUnit.Assertions.Assert (
         Lightning (M, Light_1, Position, Eye_Vector_1, Normal_Vector_1) = Radatracer.Canvas.Make_Color (1.9, 1.9, 1.9),
         "Lightning with the eye between the light and the surface"
      );

      AUnit.Assertions.Assert (
         Lightning (M, Light_2, Position, Eye_Vector_2, Normal_Vector_2) = Radatracer.Canvas.Make_Color (1.0, 1.0, 1.0),
         "Lightning with the eye between light and surface, eye offset 45º"
      );

      AUnit.Assertions.Assert (
         Lightning (M, Light_3, Position, Eye_Vector_3, Normal_Vector_3) = Radatracer.Canvas.Make_Color (0.7364, 0.7364, 0.7364),
         "Lightning with the eye opposite surface, light offset 45º"
      );

      AUnit.Assertions.Assert (
         Lightning (M, Light_4, Position, Eye_Vector_4, Normal_Vector_4) = Radatracer.Canvas.Make_Color (1.6364, 1.6364, 1.6364),
         "Lightning with the eye in the path of the reflection vector"
      );

      AUnit.Assertions.Assert (
         Lightning (M, Light_5, Position, Eye_Vector_5, Normal_Vector_5) = Radatracer.Canvas.Make_Color (0.1, 0.1, 0.1),
         "Lightning with the eye in the path of the reflection vector"
      );
   end Test_Lightning;

   overriding procedure Register_Tests (T : in out Test) is
      use AUnit.Test_Cases.Registration;
   begin
      Register_Routine (T, Test_Ray_Sphere_Intersections'Access, "Ray-Sphere intersection tests");
      Register_Routine (T, Test_Intersection_Hits'Access, "Ray-Sphere hits tests");
      Register_Routine (T, Test_Sphere_Normals'Access, "Sphere normal vector tests");
      Register_Routine (T, Test_Reflections'Access, "Reflection tests");
      Register_Routine (T, Test_Lightning'Access, "Lightning tests");
   end Register_Tests;

   overriding function Name (T : Test) return AUnit.Message_String is
      pragma Unreferenced (T);
   begin
      return AUnit.Format ("Radatracer.Objects");
   end Name;
end Radatracer.Objects.Tests;
