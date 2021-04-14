with Ada.Numerics;
with AUnit.Assertions;

package body Radatracer.Objects.Tests is

   procedure Test_Ray_Sphere_Intersections (T : in out AUnit.Test_Cases.Test_Case'Class);
   procedure Test_Ray_Sphere_Intersections (T : in out AUnit.Test_Cases.Test_Case'Class) is
      use type Radatracer.Objects.Intersection_Vectors.Vector;

      S : constant Sphere := (Origin => Make_Point (0, 0, 0));

      R1 : constant Ray := (Origin => Make_Point (0, 0, -5), Direction => Make_Vector (0, 0, 1));
      R2 : constant Ray := (Origin => Make_Point (0, 1, -5), Direction => Make_Vector (0, 0, 1));
      R3 : constant Ray := (Origin => Make_Point (0, 2, -5), Direction => Make_Vector (0, 0, 1));
      R4 : constant Ray := (Origin => Make_Point (0, 0, 0), Direction => Make_Vector (0, 0, 1));
      R5 : constant Ray := (Origin => Make_Point (0, 0, 5), Direction => Make_Vector (0, 0, 1));

      V1 : constant Intersection_Vectors.Vector := (T_Value => 4.0, Object => S) & (T_Value => 6.0, Object => S);
      V2 : constant Intersection_Vectors.Vector := (T_Value => 5.0, Object => S) & (T_Value => 5.0, Object => S);
      V3 : Intersection_Vectors.Vector;
      V4 : constant Intersection_Vectors.Vector := (T_Value => -1.0, Object => S) & (T_Value => 1.0, Object => S);
      V5 : constant Intersection_Vectors.Vector := (T_Value => -6.0, Object => S) & (T_Value => -4.0, Object => S);
   begin
      AUnit.Assertions.Assert (Intersect (S, R1) = V1, "Ray-Sphere intersection test 1 - intersection at 2 points");
      AUnit.Assertions.Assert (Intersect (S, R2) = V2, "Ray-Sphere intersection test 2 - intersection at 1 point (tangent point)");
      AUnit.Assertions.Assert (Intersect (S, R3) = V3, "Ray-Sphere intersection test 3 - no intersection");
      AUnit.Assertions.Assert (Intersect (S, R4) = V4, "Ray-Sphere intersection test 4 - ray originates inside the sphere");
      AUnit.Assertions.Assert (Intersect (S, R5) = V5, "Ray-Sphere intersection test 5 - sphere is behind the ray");
   end Test_Ray_Sphere_Intersections;

   procedure Test_Intersection_Hits (T : in out AUnit.Test_Cases.Test_Case'Class);
   procedure Test_Intersection_Hits (T : in out AUnit.Test_Cases.Test_Case'Class) is
      use type Intersection_Vectors.Cursor;
      use type Intersection_Vectors.Vector;

      S : constant Sphere := (Origin => Make_Point (0, 0, 0));

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

   overriding procedure Register_Tests (T : in out Test) is
      use AUnit.Test_Cases.Registration;
   begin
      Register_Routine (T, Test_Ray_Sphere_Intersections'Access, "Ray-Sphere intersection tests");
      Register_Routine (T, Test_Intersection_Hits'Access, "Ray-Sphere hits tests");
   end Register_Tests;

   overriding function Name (T : Test) return AUnit.Message_String is
      pragma Unreferenced (T);
   begin
      return AUnit.Format ("Radatracer.Objects");
   end Name;
end Radatracer.Objects.Tests;
