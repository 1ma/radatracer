package Radatracer.Objects.Patterns is
   type Stripe is new Pattern with record
       A, B : Color;
   end record;

   overriding function Pattern_At (Self : Stripe; Point : Radatracer.Point) return Color;
end Radatracer.Objects.Patterns;
