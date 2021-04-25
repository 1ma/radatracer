package body Radatracer.Objects2 is
   procedure Set_Transformation (Self : in out Object; Transformation : Radatracer.Matrices.Matrix4) is
   begin
      Self.Inverted_Transformation := Radatracer.Matrices.Invert (Transformation);
   end Set_Transformation;

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
end Radatracer.Objects2;
