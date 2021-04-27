with Ada.Text_IO;
with Radatracer.Canvas.IO;
with Radatracer.Objects2;

--  Capstone project for Chapter 6

procedure Phong is
   use type Radatracer.Tuple;
   use type Radatracer.Value;
   use type Radatracer.Objects2.Intersection_Vectors.Cursor;

   Ray_Origin : constant Radatracer.Point := Radatracer.Make_Point (0, 0, -5);

   Canvas_Pixels : constant := 1024;

   Wall_Z : constant Radatracer.Value := 10.0;
   Wall_Size : constant Radatracer.Value := 7.0;
   Half_Wall : constant Radatracer.Value := Wall_Size / 2.0;

   Pixel_Size : constant Radatracer.Value := Wall_Size / Radatracer.Value (Canvas_Pixels);

   Light : constant Radatracer.Objects2.Point_Light := (
      Position => Radatracer.Make_Point (-10, 10, -10),
      Intensity => Radatracer.Make_Color (1.0, 1.0, 1.0)
   );

   Sphere : Radatracer.Objects2.Sphere := (
      Inverted_Transformation => <>,
      Material => (Color => Radatracer.Make_Color (1.0, 0.0, 0.0), others => <>)
   );

   Hit : Radatracer.Objects2.Intersection_Vectors.Cursor;
   Intersections : Radatracer.Objects2.Intersection_Vectors.Vector;
   Ray : Radatracer.Ray;
   World_X, World_Y : Radatracer.Value;
   Point : Radatracer.Point := Radatracer.Make_Point (0, 0, 0);
   Normal_Vector, Eye_Vector : Radatracer.Vector := Radatracer.Make_Vector (0, 0, 0);

   subtype Scene_Canvas is Radatracer.Canvas.Canvas (1 .. Canvas_Pixels, 1 .. Canvas_Pixels);
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

         Intersections := Radatracer.Objects2.Intersect (Sphere, Ray);
         Hit := Radatracer.Objects2.Hit (Intersections);
         if Hit /= Radatracer.Objects2.Intersection_Vectors.No_Element then
            Point := Radatracer.Position (Ray, Intersections (Hit).T_Value);
            Normal_Vector := Intersections (Hit).Object.all.Normal_At (Point);
            Eye_Vector := -Ray.Direction;

            Canvas (X, Y) := Radatracer.Canvas.To_Pixel (
               Radatracer.Objects2.Lightning (Intersections (Hit).Object.Material, Light, Point, Eye_Vector, Normal_Vector)
            );
         end if;
      end loop;
   end loop;

   Radatracer.Canvas.IO.Write_PPM (Ada.Text_IO.Standard_Output, Canvas.all);
end Phong;
