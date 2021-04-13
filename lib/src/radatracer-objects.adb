with Ada.Numerics.Generic_Elementary_Functions;

package body Radatracer.Objects is
   function Hit (IA : Intersection_Array) return Integer is
   begin
      return IA'First;
   end Hit;

   function Intersect (S : aliased Sphere; R : Ray) return Intersection_Array is
      Sphere_Ray_Vector : constant Tuple := R.Origin - S.Origin;

      A : constant Value := 2.0 * Dot_Product (R.Direction, R.Direction);
      B : constant Value := 2.0 * Dot_Product (R.Direction, Sphere_Ray_Vector);
      C : constant Value := Dot_Product (Sphere_Ray_Vector, Sphere_Ray_Vector) - 1.0;

      Discriminant : constant Value := (B * B) - (2.0 * A * C);
   begin
      if Discriminant < 0.0 then
         declare
            Empty_Result : constant Intersection_Array (1 .. 0) := (others => <>);
         begin
            return Empty_Result;
         end;
      end if;

      declare
         package Math is new Ada.Numerics.Generic_Elementary_Functions (Value);

         Normal_Result : constant Intersection_Array := (
            (T_Value => (-B - Math.Sqrt (Discriminant)) / A, Object => S'Access),
            (T_Value => (-B + Math.Sqrt (Discriminant)) / A, Object => S'Access)
         );
      begin
         return Normal_Result;
      end;
   end Intersect;
end Radatracer.Objects;
