package Radatracer.Canvas is
   pragma Pure;

   type Primary_Color is range 0 .. 16#FF#;
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

   function Make_Color (Red, Green, Blue : Value) return Tuple;

   function To_Pixel (T : Tuple) return Pixel;
end Radatracer.Canvas;
