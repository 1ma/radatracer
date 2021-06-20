with AUnit.Assertions;

package body Radatracer.Objects.Patterns.Tests is
   procedure Test_Stripe_Patterns (T : in out AUnit.Test_Cases.Test_Case'Class);
   procedure Test_Stripe_Patterns (T : in out AUnit.Test_Cases.Test_Case'Class) is
      pragma Unreferenced (T);

      P : constant Stripe := (A => White, B => Black, others => <>);
   begin
      AUnit.Assertions.Assert (P.A = White and P.B = Black, "Creating a stripe pattern");

      AUnit.Assertions.Assert (Pattern_At (P, Make_Point (0, 0, 0)) = White, "A stripe pattern is constant in Y - part 1");
      AUnit.Assertions.Assert (Pattern_At (P, Make_Point (0, 1, 0)) = White, "A stripe pattern is constant in Y - part 2");
      AUnit.Assertions.Assert (Pattern_At (P, Make_Point (0, 2, 0)) = White, "A stripe pattern is constant in Y - part 3");

      AUnit.Assertions.Assert (Pattern_At (P, Make_Point (0, 0, 0)) = White, "A stripe pattern is constant in Z - part 1");
      AUnit.Assertions.Assert (Pattern_At (P, Make_Point (0, 0, 1)) = White, "A stripe pattern is constant in Z - part 2");
      AUnit.Assertions.Assert (Pattern_At (P, Make_Point (0, 0, 2)) = White, "A stripe pattern is constant in Z - part 3");

      AUnit.Assertions.Assert (Pattern_At (P, Make_Point (0, 0, 0)) = White, "A stripe pattern alternates in X - part 1");
      AUnit.Assertions.Assert (Pattern_At (P, Make_Point (0.9, 0.0, 0.0)) = White, "A stripe pattern alternates in X - part 2");
      AUnit.Assertions.Assert (Pattern_At (P, Make_Point (1, 0, 0)) = Black, "A stripe pattern alternates in X - part 3");
      AUnit.Assertions.Assert (Pattern_At (P, Make_Point (-0.1, 0.0, 0.0)) = Black, "A stripe pattern alternates in X - part 4");
      AUnit.Assertions.Assert (Pattern_At (P, Make_Point (-1, 0, 0)) = Black, "A stripe pattern alternates in X - part 5");
      AUnit.Assertions.Assert (Pattern_At (P, Make_Point (-1.1, 0.0, 0.0)) = White, "A stripe pattern alternates in X - part 6");
   end Test_Stripe_Patterns;

   overriding procedure Register_Tests (T : in out Test) is
      use AUnit.Test_Cases.Registration;
   begin
      Register_Routine (T, Test_Stripe_Patterns'Access, "Stripe pattern tests");
   end Register_Tests;

   overriding function Name (T : Test) return AUnit.Message_String is
      pragma Unreferenced (T);
   begin
      return AUnit.Format ("Radatracer.Objects.Patterns");
   end Name;
end Radatracer.Objects.Patterns.Tests;
