package Radatracer.Objects.Planes is
   type Plane is new Object with null record;

   overriding function Local_Normal_At (Self : Plane; Local_Point : Point) return Vector;

   overriding function Local_Intersect (Self : aliased in out Plane; Local_Ray : Ray) return Intersection_Vectors.Vector;
end Radatracer.Objects.Planes;
