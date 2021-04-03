package body Canvas is
   function To_Pixel (T : Basic.Tuple) return Pixel is
      Max_Value : constant Float := Float (Primary_Color'Last);

      R : constant Float := Float (Basic.Value'Min (1.0, Basic.Value'Max (0.0, T.X)));
      G : constant Float := Float (Basic.Value'Min (1.0, Basic.Value'Max (0.0, T.Y)));
      B : constant Float := Float (Basic.Value'Min (1.0, Basic.Value'Max (0.0, T.Z)));

      P : constant Pixel := (
         Red => Primary_Color (Float'Rounding (R * Max_Value)),
         Green => Primary_Color (Float'Rounding (G * Max_Value)),
         Blue => Primary_Color (Float'Rounding (B * Max_Value))
      );
   begin
      return P;
   end To_Pixel;
end Canvas;
