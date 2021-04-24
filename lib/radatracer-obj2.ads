with Radatracer.Matrices;

--  OOP version of Radatracer.Objects to eventually replace it.

package Radatracer.Obj2 is
   type Material is record
      Color : Radatracer.Color := Make_Color (1.0, 1.0, 1.0);
      Ambient : Value := 0.1;
      Diffuse : Value := 0.9;
      Specular : Value := 0.9;
      Shininess : Value := 200.0;
   end record;

   type Object is abstract tagged record
      Inverted_Transformation : Radatracer.Matrices.Matrix4 := Radatracer.Matrices.Identity_Matrix4;
      Material : Radatracer.Obj2.Material;
   end record;

   function Normal_At (Self : Object; World_Point : Point) return Vector is abstract
      with Post'Class => Magnitude (Normal_At'Result) = 1.0;

   type Sphere is new Object with null record;

   overriding function Normal_At (Self : Sphere; World_Point : Point) return Vector;
end Radatracer.Obj2;
