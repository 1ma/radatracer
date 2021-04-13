with Ada.Numerics;
with AUnit.Assertions;

package body Radatracer.Rays.Tests is
   procedure Test_Ray_Intersections (T : in out AUnit.Test_Cases.Test_Case'Class);
   procedure Test_Ray_Intersections (T : in out AUnit.Test_Cases.Test_Case'Class) is
      S : constant Sphere := (others => <>);

      R1 : constant Ray := (Origin => Make_Point (0, 0, -5), Direction => Make_Vector (0, 0, 1));
      R2 : constant Ray := (Origin => Make_Point (0, 1, -5), Direction => Make_Vector (0, 0, 1));
      R3 : constant Ray := (Origin => Make_Point (0, 2, -5), Direction => Make_Vector (0, 0, 1));
      R4 : constant Ray := (Origin => Make_Point (0, 0, 0), Direction => Make_Vector (0, 0, 1));
      R5 : constant Ray := (Origin => Make_Point (0, 0, 5), Direction => Make_Vector (0, 0, 1));
      I1 : constant Value_Array := (4.0, 6.0);
      I2 : constant Value_Array := (5.0, 5.0);
      I3 : constant Value_Array (1 .. 0) := (others => <>);
      I4 : constant Value_Array := (-1.0, 1.0);
      I5 : constant Value_Array := (-6.0, -4.0);
   begin
      AUnit.Assertions.Assert (Intersect (S, R1) = I1, "Ray-Sphere intersection test 1 - intersection at 2 points");
      AUnit.Assertions.Assert (Intersect (S, R2) = I2, "Ray-Sphere intersection test 2 - intersection at 1 point (tangent point)");
      AUnit.Assertions.Assert (Intersect (S, R3) = I3, "Ray-Sphere intersection test 3 - no intersection");
      AUnit.Assertions.Assert (Intersect (S, R4) = I4, "Ray-Sphere intersection test 4 - ray originates inside the sphere");
      AUnit.Assertions.Assert (Intersect (S, R5) = I5, "Ray-Sphere intersection test 5 - sphere is behind the ray");
   end Test_Ray_Intersections;

   overriding procedure Register_Tests (T : in out Test) is
      use AUnit.Test_Cases.Registration;
   begin
      Register_Routine (T, Test_Ray_Intersections'Access, "Ray intersections tests");
   end Register_Tests;

   overriding function Name (T : Test) return AUnit.Message_String is
      pragma Unreferenced (T);
   begin
      return AUnit.Format ("Radatracer.Rays");
   end Name;
end Radatracer.Rays.Tests;
