with AUnit.Assertions;
with Radatracer.Objects.Patterns;

package body Radatracer.Objects.Spheres.Tests is
   function Transformed_Glass_Sphere (Refractive_Index : Value; Transformation : Radatracer.Matrices.Matrix4) return Object_Access;
   function Transformed_Glass_Sphere (Refractive_Index : Value; Transformation : Radatracer.Matrices.Matrix4) return Object_Access is
   begin
      return new Sphere'(
         Inverted_Transformation => Radatracer.Matrices.Invert (Transformation),
         Material => (
            Transparency => 1.0,
            Refractive_Index => Refractive_Index,
            others => <>
         )
      );
   end Transformed_Glass_Sphere;

   procedure Test_Ray_Sphere_Intersections (T : in out AUnit.Test_Cases.Test_Case'Class);
   procedure Test_Ray_Sphere_Intersections (T : in out AUnit.Test_Cases.Test_Case'Class) is
      pragma Unreferenced (T);

      use type Radatracer.Objects.Intersection_Vectors.Vector;

      S1 : constant Object_Access := new Sphere'(Inverted_Transformation => <>, others => <>);
      S2 : constant Object_Access := new Sphere'(
         Inverted_Transformation => Radatracer.Matrices.Invert (Radatracer.Matrices.Scaling (2.0, 2.0, 2.0)),
         others => <>
      );
      S3 : constant Object_Access := new Sphere'(
         Inverted_Transformation => Radatracer.Matrices.Invert (Radatracer.Matrices.Translation (5.0, 0.0, 0.0)),
         others => <>
      );

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
      AUnit.Assertions.Assert (S1.all.Local_Intersect (R1) = V1, "Ray-Sphere intersection test 1 - intersection at 2 points");
      AUnit.Assertions.Assert (S1.all.Local_Intersect (R2) = V2, "Ray-Sphere intersection test 2 - intersection at 1 point (tangent point)");
      AUnit.Assertions.Assert (S1.all.Local_Intersect (R3) = V3, "Ray-Sphere intersection test 3 - no intersection");
      AUnit.Assertions.Assert (S1.all.Local_Intersect (R4) = V4, "Ray-Sphere intersection test 4 - ray originates inside the sphere");
      AUnit.Assertions.Assert (S1.all.Local_Intersect (R5) = V5, "Ray-Sphere intersection test 5 - sphere is behind the ray");
      AUnit.Assertions.Assert (S2.all.Intersect (R6) = V6, "Ray-Sphere intersection test 6 - sphere is scaled");
      AUnit.Assertions.Assert (S3.all.Intersect (R7) = V7, "Ray-Sphere intersection test 7 - sphere is translated away from the ray");
   end Test_Ray_Sphere_Intersections;

   procedure Test_Sphere_Normals (T : in out AUnit.Test_Cases.Test_Case'Class);
   procedure Test_Sphere_Normals (T : in out AUnit.Test_Cases.Test_Case'Class) is
      pragma Unreferenced (T);

      use type Radatracer.Matrices.Matrix4;

      S : Sphere := (Inverted_Transformation => Radatracer.Matrices.Identity_Matrix4, others => <>);
   begin
      AUnit.Assertions.Assert (S.Local_Normal_At (Make_Point (1, 0, 0)) = Make_Vector (1, 0, 0), "Sphere normal test 1");
      AUnit.Assertions.Assert (S.Local_Normal_At (Make_Point (0, 1, 0)) = Make_Vector (0, 1, 0), "Sphere normal test 2");
      AUnit.Assertions.Assert (S.Local_Normal_At (Make_Point (0, 0, 1)) = Make_Vector (0, 0, 1), "Sphere normal test 3");
      AUnit.Assertions.Assert (S.Local_Normal_At (Make_Point (0.57735, 0.57735, 0.57735)) = Make_Vector (0.57735, 0.57735, 0.57735), "Sphere normal test 4");

      Set_Transformation (S, Radatracer.Matrices.Translation (0.0, 1.0, 0.0));
      AUnit.Assertions.Assert (S.Normal_At (Make_Point (0.0, 1.70711, -0.70711)) = Make_Vector (0.0, 0.70711, -0.70711), "Sphere normal test 5");

      Set_Transformation (S, Radatracer.Matrices.Scaling (1.0, 0.5, 1.0) * Radatracer.Matrices.Rotation_Z (Ada.Numerics.Pi / 5.0));
      AUnit.Assertions.Assert (S.Normal_At (Make_Point (0.0, 0.70711, -0.70711)) = Make_Vector (0.0, 0.97014, -0.24254), "Sphere normal test 6");
   end Test_Sphere_Normals;

   procedure Test_Object_Patterns (T : in out AUnit.Test_Cases.Test_Case'Class);
   procedure Test_Object_Patterns (T : in out AUnit.Test_Cases.Test_Case'Class) is
      pragma Unreferenced (T);

      Plain_Sphere : constant Sphere := (others => <>);
      Transformed_Sphere : constant Sphere := (
         Inverted_Transformation => Radatracer.Matrices.Invert (Radatracer.Matrices.Scaling (2.0, 2.0, 2.0)),
         others => <>
      );

      Plain_Pattern : constant Radatracer.Objects.Patterns.Stripe := (A => Radatracer.White, B => Radatracer.Black, others => <>);
      Transformed_Pattern_1 : constant Radatracer.Objects.Patterns.Stripe := (
         A => Radatracer.White,
         B => Radatracer.Black,
         Inverted_Transformation => Radatracer.Matrices.Invert (Radatracer.Matrices.Scaling (2.0, 2.0, 2.0))
      );
      Transformed_Pattern_2 : constant Radatracer.Objects.Patterns.Stripe := (
         A => Radatracer.White,
         B => Radatracer.Black,
         Inverted_Transformation => Radatracer.Matrices.Invert (Radatracer.Matrices.Translation (0.5, 0.0, 0.0))
      );
   begin
      AUnit.Assertions.Assert (
         Pattern_At_Object (Plain_Pattern, Transformed_Sphere, Make_Point (1.5, 0.0, 0.0)) = Radatracer.White,
         "Stripes with an object transformation"
      );

      AUnit.Assertions.Assert (
         Pattern_At_Object (Transformed_Pattern_1, Plain_Sphere, Make_Point (1.5, 0.0, 0.0)) = Radatracer.White,
         "Stripes with a pattern transformation"
      );

      AUnit.Assertions.Assert (
         Pattern_At_Object (Transformed_Pattern_2, Plain_Sphere, Make_Point (2.5, 0.0, 0.0)) = Radatracer.White,
         "Stripes with both an object and pattern transformation"
      );
   end Test_Object_Patterns;

   procedure Test_Refractive_Indexes_Calculations (T : in out AUnit.Test_Cases.Test_Case'Class);
   procedure Test_Refractive_Indexes_Calculations (T : in out AUnit.Test_Cases.Test_Case'Class) is
      pragma Unreferenced (T);

      use type Intersection_Vectors.Vector;

      A : constant Object_Access := Transformed_Glass_Sphere (1.5, Radatracer.Matrices.Scaling (2.0, 2.0, 2.0));
      B : constant Object_Access := Transformed_Glass_Sphere (2.0, Radatracer.Matrices.Translation (0.0, 0.0, -0.25));
      C : constant Object_Access := Transformed_Glass_Sphere (2.5, Radatracer.Matrices.Translation (0.0, 0.0, 0.25));

      R : constant Ray := (Origin => Make_Point (0, 0, -4), Direction => Make_Vector (0, 0, 1));
      XS : constant Intersection_Vectors.Vector :=
         Intersection'(T_Value => 2.0, Object => A) &
         Intersection'(T_Value => 2.75, Object => B) &
         Intersection'(T_Value => 3.25, Object => C) &
         Intersection'(T_Value => 4.75, Object => B) &
         Intersection'(T_Value => 5.25, Object => C) &
         Intersection'(T_Value => 6.0, Object => A);

         pragma Unreferenced (R);
         pragma Unreferenced (XS);
   begin
      null;
   end Test_Refractive_Indexes_Calculations;

   overriding procedure Register_Tests (T : in out Test) is
      use AUnit.Test_Cases.Registration;
   begin
      Register_Routine (T, Test_Ray_Sphere_Intersections'Access, "Ray-Sphere intersection tests");
      Register_Routine (T, Test_Sphere_Normals'Access, "Sphere normal vector tests");
      Register_Routine (T, Test_Object_Patterns'Access, "Patterns on an Object tests");
      Register_Routine (T, Test_Refractive_Indexes_Calculations'Access, "Test refractive indexes");
   end Register_Tests;

   overriding function Name (T : Test) return AUnit.Message_String is
      pragma Unreferenced (T);
   begin
      return AUnit.Format ("Radatracer.Objects.Spheres");
   end Name;
end Radatracer.Objects.Spheres.Tests;
