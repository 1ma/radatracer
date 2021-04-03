with Basic;

package Canvas is
   pragma Pure;

   type Primary_Color is range 0 .. 255;
   for Primary_Color'Size use 8;

   type Pixel is record
      Red : Primary_Color;
      Green : Primary_Color;
      Blue : Primary_Color;
   end record;

   function To_Pixel (T : Basic.Tuple) return Pixel;
end Canvas;
