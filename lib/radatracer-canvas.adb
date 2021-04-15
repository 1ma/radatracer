package body Radatracer.Canvas is
   function Clamp (V, Min, Max : Value) return Value;

   function To_Pixel (T : Tuple) return Pixel is
      Max_Value : constant Float := Float (Primary_Color'Last);
      Red_Hue : constant Float := Float (Clamp (T.X, 0.0, 1.0));
      Green_Hue : constant Float := Float (Clamp (T.Y, 0.0, 1.0));
      Blue_Hue : constant Float := Float (Clamp (T.Z, 0.0, 1.0));
   begin
      return (
         Red => Primary_Color (Float'Rounding (Red_Hue * Max_Value)),
         Green => Primary_Color (Float'Rounding (Green_Hue * Max_Value)),
         Blue => Primary_Color (Float'Rounding (Blue_Hue * Max_Value))
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
end Radatracer.Canvas;
