with Ada.Command_Line;
with AUnit; use AUnit;
with AUnit.Reporter.Text;
with AUnit.Run;
with AUnit.Test_Cases;
with AUnit.Test_Suites;
with Basic.Tests;

procedure Harness is
   function La_Suite return AUnit.Test_Suites.Access_Test_Suite;
   function La_Suite return AUnit.Test_Suites.Access_Test_Suite is
      Suite : constant AUnit.Test_Suites.Access_Test_Suite := new AUnit.Test_Suites.Test_Suite;
      Basic_Tests : constant AUnit.Test_Cases.Test_Case_Access := new Basic.Tests.Test;
   begin
      Suite.Add_Test (Basic_Tests);
      return Suite;
   end La_Suite;

   function Runner is new AUnit.Run.Test_Runner_With_Status (La_Suite);

   Result : AUnit.Status;
   Reporter : AUnit.Reporter.Text.Text_Reporter;
begin
   Result := Runner (Reporter);

   if Result /= AUnit.Status'(Success) then
      Ada.Command_Line.Set_Exit_Status (1);
   end if;
end Harness;
