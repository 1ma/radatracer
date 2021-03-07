with AUnit.Assertions;
with Basic;

package body Basic.Tests is
   procedure Test_Simple_Tuples (T : in out AUnit.Test_Cases.Test_Case'Class);
   procedure Test_Simple_Tuples (T : in out AUnit.Test_Cases.Test_Case'Class) is
      A : constant Tuple := (4.3, -4.2, 3.1, 1.0);
      B : constant Tuple := (4.3, -4.2, 3.1, 0.0);
      P : constant Tuple := Basic.New_Point (4.0, -4.0, 3.0);
      V : constant Tuple := Basic.New_Vector (4.0, -4.0, 3.0);
   begin
      AUnit.Assertions.Assert (A.X = 4.3 and A.Y = -4.2 and A.Z = 3.1 and A.W = 1.0, "A has expected values");
      AUnit.Assertions.Assert (B.X = 4.3 and B.Y = -4.2 and B.Z = 3.1 and B.W = 0.0, "B has expected values");
      AUnit.Assertions.Assert (P.X = 4.0 and P.Y = -4.0 and P.Z = 3.0 and P.W = 1.0, "P.W is 1.0");
      AUnit.Assertions.Assert (V.X = 4.0 and V.Y = -4.0 and V.Z = 3.0 and V.W = 0.0, "V.W is 0.0");
   end Test_Simple_Tuples;

   procedure Test_Tuple_Operations (T : in out AUnit.Test_Cases.Test_Case'Class);
   procedure Test_Tuple_Operations (T : in out AUnit.Test_Cases.Test_Case'Class) is
      Comp1 : constant Tuple := (1.0, 2.0, 3.0, 0.0);
      Comp2 : constant Tuple := (1.0, 2.0, 3.0, 0.0);
      Comp3 : constant Tuple := (1.0, 2.0, 3.0, 1.0);

      Sum1 : constant Tuple := (3.0, -2.0, 5.0, 1.0);
      Sum2 : constant Tuple := (-2.0, 3.0, 1.0, 0.0);
      SumR : constant Tuple := (1.0, 1.0, 6.0, 1.0);

      Sub1 : constant Tuple := Basic.New_Point (3.0, 2.0, 1.0);
      Sub2 : constant Tuple := Basic.New_Point (5.0, 6.0, 7.0);
      SubR : constant Tuple := Basic.New_Vector (-2.0, -4.0, -6.0);

      Neg1 : constant Tuple := (1.0, -2.0, 3.0, -4.0);
      NegR : constant Tuple := (-1.0, 2.0, -3.0, 4.0);

      ScalarMult1 : constant Tuple := (1.0, -2.0, 3.0, -4.0);
      ScalarMultR1 : constant Tuple := (3.5, -7.0, 10.5, -14.0);
      ScalarMultR2 : constant Tuple := (0.5, -1.0, 1.5, -2.0);

      ScalarDiv1 : constant Tuple := (1.0, -2.0, 3.0, -4.0);
      ScalarDivR : constant Tuple := (0.5, -1.0, 1.5, -2.0);
   begin
      AUnit.Assertions.Assert (Comp1 = Comp2, "Comp1 and Comp2 are the same Tuple");
      AUnit.Assertions.Assert (Comp1 /= Comp3, "Comp1 and Comp3 are not the same Tuple");

      AUnit.Assertions.Assert (Sum1 + Sum2 = SumR, "Sum test");

      AUnit.Assertions.Assert (Sub1 - Sub2 = SubR, "Subtraction test");

      AUnit.Assertions.Assert (-Neg1 = NegR, "Negation test");

      AUnit.Assertions.Assert (ScalarMult1 * 3.5 = ScalarMultR1, "Scalar Multiplication test 1");
      AUnit.Assertions.Assert (3.5 * ScalarMult1 = ScalarMultR1, "Scalar Multiplication test 2");
      AUnit.Assertions.Assert (ScalarMult1 * 0.5 = ScalarMultR2, "Scalar Multiplication test 3");
      AUnit.Assertions.Assert (0.5 * ScalarMult1 = ScalarMultR2, "Scalar Multiplication test 4");

      AUnit.Assertions.Assert (ScalarDiv1 / 2.0 = ScalarDivR, "Scalar Division test");
   end Test_Tuple_Operations;

   overriding procedure Register_Tests (T : in out Test) is
      use AUnit.Test_Cases.Registration;
   begin
      Register_Routine (T, Test_Simple_Tuples'Access, "Simple Tuple creation tests");
      Register_Routine (T, Test_Tuple_Operations'Access, "Tuple Operations tests");
   end Register_Tests;

   overriding function Name (T : Test) return AUnit.Message_String is
      pragma Unreferenced (T);
   begin
      return AUnit.Format ("Basic");
   end Name;
end Basic.Tests;
