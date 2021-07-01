package Radatracer.Objects.Spheres is
   type Sphere is new Object with null record;

   overriding function Local_Normal_At (Self : Sphere; Local_Point : Point) return Vector;

   overriding function Local_Intersect (Self : aliased in out Sphere; Local_Ray : Ray) return Intersections.Set;
end Radatracer.Objects.Spheres;
