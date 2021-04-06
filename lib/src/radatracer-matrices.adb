package body Radatracer.Matrices is
   overriding function "=" (L, R : Matrix2) return Boolean is
   begin
      return
        L (0, 0) = R (0, 0) and
        L (0, 1) = R (0, 1) and
        L (1, 0) = R (1, 0) and
        L (1, 1) = R (1, 1);
   end "=";

   overriding function "=" (L, R : Matrix3) return Boolean is
   begin
      return
        L (0, 0) = R (0, 0) and
        L (0, 1) = R (0, 1) and
        L (0, 2) = R (0, 2) and
        L (1, 0) = R (1, 0) and
        L (1, 1) = R (1, 1) and
        L (1, 2) = R (1, 2) and
        L (2, 0) = R (2, 0) and
        L (2, 1) = R (2, 1) and
        L (2, 2) = R (2, 2);
   end "=";

   overriding function "=" (L, R : Matrix4) return Boolean is
   begin
      return
        L (0, 0) = R (0, 0) and
        L (0, 1) = R (0, 1) and
        L (0, 2) = R (0, 2) and
        L (0, 3) = R (0, 3) and
        L (1, 0) = R (1, 0) and
        L (1, 1) = R (1, 1) and
        L (1, 2) = R (1, 2) and
        L (1, 3) = R (1, 3) and
        L (2, 0) = R (2, 0) and
        L (2, 1) = R (2, 1) and
        L (2, 2) = R (2, 2) and
        L (2, 3) = R (2, 3) and
        L (3, 0) = R (3, 0) and
        L (3, 1) = R (3, 1) and
        L (3, 2) = R (3, 2) and
        L (3, 3) = R (3, 3);
   end "=";
end Radatracer.Matrices;
