with AUnit.Test_Cases;

package Radatracer.Objects.Spheres.Tests is
   type Test is new AUnit.Test_Cases.Test_Case with null record;

   overriding procedure Register_Tests (T : in out Test);

   overriding function Name (T : Test) return AUnit.Message_String;
end Radatracer.Objects.Spheres.Tests;
