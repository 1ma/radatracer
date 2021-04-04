with Ada.Text_IO;

procedure Test_Drive is
   F : Ada.Text_IO.File_Type;
begin
   Ada.Text_IO.Create (File => F, Mode => Ada.Text_IO.Out_File);
   Ada.Text_IO.Put_Line (F, "Wololo");

   Ada.Text_IO.Reset (File => F, Mode => Ada.Text_IO.In_File);

   while not Ada.Text_IO.End_Of_File (F) loop
      Ada.Text_IO.Put_Line (Ada.Text_IO.Get_Line (F));
   end loop;
   Ada.Text_IO.Close (F);
end Test_Drive;
