package body Radatracer.Matrices is
   overriding function "=" (L, R : Matrix) return Boolean is
   begin
      for Row in L'Range (1) loop
         for Column in L'Range (2) loop
            if L (Row, Column) /= R (Row, Column) then
               return False;
            end if;
         end loop;
      end loop;

      return True;
   end "=";

   function "*" (L, R : Matrix4) return Matrix4 is
   begin
      return (
          (
              L (0, 0) * R (0, 0) + L (0, 1) * R (1, 0) + L (0, 2) * R (2, 0) + L (0, 3) * R (3, 0),
              L (0, 0) * R (0, 1) + L (0, 1) * R (1, 1) + L (0, 2) * R (2, 1) + L (0, 3) * R (3, 1),
              L (0, 0) * R (0, 2) + L (0, 1) * R (1, 2) + L (0, 2) * R (2, 2) + L (0, 3) * R (3, 2),
              L (0, 0) * R (0, 3) + L (0, 1) * R (1, 3) + L (0, 2) * R (2, 3) + L (0, 3) * R (3, 3)
          ),
          (
              L (1, 0) * R (0, 0) + L (1, 1) * R (1, 0) + L (1, 2) * R (2, 0) + L (1, 3) * R (3, 0),
              L (1, 0) * R (0, 1) + L (1, 1) * R (1, 1) + L (1, 2) * R (2, 1) + L (1, 3) * R (3, 1),
              L (1, 0) * R (0, 2) + L (1, 1) * R (1, 2) + L (1, 2) * R (2, 2) + L (1, 3) * R (3, 2),
              L (1, 0) * R (0, 3) + L (1, 1) * R (1, 3) + L (1, 2) * R (2, 3) + L (1, 3) * R (3, 3)
          ),
          (
              L (2, 0) * R (0, 0) + L (2, 1) * R (1, 0) + L (2, 2) * R (2, 0) + L (2, 3) * R (3, 0),
              L (2, 0) * R (0, 1) + L (2, 1) * R (1, 1) + L (2, 2) * R (2, 1) + L (2, 3) * R (3, 1),
              L (2, 0) * R (0, 2) + L (2, 1) * R (1, 2) + L (2, 2) * R (2, 2) + L (2, 3) * R (3, 2),
              L (2, 0) * R (0, 3) + L (2, 1) * R (1, 3) + L (2, 2) * R (2, 3) + L (2, 3) * R (3, 3)
          ),
          (
              L (3, 0) * R (0, 0) + L (3, 1) * R (1, 0) + L (3, 2) * R (2, 0) + L (3, 3) * R (3, 0),
              L (3, 0) * R (0, 1) + L (3, 1) * R (1, 1) + L (3, 2) * R (2, 1) + L (3, 3) * R (3, 1),
              L (3, 0) * R (0, 2) + L (3, 1) * R (1, 2) + L (3, 2) * R (2, 2) + L (3, 3) * R (3, 2),
              L (3, 0) * R (0, 3) + L (3, 1) * R (1, 3) + L (3, 2) * R (2, 3) + L (3, 3) * R (3, 3)
          )
      );
   end "*";
end Radatracer.Matrices;
