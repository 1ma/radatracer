package body Canvas is
   function To_Pixel (T : Basic.Tuple) return Pixel is
      Max_Value : constant Float := Float (Primary_Color'Last);

      Red_Hue : constant Float := Float (Basic.Value'Min (1.0, Basic.Value'Max (0.0, T.X)));
      Green_Hue : constant Float := Float (Basic.Value'Min (1.0, Basic.Value'Max (0.0, T.Y)));
      Blue_Hue : constant Float := Float (Basic.Value'Min (1.0, Basic.Value'Max (0.0, T.Z)));

      Result : constant Pixel := (
         Red => Primary_Color (Float'Rounding (Red_Hue * Max_Value)),
         Green => Primary_Color (Float'Rounding (Green_Hue * Max_Value)),
         Blue => Primary_Color (Float'Rounding (Blue_Hue * Max_Value))
      );
   begin
      return Result;
   end To_Pixel;
end Canvas;
