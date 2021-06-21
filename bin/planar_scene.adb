with Ada.Numerics;
with Ada.Text_IO;
with Radatracer.Canvas.IO;
with Radatracer.Matrices;
with Radatracer.Objects.Patterns;
with Radatracer.Objects.Planes;
with Radatracer.Objects.Spheres;

--  Capstone project for Chapter 9

procedure Planar_Scene is
   use type Radatracer.Matrices.Matrix4;
   use type Radatracer.Objects.Object_Vectors.Vector;
   use type Radatracer.Value;

   Floor : constant Radatracer.Objects.Object_Access := new Radatracer.Objects.Planes.Plane'(
      Inverted_Transformation => Radatracer.Matrices.Identity_Matrix4,
      Material => (
         Has_Pattern => True,
         Pattern => new Radatracer.Objects.Patterns.Checkers'(
            A => Radatracer.White,
            B => Radatracer.Make_Color (0.5, 0.5, 0.5),
            others => <>
         ),
         Specular => 0.0,
         others => <>
      )
   );

   Wall : constant Radatracer.Objects.Object_Access := new Radatracer.Objects.Planes.Plane'(
      Inverted_Transformation => Radatracer.Matrices.Invert (
         Radatracer.Matrices.Translation (0.0, 0.0, 5.0) *
         Radatracer.Matrices.Rotation_X (Ada.Numerics.Pi / 2.0)
      ),
      Material => (
         Has_Pattern => True,
         Pattern => new Radatracer.Objects.Patterns.Stripe'(
            A => Radatracer.White,
            B => Radatracer.Make_Color (0.5, 0.5, 0.5),
            Inverted_Transformation => Radatracer.Matrices.Invert (
               Radatracer.Matrices.Rotation_Y (Ada.Numerics.Pi / 4.0)
            )
         ),
         Specular => 0.0,
         others => <>
      )
   );

   Middle_Sphere : constant Radatracer.Objects.Object_Access := new Radatracer.Objects.Spheres.Sphere'(
      Inverted_Transformation => Radatracer.Matrices.Invert (
         Radatracer.Matrices.Translation (-0.5, 1.0, 0.5)
      ),
      Material => (
         Has_Pattern => True,
         Pattern => new Radatracer.Objects.Patterns.Gradient'(
            A => Radatracer.Make_Color (0.1, 1.0, 0.8),
            B => Radatracer.Make_Color (0.6, 0.1, 0.8),
            Inverted_Transformation => Radatracer.Matrices.Invert (
               Radatracer.Matrices.Scaling (2.0, 2.0, 2.0) *
               Radatracer.Matrices.Translation (-0.5, 0.0, 0.0)
            )
         ),
         Diffuse => 0.7,
         Specular => 0.3,
         others => <>
      )
   );

   Right_Sphere : constant Radatracer.Objects.Object_Access := new Radatracer.Objects.Spheres.Sphere'(
      Inverted_Transformation => Radatracer.Matrices.Invert (
         Radatracer.Matrices.Translation (1.5, 0.5, -0.5) *
         Radatracer.Matrices.Scaling (0.5, 0.5, 0.5)
      ),
      Material => (
         Has_Pattern => True,
         Pattern => new Radatracer.Objects.Patterns.Stripe'(
            A => Radatracer.Make_Color (0.5, 1.0, 0.1),
            B => Radatracer.Make_Color (0.5, 0.7, 0.1),
            Inverted_Transformation => Radatracer.Matrices.Invert (
               Radatracer.Matrices.Scaling (0.2, 0.2, 0.2) *
               Radatracer.Matrices.Rotation_Y (Ada.Numerics.Pi / 8.0)
            )
         ),
         Diffuse => 0.7,
         Specular => 0.3,
         others => <>
      )
   );

   Left_Sphere : constant Radatracer.Objects.Object_Access := new Radatracer.Objects.Spheres.Sphere'(
      Inverted_Transformation => Radatracer.Matrices.Invert (
         Radatracer.Matrices.Translation (-1.5, 0.33, -0.75) *
         Radatracer.Matrices.Scaling (0.33, 0.33, 0.33)
      ),
      Material => (
         Has_Pattern => True,
         Pattern => new Radatracer.Objects.Patterns.Ring'(
            A => Radatracer.Make_Color (1.0, 0.8, 0.1),
            B => Radatracer.Make_Color (1.0, 0.4, 0.2),
            Inverted_Transformation => Radatracer.Matrices.Invert (
               Radatracer.Matrices.Scaling (0.11, 0.11, 0.11) *
               Radatracer.Matrices.Rotation_Y (Ada.Numerics.Pi / 8.0) *
               Radatracer.Matrices.Rotation_Z (-Ada.Numerics.Pi / 8.0)
            )
         ),
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
      Objects => Floor & Wall & Middle_Sphere & Right_Sphere & Left_Sphere
   );

   Camera : constant Radatracer.Objects.Camera := Radatracer.Objects.Make_Camera (
      1920, 1080,
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
