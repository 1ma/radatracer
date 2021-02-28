with AUnit.Assertions;
with Basic;

package body Basic.Tests is
   procedure Test_Tuple_Creation (T : in out AUnit.Test_Cases.Test_Case'Class);
   procedure Test_Tuple_Creation (T : in out AUnit.Test_Cases.Test_Case'Class) is
      pragma Unreferenced (T);
      P : constant Tuple := Basic.New_Point (4.0, -4.0, 3.0);
      V : constant Tuple := Basic.New_Vector (4.0, -4.0, 3.0);
   begin
      AUnit.Assertions.Assert (P.W = 1.0, "A Point's W component is 1");
      AUnit.Assertions.Assert (V.W = 0.0, "A Vector's W component is 0");
   end Test_Tuple_Creation;

   procedure Test_Tuple_Comparison (T : in out AUnit.Test_Cases.Test_Case'Class);
   procedure Test_Tuple_Comparison (T : in out AUnit.Test_Cases.Test_Case'Class) is
      pragma Unreferenced (T);
      A : constant Tuple := (1.0, 2.0, 3.0, 0.0);
      B : constant Tuple := (1.0, 2.0, 3.0, 0.0);
      C : constant Tuple := (1.0, 2.0, 3.0, 1.0);
   begin
      AUnit.Assertions.Assert (A = B, "A and B are equivalent");
      AUnit.Assertions.Assert (A /= C, "A and C are not equivalent");
   end Test_Tuple_Comparison;

   overriding procedure Register_Tests (T : in out Test) is
      use AUnit.Test_Cases.Registration;
   begin
      Register_Routine (T, Test_Tuple_Creation'Access, "Tuple creation tests");
      Register_Routine (T, Test_Tuple_Comparison'Access, "Tuple comparison tests");
   end Register_Tests;

   overriding function Name (T : Test) return AUnit.Message_String is
      pragma Unreferenced (T);
   begin
      return AUnit.Format ("Basic");
   end Name;
end Basic.Tests;
