with Ada.Text_IO;
with Basic;

procedure Test_Drive is
begin
   Ada.Text_IO.Put ("The answer to life is ");
   Ada.Text_IO.Put (Basic.Answer);
   Ada.Text_IO.New_Line;
end Test_Drive;
