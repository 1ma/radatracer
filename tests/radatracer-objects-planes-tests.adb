with AUnit.Assertions;

package body Radatracer.Objects.Planes.Tests is
   procedure Test_Plane_Normal_At (T : in out AUnit.Test_Cases.Test_Case'Class);
   procedure Test_Plane_Normal_At (T : in out AUnit.Test_Cases.Test_Case'Class) is
      pragma Unreferenced (T);

      P : constant Plane := (others => <>);
      Normal : constant Vector := Make_Vector (0, 1, 0);
   begin
      AUnit.Assertions.Assert (P.Local_Normal_At (Make_Point (0, 0, 0)) = Normal, "The normal of a plane is constant everywhere");
      AUnit.Assertions.Assert (P.Local_Normal_At (Make_Point (10, 0, -10)) = Normal, "The normal of a plane is constant everywhere");
      AUnit.Assertions.Assert (P.Local_Normal_At (Make_Point (-5, 0, 150)) = Normal, "The normal of a plane is constant everywhere");
   end Test_Plane_Normal_At;

   procedure Test_Plane_Intersect (T : in out AUnit.Test_Cases.Test_Case'Class);
   procedure Test_Plane_Intersect (T : in out AUnit.Test_Cases.Test_Case'Class) is
      pragma Unreferenced (T);

      use type Ada.Containers.Count_Type;

      P : constant Object_Access := new Plane;
      R1 : constant Ray := (Origin => Make_Point (0, 10, 0), Direction => Make_Vector (0, 0, 1));
      R2 : constant Ray := (Origin => Make_Point (0, 0, 0), Direction => Make_Vector (0, 0, 1));
      R3 : constant Ray := (Origin => Make_Point (0, 1, 0), Direction => Make_Vector (0, -1, 0));
      R4 : constant Ray := (Origin => Make_Point (0, -1, 0), Direction => Make_Vector (0, 1, 0));

      XS : Intersection_Vectors.Vector;
   begin
      AUnit.Assertions.Assert (P.all.Local_Intersect (R1).Is_Empty, "Intersect with a Ray parallel to the Plane");

      AUnit.Assertions.Assert (P.all.Local_Intersect (R2).Is_Empty, "Intersect with a coplanar Ray");

      XS := P.all.Local_Intersect (R3);
      AUnit.Assertions.Assert (XS.Length = 1, "A Ray intersecting a Plane from above - part 1");
      AUnit.Assertions.Assert (XS (0).T_Value = 1.0, "A Ray intersecting a Plane from above - part 2");
      AUnit.Assertions.Assert (XS (0).Object = P, "A Ray intersecting a Plane from above - part 3");

      XS := P.all.Local_Intersect (R4);
      AUnit.Assertions.Assert (XS.Length = 1, "A Ray intersecting a Plane from below - part 1");
      AUnit.Assertions.Assert (XS (0).T_Value = 1.0, "A Ray intersecting a Plane from below - part 2");
      AUnit.Assertions.Assert (XS (0).Object = P, "A Ray intersecting a Plane from below - part 3");
   end Test_Plane_Intersect;

   overriding procedure Register_Tests (T : in out Test) is
      use AUnit.Test_Cases.Registration;
   begin
      Register_Routine (T, Test_Plane_Normal_At'Access, "Plane Normal_At tests");
      Register_Routine (T, Test_Plane_Intersect'Access, "Plane Intersect tests");
   end Register_Tests;

   overriding function Name (T : Test) return AUnit.Message_String is
      pragma Unreferenced (T);
   begin
      return AUnit.Format ("Radatracer.Objects.Planes");
   end Name;
end Radatracer.Objects.Planes.Tests;
