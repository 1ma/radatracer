with Ada.Numerics.Generic_Elementary_Functions;

package body Radatracer.Rays is
   function Position (R : Ray; T : Value) return Tuple is
   begin
      return R.Origin + R.Direction * T;
   end Position;

   function Intersect (S : Sphere; R : Ray) return Value_Vectors.Vector is
      package Math is new Ada.Numerics.Generic_Elementary_Functions (Value);

      Sphere_To_Ray : constant Tuple := S.Origin - Make_Point (0.0, 0.0, 0.0);
      A : constant Value := Dot_Product (R.Direction, R.Direction);
      B : constant Value := 2.0 * Dot_Product (R.Direction, Sphere_To_Ray);
      C : constant Value := Dot_Product (Sphere_To_Ray, Sphere_To_Ray);
      Discriminant : constant Value := (B * B) - (4.0 * A * C);
      Result : Value_Vectors.Vector;
   begin
      if Discriminant >= 0.0 then
         Result.Append ((-B - Math.Sqrt (Discriminant)) / (2.0 * A));
         Result.Append ((-B + Math.Sqrt (Discriminant)) / (2.0 * A));
      end if;

      return Result;
   end Intersect;
end Radatracer.Rays;
