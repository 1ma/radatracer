package Radatracer.Canvas is
   pragma Pure;

   type Primary_Color is range 0 .. 16#FF#;
   for Primary_Color'Size use 8;

   type Pixel is record
      Red : Primary_Color := 0;
      Green : Primary_Color := 0;
      Blue : Primary_Color := 0;
   end record;

   function To_Pixel (T : Tuple) return Pixel;
end Radatracer.Canvas;
