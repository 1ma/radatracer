with Ada.Text_IO;

procedure Fixed is
   type Aviam is delta 0.1 range 0.0 .. 10.0;
   for Aviam'Small use 0.1;
   F1 : constant Aviam := 0.0;
   F2 : constant Aviam := 0.1;
begin
   Ada.Text_IO.Put_Line ("cumansem");
   Ada.Text_IO.Put_Line (F1'Image);
   Ada.Text_IO.Put_Line (F2'Image);
end Fixed;
