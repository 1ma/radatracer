package Radatracer.Canvas is
   pragma Pure;

   type Primary_Color is range 0 .. 16#FF#;
   for Primary_Color'Size use 8;

   type Pixel is record
      Red : Primary_Color := 0;
      Green : Primary_Color := 0;
      Blue : Primary_Color := 0;
   end record;

   type Canvas is array (Positive range <>, Positive range <>) of Pixel;

   function To_Pixel (T : Tuple) return Pixel;

   function Make_Canvas (Width, Height : Positive) return Canvas;
end Radatracer.Canvas;
