with Ada.Numerics;
with Ada.Text_IO;
with Radatracer.Canvas.IO;
with Radatracer.Matrices;
with Radatracer.Objects;

use type Radatracer.Matrices.Matrix4;
use type Radatracer.Objects.Sphere_Vectors.Vector;
use type Radatracer.Value;

procedure Scene is
   Floor : constant Radatracer.Objects.Sphere := (
      Inverted_Transformation => Radatracer.Matrices.Invert (Radatracer.Matrices.Scaling (10.0, 0.01, 10.0)),
      Material => (
         Color => Radatracer.Make_Color (1.0, 0.9, 0.9),
         Specular => 0.0,
         others => <>
      )
   );

   Left_Wall : constant Radatracer.Objects.Sphere := (
      Inverted_Transformation => Radatracer.Matrices.Invert (
         Radatracer.Matrices.Translation (0.0, 0.0, 5.0) *
         Radatracer.Matrices.Rotation_Y (Ada.Numerics.Pi / 4.0) *
         Radatracer.Matrices.Rotation_X (Ada.Numerics.Pi / 2.0) *
         Radatracer.Matrices.Scaling (10.0, 0.01, 10.0)
      ),
      Material => Floor.Material
   );

   Right_Wall : constant Radatracer.Objects.Sphere := (
      Inverted_Transformation => Radatracer.Matrices.Invert (
         Radatracer.Matrices.Translation (0.0, 0.0, 5.0) *
         Radatracer.Matrices.Rotation_Y (-Ada.Numerics.Pi / 4.0) *
         Radatracer.Matrices.Rotation_X (Ada.Numerics.Pi / 2.0) *
         Radatracer.Matrices.Scaling (10.0, 0.01, 10.0)
      ),
      Material => Floor.Material
   );

   Middle_Sphere : constant Radatracer.Objects.Sphere := (
      Inverted_Transformation => Radatracer.Matrices.Invert (Radatracer.Matrices.Translation (-0.5, 1.0, 0.5)),
      Material => (
         Color => Radatracer.Make_Color (0.1, 1.0, 0.5),
         Diffuse => 0.7,
         Specular => 0.3,
         others => <>
      )
   );

   Right_Sphere : constant Radatracer.Objects.Sphere := (
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

   Left_Sphere : constant Radatracer.Objects.Sphere := (
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
      Objects => Floor & Left_Wall & Right_Wall & Middle_Sphere & Right_Sphere & Left_Sphere
   );

   Camera : Radatracer.Objects.Camera := Radatracer.Objects.Make_Camera (1000, 500, Ada.Numerics.Pi / 3.0);

   Canvas : Radatracer.Canvas.Canvas (0 .. Camera.H_Size - 1, 0 .. Camera.V_Size - 1);
begin
   Radatracer.Objects.Set_Transformation (
      Camera,
      Radatracer.Matrices.View_Transform (Radatracer.Make_Point (0.0, 1.5, -5.0), Radatracer.Make_Point (0, 1, 0), Radatracer.Make_Vector (0, 1, 0))
   );

   Canvas := Radatracer.Objects.Render (Camera, World);

   Radatracer.Canvas.IO.Write_PPM (Ada.Text_IO.Standard_Output, Canvas);
end Scene;
