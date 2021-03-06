with Ada.Text_IO;
with Radatracer.Images.IO;
with Radatracer.Matrices;
with Radatracer.Objects.Spheres;

--  Capstone project for Chapter 5

procedure Silhouette is
   use type Radatracer.Tuple;
   use type Radatracer.Value;
   use type Radatracer.Matrices.Matrix4;
   use type Radatracer.Objects.Intersections.Cursor;

   Ray_Origin : constant Radatracer.Point := Radatracer.Make_Point (0, 0, -5);

   Canvas_Pixels : constant := 1024;

   Wall_Z : constant Radatracer.Value := 10.0;
   Wall_Size : constant Radatracer.Value := 7.0;
   Half_Wall : constant Radatracer.Value := Wall_Size / 2.0;

   Pixel_Size : constant Radatracer.Value := Wall_Size / Radatracer.Value (Canvas_Pixels);

   World_X, World_Y : Radatracer.Value;

   Ray : Radatracer.Ray;
   Sphere : Radatracer.Objects.Spheres.Sphere := (
      Inverted_Transformation => Radatracer.Matrices.Invert (
         Radatracer.Matrices.Shearing (1.0, 0.0, 0.0, 0.0, 0.0, 0.0) * Radatracer.Matrices.Scaling (0.5, 1.0, 1.0)
      ),
      Material => <>
   );

   Hit : Radatracer.Objects.Intersections.Cursor;

   subtype Scene_Canvas is Radatracer.Images.Canvas (1 .. Canvas_Pixels, 1 .. Canvas_Pixels);
   type Scene_Canvas_Access is access Scene_Canvas;

   Canvas : constant Scene_Canvas_Access := new Scene_Canvas;
begin
   for Y in Canvas'Range (2) loop
      World_Y := Half_Wall - Pixel_Size * Radatracer.Value (Y);

      for X in Canvas'Range (1) loop
         World_X := -Half_Wall + Pixel_Size * Radatracer.Value (X);

         Ray := (
            Origin => Ray_Origin,
            Direction => Radatracer.Normalize (Radatracer.Make_Point (World_X, World_Y, Wall_Z) - Ray_Origin)
         );

         Hit := Radatracer.Objects.Hit (Sphere.Intersect (Ray));
         if Hit /= Radatracer.Objects.Intersections.No_Element then
            Canvas (X, Y) := Radatracer.Images.Red_Pixel;
         end if;
      end loop;
   end loop;

   Radatracer.Images.IO.Write_PPM (Ada.Text_IO.Standard_Output, Canvas.all);
end Silhouette;
