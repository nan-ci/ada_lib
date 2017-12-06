package body Lib.Term is

   function Image (Nb : Positive) return String is
      Img : constant String := Positive'Image (Nb);
   begin
      return Img (2 .. Img'Last);
   end Image;

   function Move (X, Y : Positive) return String is
      (ESC & '[' & Image (Y) & ';' & Image (X) & 'H');

   function Internal (Value   : Color;
                      Padding : Positive) return String is
      (ESC & '[' & Image (Color'Pos (Value) + Padding));

   function Fore (Value : Color) return String is
      (if Value in Dark_Color then
          Internal (Value, 30) & ";22m"
       else
          Internal (Value, 22) & ";1m");

   function Back (Color : Dark_Color) return String is
      (Internal (Color, 40) & ";22m");

end Lib.Term;
