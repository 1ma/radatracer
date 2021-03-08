with Ada.Numerics.Generic_Elementary_Functions;
with Ada.Text_IO;

procedure Fixed is
   type MyDigits is digits 10;
   type MyDeltaRanged is delta 0.01 range -10.0 .. 10.0;
   type MyDeltaDigits is delta 0.01 digits 10;

   package MD_Ops is new Ada.Numerics.Generic_Elementary_Functions (MyDigits);
   --  package MDR_Ops is new Ada.Numerics.Generic_Elementary_Functions (MyDeltaRanged);
   --  package MDD_Ops is new Ada.Numerics.Generic_Elementary_Functions (MyDeltaDigits);

   D : constant MyDigits := 2.0;
   DR : constant MyDeltaRanged := 2.0;
   DD : constant MyDeltaDigits := 2.0;
begin
   Ada.Text_IO.Put_Line (D'Image);
   Ada.Text_IO.Put_Line (DR'Image);
   Ada.Text_IO.Put_Line (DD'Image);
   Ada.Text_IO.New_Line;
   Ada.Text_IO.Put_Line (MD_Ops.Sqrt (D)'Image);
   --  Ada.Text_IO.Put_Line (MDR_Ops.Sqrt (DR)'Image);
   --  Ada.Text_IO.Put_Line (MDD_Ops.Sqrt (DD)'Image);
end Fixed;
