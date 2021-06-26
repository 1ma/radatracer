package Radatracer.Images is
   pragma Pure;

   type Primary_Color is range 0 .. 255;
   for Primary_Color'Size use 8;

   type Pixel is record
      Red : Primary_Color := 0;
      Green : Primary_Color := 0;
      Blue : Primary_Color := 0;
   end record;

   Red_Pixel : constant Pixel := (255, 0, 0);
   Green_Pixel : constant Pixel := (0, 255, 0);
   Blue_Pixel : constant Pixel := (0, 0, 255);

   type Canvas is array (Natural range <>, Natural range <>) of Pixel;

   function To_Pixel (C : Color) return Pixel;
end Radatracer.Images;
