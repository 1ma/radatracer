with Ada.Text_IO;

procedure Fixed is
   type MyFixedReal is delta 10.0 ** (-5) digits 18;

   Z : constant MyFixedReal := 0.0;
begin
   Ada.Text_IO.Put_Line (MyFixedReal'Size'Image);
   Ada.Text_IO.Put_Line (MyFixedReal'First'Image);
   Ada.Text_IO.Put_Line (MyFixedReal'Last'Image);
   Ada.Text_IO.Put_Line (Z'Image);
end Fixed;
