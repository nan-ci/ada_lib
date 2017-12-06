with Lib.Text, Lib.Sets;
use Lib;

package Lib.Console is

   Width  : Positive := 80;
   Height : Positive := 25;

   procedure Set_Origin;
   procedure Set_Origin (X, Y : Positive);

--     procedure Save;
--     procedure Restore;
   procedure Clear;
   procedure Clear_Line;
   procedure Reset;
   procedure New_Line;
   procedure Put      (Item : String);
   procedure Put_Line (Item : String);

   procedure Get_Line (Item : in out Text.T;
                       Show : Boolean  := True;
                       Set  : Char_Set := Sets.Graphic);
end Lib.Console;
