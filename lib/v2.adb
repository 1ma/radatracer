package body V2 is
   overriding function "=" (L, R : Value) return Boolean is
      Epsilon : constant Value := 0.00001;
   begin
      return abs (L - R) < Epsilon;
   end "=";

   function Dot_Product (L, R : Vector) return Value is
   begin
      return L.X * R.X + L.Y * R.Y + L.Z * R.Z;
   end Dot_Product;

   function Cross_Product (L, R : Vector) return Vector is
   begin
      return (
         X => L.Y * R.Z - L.Z * R.Y,
         Y => L.Z * R.X - L.X * R.Z,
         Z => L.X * R.Y - L.Y * R.X,
         W => 0.0
      );
   end Cross_Product;
end V2;
