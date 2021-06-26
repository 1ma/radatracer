with Ada.Integer_Text_IO;

package body Radatracer.Images.IO is
   procedure Print_PPM_Header (FT : Ada.Text_IO.File_Type; Width, Height : Positive);
   procedure Print_PPM_Color (FT : Ada.Text_IO.File_Type; PC : Primary_Color; Length : in out Natural);
   function Color_PPM_Length (PC : Primary_Color) return Positive;

   procedure Write_PPM (FT : Ada.Text_IO.File_Type; C : Canvas) is
      Current_Line_Length : Natural;
   begin
      Print_PPM_Header (FT, C'Length (1), C'Length (2));

      for Height in C'Range (2) loop
         Current_Line_Length := 0;
         for Width in C'Range (1) loop
            Print_PPM_Color (FT, C (Width, Height).Red, Current_Line_Length);
            Print_PPM_Color (FT, C (Width, Height).Green, Current_Line_Length);
            Print_PPM_Color (FT, C (Width, Height).Blue, Current_Line_Length);
         end loop;
      end loop;

      Ada.Text_IO.New_Line (FT);
   end Write_PPM;

   procedure Print_PPM_Header (FT : Ada.Text_IO.File_Type; Width, Height : Positive) is
   begin
      Ada.Text_IO.Put (FT, "P3");
      Ada.Text_IO.New_Line (FT);
      Ada.Integer_Text_IO.Put (File => FT, Item => Width, Width => 0);
      Ada.Text_IO.Put (FT, " ");
      Ada.Integer_Text_IO.Put (File => FT, Item => Height, Width => 0);
      Ada.Text_IO.New_Line (FT);
      Ada.Text_IO.Put (FT, "255");
   end Print_PPM_Header;

   procedure Print_PPM_Color (FT : Ada.Text_IO.File_Type; PC : Primary_Color; Length : in out Natural) is
      package Primary_Color_IO is new Ada.Text_IO.Integer_IO (Primary_Color);

      Max_Line_Length : constant Natural := 70;
      Color_Length : constant Positive := Color_PPM_Length (PC);
   begin
      if Length = 0 or Length + 1 + Color_Length > Max_Line_Length then
         Ada.Text_IO.New_Line (FT);
         Primary_Color_IO.Put (File => FT, Item => PC, Width => 0);
         Length := Color_Length;
      else
         Ada.Text_IO.Put (FT, PC'Image);
         Length := Length + 1 + Color_Length;
      end if;
   end Print_PPM_Color;

   function Color_PPM_Length (PC : Primary_Color) return Positive is
   begin
      if PC < 10 then
         return 1;
      end if;

      if PC < 100 then
         return 2;
      end if;

      return 3;
   end Color_PPM_Length;
end Radatracer.Images.IO;
