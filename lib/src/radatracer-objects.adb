with Ada.Numerics.Generic_Elementary_Functions;

package body Radatracer.Objects is
   function Hit (Intersections : Intersection_Vectors.Vector) return Integer is
      pragma Unreferenced (Intersections);
   begin
      return -1;
   end Hit;

   function Intersect (S : Sphere; R : Ray) return Intersection_Vectors.Vector is
      package Math is new Ada.Numerics.Generic_Elementary_Functions (Value);
      Result : Intersection_Vectors.Vector;

      Sphere_Ray_Vector : constant Tuple := R.Origin - S.Origin;
      A : constant Value := 2.0 * Dot_Product (R.Direction, R.Direction);
      B : constant Value := 2.0 * Dot_Product (R.Direction, Sphere_Ray_Vector);
      C : constant Value := Dot_Product (Sphere_Ray_Vector, Sphere_Ray_Vector) - 1.0;
      Discriminant : constant Value := (B * B) - (2.0 * A * C);
   begin
      if Discriminant >= 0.0 then
         Result.Append ((T_Value => (-B - Math.Sqrt (Discriminant)) / A, Object => S));
         Result.Append ((T_Value => (-B + Math.Sqrt (Discriminant)) / A, Object => S));
      end if;

      return Result;
   end Intersect;
end Radatracer.Objects;
