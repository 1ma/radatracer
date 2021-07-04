with AUnit.Assertions;
with Radatracer.Objects.Spheres;

package body Radatracer.Objects.Patterns.Tests is
   type Test_Pattern is new Pattern with null record;

   overriding function Pattern_At (Self : Test_Pattern; Point : Radatracer.Point) return Color;
   overriding function Pattern_At (Self : Test_Pattern; Point : Radatracer.Point) return Color is
      pragma Unreferenced (Self);
   begin
      return Make_Color (Red => Point.X, Green => Point.Y, Blue => Point.Z);
   end Pattern_At;

   procedure Test_Stripe_Patterns (T : in out AUnit.Test_Cases.Test_Case'Class);
   procedure Test_Stripe_Patterns (T : in out AUnit.Test_Cases.Test_Case'Class) is
      pragma Unreferenced (T);

      P : constant Stripe := (A => White, B => Black, others => <>);
   begin
      AUnit.Assertions.Assert (P.A = White and P.B = Black, "Creating a stripe pattern");

      AUnit.Assertions.Assert (Pattern_At (P, Origin) = White, "A stripe pattern is constant in Y - part 1");
      AUnit.Assertions.Assert (Pattern_At (P, Make_Point (0, 1, 0)) = White, "A stripe pattern is constant in Y - part 2");
      AUnit.Assertions.Assert (Pattern_At (P, Make_Point (0, 2, 0)) = White, "A stripe pattern is constant in Y - part 3");

      AUnit.Assertions.Assert (Pattern_At (P, Origin) = White, "A stripe pattern is constant in Z - part 1");
      AUnit.Assertions.Assert (Pattern_At (P, Make_Point (0, 0, 1)) = White, "A stripe pattern is constant in Z - part 2");
      AUnit.Assertions.Assert (Pattern_At (P, Make_Point (0, 0, 2)) = White, "A stripe pattern is constant in Z - part 3");

      AUnit.Assertions.Assert (Pattern_At (P, Origin) = White, "A stripe pattern alternates in X - part 1");
      AUnit.Assertions.Assert (Pattern_At (P, Make_Point (0.9, 0.0, 0.0)) = White, "A stripe pattern alternates in X - part 2");
      AUnit.Assertions.Assert (Pattern_At (P, Make_Point (1, 0, 0)) = Black, "A stripe pattern alternates in X - part 3");
      AUnit.Assertions.Assert (Pattern_At (P, Make_Point (-0.1, 0.0, 0.0)) = Black, "A stripe pattern alternates in X - part 4");
      AUnit.Assertions.Assert (Pattern_At (P, Make_Point (-1, 0, 0)) = Black, "A stripe pattern alternates in X - part 5");
      AUnit.Assertions.Assert (Pattern_At (P, Make_Point (-1.1, 0.0, 0.0)) = White, "A stripe pattern alternates in X - part 6");
   end Test_Stripe_Patterns;

   procedure Test_Generalized_Patterns (T : in out AUnit.Test_Cases.Test_Case'Class);
   procedure Test_Generalized_Patterns (T : in out AUnit.Test_Cases.Test_Case'Class) is
      pragma Unreferenced (T);

      Plain_Pattern : constant Test_Pattern := (others => <>);
      Plain_Sphere : constant Radatracer.Objects.Spheres.Sphere := (others => <>);

      Scaled_Pattern : constant Test_Pattern := (
         Inverted_Transformation => Radatracer.Matrices.Invert (Radatracer.Matrices.Scaling (2.0, 2.0, 2.0))
      );
      Scaled_Sphere : constant Radatracer.Objects.Spheres.Sphere := (
         Inverted_Transformation => Radatracer.Matrices.Invert (Radatracer.Matrices.Scaling (2.0, 2.0, 2.0)),
         others => <>
      );
      Translated_Pattern : constant Test_Pattern := (
         Inverted_Transformation => Radatracer.Matrices.Invert (Radatracer.Matrices.Translation (0.5, 1.0, 1.5))
      );
   begin
      AUnit.Assertions.Assert (
         Pattern_At_Object (Plain_Pattern, Scaled_Sphere, Make_Point (2, 3, 4)) = Make_Color (1.0, 1.5, 2.0),
         "A pattern with an object transformation"
      );

      AUnit.Assertions.Assert (
         Pattern_At_Object (Scaled_Pattern, Plain_Sphere, Make_Point (2, 3, 4)) = Make_Color (1.0, 1.5, 2.0),
         "A pattern with a pattern transformation"
      );

      AUnit.Assertions.Assert (
         Pattern_At_Object (Translated_Pattern, Scaled_Sphere, Make_Point (2.5, 3.0, 3.5)) = Make_Color (0.75, 0.5, 0.25),
         "A pattern with both an object and a pattern transformation"
      );
   end Test_Generalized_Patterns;

   procedure Test_Gradient_Pattern (T : in out AUnit.Test_Cases.Test_Case'Class);
   procedure Test_Gradient_Pattern (T : in out AUnit.Test_Cases.Test_Case'Class) is
      pragma Unreferenced (T);

      Gradient : constant Radatracer.Objects.Patterns.Gradient := (A => White, B => Black, others => <>);
   begin
      AUnit.Assertions.Assert (
         Pattern_At (Gradient, Origin) = White,
         "A gradient linearly interpolates between colors - part 1"
      );

      AUnit.Assertions.Assert (
         Pattern_At (Gradient, Make_Point (0.25, 0.0, 0.0)) = Make_Color (0.75, 0.75, 0.75),
         "A gradient linearly interpolates between colors - part 2"
      );

      AUnit.Assertions.Assert (
         Pattern_At (Gradient, Make_Point (0.5, 0.0, 0.0)) = Make_Color (0.5, 0.5, 0.5),
         "A gradient linearly interpolates between colors - part 3"
      );

      AUnit.Assertions.Assert (
         Pattern_At (Gradient, Make_Point (0.75, 0.0, 0.0)) = Make_Color (0.25, 0.25, 0.25),
         "A gradient linearly interpolates between colors - part 4"
      );
   end Test_Gradient_Pattern;

   procedure Test_Ring_Pattern (T : in out AUnit.Test_Cases.Test_Case'Class);
   procedure Test_Ring_Pattern (T : in out AUnit.Test_Cases.Test_Case'Class) is
      pragma Unreferenced (T);

      Ring : constant Radatracer.Objects.Patterns.Ring := (A => White, B => Black, others => <>);
   begin
      AUnit.Assertions.Assert (Pattern_At (Ring, Origin) = White, "A ring should extend in both X and Z - part 1");
      AUnit.Assertions.Assert (Pattern_At (Ring, Make_Point (1, 0, 0)) = Black, "A ring should extend in both X and Z - part 2");
      AUnit.Assertions.Assert (Pattern_At (Ring, Make_Point (0, 0, 1)) = Black, "A ring should extend in both X and Z - part 3");
      AUnit.Assertions.Assert (Pattern_At (Ring, Make_Point (0.708, 0.0, 0.708)) = Black, "A ring should extend in both X and Z - part 4");
   end Test_Ring_Pattern;

   procedure Test_Checker_Pattern (T : in out AUnit.Test_Cases.Test_Case'Class);
   procedure Test_Checker_Pattern (T : in out AUnit.Test_Cases.Test_Case'Class) is
      pragma Unreferenced (T);

      Checker : constant Radatracer.Objects.Patterns.Checkers := (A => White, B => Black, others => <>);
   begin
      AUnit.Assertions.Assert (Pattern_At (Checker, Origin) = White, "Checkers should repeat in X - part 1");
      AUnit.Assertions.Assert (Pattern_At (Checker, Make_Point (0.99, 0.0, 0.0)) = White, "Checkers should repeat in X - part 2");
      AUnit.Assertions.Assert (Pattern_At (Checker, Make_Point (1.01, 0.0, 0.0)) = Black, "Checkers should repeat in X - part 3");

      AUnit.Assertions.Assert (Pattern_At (Checker, Origin) = White, "Checkers should repeat in Y - part 1");
      AUnit.Assertions.Assert (Pattern_At (Checker, Make_Point (0.0, 0.99, 0.0)) = White, "Checkers should repeat in Y - part 2");
      AUnit.Assertions.Assert (Pattern_At (Checker, Make_Point (0.0, 1.01, 0.0)) = Black, "Checkers should repeat in Y - part 3");

      AUnit.Assertions.Assert (Pattern_At (Checker, Origin) = White, "Checkers should repeat in Z - part 1");
      AUnit.Assertions.Assert (Pattern_At (Checker, Make_Point (0.0, 0.0, 0.99)) = White, "Checkers should repeat in Z - part 2");
      AUnit.Assertions.Assert (Pattern_At (Checker, Make_Point (0.0, 0.0, 1.01)) = Black, "Checkers should repeat in Z - part 3");

   end Test_Checker_Pattern;

   overriding procedure Register_Tests (T : in out Test) is
      use AUnit.Test_Cases.Registration;
   begin
      Register_Routine (T, Test_Stripe_Patterns'Access, "Stripe pattern tests");
      Register_Routine (T, Test_Generalized_Patterns'Access, "Generalized patterns tests");
      Register_Routine (T, Test_Gradient_Pattern'Access, "Gradient pattern tests");
      Register_Routine (T, Test_Ring_Pattern'Access, "Ring pattern tests");
      Register_Routine (T, Test_Checker_Pattern'Access, "Checker pattern tests");
   end Register_Tests;

   overriding function Name (T : Test) return AUnit.Message_String is
      pragma Unreferenced (T);
   begin
      return AUnit.Format ("Radatracer.Objects.Patterns");
   end Name;
end Radatracer.Objects.Patterns.Tests;
