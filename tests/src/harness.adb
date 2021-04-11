with Ada.Command_Line;
with AUnit; use AUnit;
with AUnit.Reporter.Text;
with AUnit.Run;
with AUnit.Test_Cases;
with AUnit.Test_Suites;
with Radatracer.Canvas.IO.Tests;
with Radatracer.Matrices.Tests;
with Radatracer.Rays.Tests;
with Radatracer.Tests;

procedure Harness is
   function Radatracer_Test_Suite return AUnit.Test_Suites.Access_Test_Suite;
   function Radatracer_Test_Suite return AUnit.Test_Suites.Access_Test_Suite is
      Suite : constant AUnit.Test_Suites.Access_Test_Suite := new AUnit.Test_Suites.Test_Suite;
      Radatracer_Tests : constant AUnit.Test_Cases.Test_Case_Access := new Radatracer.Tests.Test;
      Canvas_Tests : constant AUnit.Test_Cases.Test_Case_Access := new Radatracer.Canvas.IO.Tests.Test;
      Matrices_Tests : constant AUnit.Test_Cases.Test_Case_Access := new Radatracer.Matrices.Tests.Test;
      Rays_Tests : constant AUnit.Test_Cases.Test_Case_Access := new Radatracer.Rays.Tests.Test;
   begin
      Suite.Add_Test (Radatracer_Tests);
      Suite.Add_Test (Canvas_Tests);
      Suite.Add_Test (Matrices_Tests);
      Suite.Add_Test (Rays_Tests);
      return Suite;
   end Radatracer_Test_Suite;

   function Runner is new AUnit.Run.Test_Runner_With_Status (Radatracer_Test_Suite);

   Result : AUnit.Status;
   Reporter : AUnit.Reporter.Text.Text_Reporter;
begin
   AUnit.Reporter.Text.Set_Use_ANSI_Colors (Reporter, True);

   Result := Runner (Reporter);

   if Result /= AUnit.Status'(Success) then
      Ada.Command_Line.Set_Exit_Status (1);
   end if;
end Harness;
