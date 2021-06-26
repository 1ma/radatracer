package body Radatracer.Images is
   function Clamp (V, Min, Max : Value) return Value;

   Max_Pixel_Value : constant Value := Value (Primary_Color'Last);

   function To_Pixel (C : Color) return Pixel is
      Red_Hue : constant Value := Clamp (C.X, 0.0, 1.0);
      Green_Hue : constant Value := Clamp (C.Y, 0.0, 1.0);
      Blue_Hue : constant Value := Clamp (C.Z, 0.0, 1.0);
   begin
      return (
         Red => Primary_Color (Value'Rounding (Red_Hue * Max_Pixel_Value)),
         Green => Primary_Color (Value'Rounding (Green_Hue * Max_Pixel_Value)),
         Blue => Primary_Color (Value'Rounding (Blue_Hue * Max_Pixel_Value))
      );
   end To_Pixel;

   function Clamp (V, Min, Max : Value) return Value is
   begin
      if V < Min then
         return Min;
      end if;

      if V > Max then
         return Max;
      end if;

      return V;
   end Clamp;
end Radatracer.Images;
