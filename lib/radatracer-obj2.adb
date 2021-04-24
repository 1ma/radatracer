package body Radatracer.Obj2 is
   overriding function Normal_At (Self : Sphere; World_Point : Point) return Vector is
      use type Radatracer.Matrices.Matrix4;

      Object_Origin : constant Point := Make_Point (0, 0, 0);
      Object_Point : constant Point := Self.Inverted_Transformation * World_Point;
      Object_Normal : constant Vector := Object_Point - Object_Origin;
      World_Normal : Tuple := Radatracer.Matrices.Transpose (Self.Inverted_Transformation) * Object_Normal;
   begin
      World_Normal.W := 0.0;
      return Normalize (Vector (World_Normal));
   end Normal_At;
end Radatracer.Obj2;
