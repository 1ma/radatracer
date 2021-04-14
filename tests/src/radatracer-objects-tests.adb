with Ada.Numerics;
with AUnit.Assertions;

package body Radatracer.Objects.Tests is

   procedure Test_Ray_Intersections (T : in out AUnit.Test_Cases.Test_Case'Class);
   procedure Test_Ray_Intersections (T : in out AUnit.Test_Cases.Test_Case'Class) is
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
   end Test_Ray_Intersections;

   overriding procedure Register_Tests (T : in out Test) is
      use AUnit.Test_Cases.Registration;
   begin
      Register_Routine (T, Test_Ray_Intersections'Access, "Object intersection tests");
   end Register_Tests;

   overriding function Name (T : Test) return AUnit.Message_String is
      pragma Unreferenced (T);
   begin
      return AUnit.Format ("Radatracer.Objects");
   end Name;
end Radatracer.Objects.Tests;
