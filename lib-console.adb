with Ada.Characters.Wide_Wide_Latin_1, Ada.Characters.Conversions, Ada.Text_IO, Ada.Wide_Wide_Text_IO, Lib.Term;

package body Lib.Console is

   package Latin_1 renames Ada.Characters.Wide_Wide_Latin_1;
   package TIO     renames Ada.Text_IO;
   package WIO     renames Ada.Wide_Wide_Text_IO;

   use all type Text.Direction;

   X, Y, Padding_X, Padding_Y : Positive := 1;

   procedure Set_Origin is
   begin
      Set_Origin (X, Y);
   end Set_Origin;

   procedure Set_Origin (X, Y : Positive) is
   begin
      Padding_X := X;
      Padding_Y := Y;
   end Set_Origin;

   procedure Clear is
      Spaces : constant String := (1 .. (Y - Padding_Y + 1) * Width + X - Padding_X + 1 => ' ');
   begin
      Reset;
      TIO.Put (Term.Default & Spaces);
      Reset;
   end Clear;

   procedure Clear_Line is
      Spaces : constant String := (1 .. X - Padding_X + 1 => ' ');
   begin
      X := Padding_X;
      Move_Cursor;
      TIO.Put (Spaces);
      Move_Cursor;
   end Clear_Line;

   procedure Reset is
   begin
      X := Padding_X;
      Y := Padding_Y;
      Move_Cursor;
   end Reset;

   procedure New_Line is
   begin
      if Y + 1 < Height then
         Y := Y + 1;
      else
         Clear_Line;
      end if;

      X := Padding_X;
      Move_Cursor;
   end New_Line;

   procedure Put (Item : String) is
   begin
      Move_Cursor;
      X := X + Item'Length;
      TIO.Put (Item);
   end Put;

   procedure Move_Cursor is
   begin
      TIO.Put (Term.Move (X, Y));
   end Move_Cursor;

   procedure Put_Line (Item : String) is
   begin
      Put (Item);
      New_Line;
   end Put_Line;

   procedure Get_Line (Item : in out Text.T;
                       Show : Boolean  := True;
                       Set  : Char_Set := Sets.Graphic) is
      Key : Char;
   begin
      Item.Clear;

      if not Show then
         TIO.Put (Term.Cursor_Off);
      end if;

      loop
         begin
            WIO.Get_Immediate (Key);
         exception
            when others => Key := Latin_1.NUL;
         end;

         case Key is
            when Latin_1.NUL => null;
            when Latin_1.CR |
                 Latin_1.LF =>
               New_Line;
               exit;
            when Latin_1.ETX =>
               Item.Clear;
               New_Line;
               exit;
            when Latin_1.DEL =>
               if Item.Last > 0 then
                  Item.Strip (1, Backward);

                  if Show then
                     X := X - 1;
                     TIO.Put (Term.Move (X, Y) & ' ' & Term.Move (X, Y));
                  end if;
               end if;
            when others =>
               if Item.Last < Item.Size and then Maps.Is_In (Key, Set) then
                  Item.Append (Str'(1 .. 1 => Key));

                  if Show then
                     X := X + 1;
                     WIO.Put (Key);
                  end if;
               end if;
         end case;
      end loop;
   end Get_Line;

end Lib.Console;
