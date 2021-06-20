package body Radatracer.Objects.Patterns is
   overriding function Pattern_At (Self : Stripe; Point : Radatracer.Point) return Color is
   begin
      if Integer (Value'Floor (Point.X)) mod 2 = 0 then
         return Self.A;
      end if;

      return Self.B;
   end Pattern_At;

   overriding function Pattern_At (Self : Gradient; Point : Radatracer.Point) return Color is
      Distance : constant Vector := Self.B - Self.A;
      Fraction : constant Value := Point.X - Value'Floor (Point.X);
   begin
      return Self.A + (Distance * Fraction);
   end Pattern_At;
end Radatracer.Objects.Patterns;
