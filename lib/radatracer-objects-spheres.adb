with Ada.Numerics.Generic_Elementary_Functions;

package body Radatracer.Objects.Spheres is
   overriding function Local_Normal_At (Self : Sphere; Local_Point : Point) return Vector is
      pragma Unreferenced (Self);

      Local_Sphere_Origin : constant Point := Make_Point (0, 0, 0);
   begin
      return Local_Point - Local_Sphere_Origin;
   end Local_Normal_At;

   overriding function Local_Intersect (Self : aliased in out Sphere; Local_Ray : Ray) return Intersections.Set is
      package Math is new Ada.Numerics.Generic_Elementary_Functions (Value);

      Sphere_Origin : constant Point := Make_Point (0, 0, 0);
      Sphere_Ray_Vector : constant Vector := Local_Ray.Origin - Sphere_Origin;

      A : constant Value := 2.0 * Dot_Product (Local_Ray.Direction, Local_Ray.Direction);
      B : constant Value := 2.0 * Dot_Product (Local_Ray.Direction, Sphere_Ray_Vector);
      C : constant Value := Dot_Product (Sphere_Ray_Vector, Sphere_Ray_Vector) - 1.0;

      Discriminant : constant Value := (B * B) - (2.0 * A * C);

      Result : Intersections.Set;
   begin
      if Discriminant >= 0.0 then
         Result.Include ((T_Value => (-B - Math.Sqrt (Discriminant)) / A, Object => Self'Access));
         Result.Include ((T_Value => (-B + Math.Sqrt (Discriminant)) / A, Object => Self'Access));
      end if;

      return Result;
   end Local_Intersect;
end Radatracer.Objects.Spheres;
