package body Radatracer.Canvas is
   function To_Pixel (T : Tuple) return Pixel is
      Max_Value : constant Float := Float (Primary_Color'Last);

      Red_Hue : constant Float := Float (Value'Min (1.0, Value'Max (0.0, T.X)));
      Green_Hue : constant Float := Float (Value'Min (1.0, Value'Max (0.0, T.Y)));
      Blue_Hue : constant Float := Float (Value'Min (1.0, Value'Max (0.0, T.Z)));

      Result : constant Pixel := (
         Red => Primary_Color (Float'Rounding (Red_Hue * Max_Value)),
         Green => Primary_Color (Float'Rounding (Green_Hue * Max_Value)),
         Blue => Primary_Color (Float'Rounding (Blue_Hue * Max_Value))
      );
   begin
      return Result;
   end To_Pixel;

   function Make_Canvas (Width, Height : Positive) return Canvas is
      Black_Pixel : constant Pixel := (Red => 0, Green => 0, Blue => 0);
      Result : constant Canvas (1 .. Width, 1 .. Height) := (others => (others => Black_Pixel));
   begin
      return Result;
   end Make_Canvas;
end Radatracer.Canvas;
