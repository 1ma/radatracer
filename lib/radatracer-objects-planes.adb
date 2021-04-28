package body Radatracer.Objects.Planes is
   overriding function Local_Normal_At (Self : Plane; Local_Point : Point) return Vector is
      pragma Unreferenced (Self, Local_Point);
   begin
      return Make_Vector (0, 1, 0);
   end Local_Normal_At;

   overriding function Local_Intersect (Self : aliased in out Plane; Local_Ray : Radatracer.Ray) return Intersection_Vectors.Vector is
      Result : Intersection_Vectors.Vector;
   begin
      if Local_Ray.Direction.Y = 0.0 then
         return Result;
      end if;

      Result.Append ((T_Value => -Local_Ray.Origin.Y / Local_Ray.Direction.Y, Object => Self'Access));

      return Result;
   end Local_Intersect;
end Radatracer.Objects.Planes;
