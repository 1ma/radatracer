package Radatracer.Objects.Patterns is
   type Stripe is new Pattern with record
       A, B : Color;
   end record;

   type Gradient is new Pattern with record
       A, B : Color;
   end record;

   overriding function Pattern_At (Self : Stripe; Point : Radatracer.Point) return Color;
   overriding function Pattern_At (Self : Gradient; Point : Radatracer.Point) return Color;
end Radatracer.Objects.Patterns;
