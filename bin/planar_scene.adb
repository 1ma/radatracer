with Ada.Numerics;
with Ada.Text_IO;
with Radatracer.Canvas.IO;
with Radatracer.Matrices;
with Radatracer.Objects;

--  Capstone project for Chapter 9

procedure Planar_Scene is
   use type Radatracer.Matrices.Matrix4;
   use type Radatracer.Objects.Object_Vectors.Vector;
   use type Radatracer.Value;

   Floor : constant Radatracer.Objects.Object_Access := new Radatracer.Objects.Plane'(
      Inverted_Transformation => Radatracer.Matrices.Invert (
         Radatracer.Matrices.Rotation_Z (Ada.Numerics.Pi / 8.0)
      ),
      Material => (
         Color => Radatracer.Make_Color (1.0, 0.9, 0.9),
         Specular => 0.0,
         others => <>
      )
   );

   Middle_Sphere : constant Radatracer.Objects.Object_Access := new Radatracer.Objects.Sphere'(
      Inverted_Transformation => Radatracer.Matrices.Invert (
         Radatracer.Matrices.Translation (-0.5, 1.0, 0.5)
      ),
      Material => (
         Color => Radatracer.Make_Color (0.1, 1.0, 0.5),
         Diffuse => 0.7,
         Specular => 0.3,
         others => <>
      )
   );

   Right_Sphere : constant Radatracer.Objects.Object_Access := new Radatracer.Objects.Sphere'(
      Inverted_Transformation => Radatracer.Matrices.Invert (
         Radatracer.Matrices.Translation (1.5, 0.5, -0.5) *
         Radatracer.Matrices.Scaling (0.5, 0.5, 0.5)
      ),
      Material => (
         Color => Radatracer.Make_Color (0.5, 1.0, 0.1),
         Diffuse => 0.7,
         Specular => 0.3,
         others => <>
      )
   );

   Left_Sphere : constant Radatracer.Objects.Object_Access := new Radatracer.Objects.Sphere'(
      Inverted_Transformation => Radatracer.Matrices.Invert (
         Radatracer.Matrices.Translation (-1.5, 0.33, -0.75) *
         Radatracer.Matrices.Scaling (0.33, 0.33, 0.33)
      ),
      Material => (
         Color => Radatracer.Make_Color (1.0, 0.8, 0.1),
         Diffuse => 0.7,
         Specular => 0.3,
         others => <>
      )
   );

   World : constant Radatracer.Objects.World := (
      Light => (
         Intensity => Radatracer.Make_Color (1.0, 1.0, 1.0),
         Position => Radatracer.Make_Point (-10, 10, -10)
      ),
      Objects => Floor & Middle_Sphere & Right_Sphere & Left_Sphere
   );

   Camera : constant Radatracer.Objects.Camera := Radatracer.Objects.Make_Camera (
      2000, 1000,
      Ada.Numerics.Pi / 3.0,
      Radatracer.Make_Point (0.0, 1.5, -5.0),
      Radatracer.Make_Point (0, 1, 0),
      Radatracer.Make_Vector (0, 1, 0)
   );
begin
   Radatracer.Canvas.IO.Write_PPM (
      Ada.Text_IO.Standard_Output,
      Radatracer.Objects.Render (Camera, World)
   );
end Planar_Scene;