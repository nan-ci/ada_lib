with Lib.Unicode, Ada.Characters.Wide_Wide_Latin_1, Ada.Strings.Wide_Wide_Maps;

package Lib.Sets is

   package Maps    renames ada.Strings.Wide_Wide_Maps;
   package Latin_1 renames Ada.Characters.Wide_Wide_Latin_1;

   use type Char_Set;

   Line_Feed : constant Char_Set := Maps.To_Set (Latin_1.LF);
   Lower     : constant Char_Set := Maps.To_Set (Span => ('a', 'z'));
   Upper     : constant Char_Set := Maps.To_Set (Span => ('A', 'Z'));
   Basic     : constant Char_Set := Lower or Upper;
   Digit     : constant Char_Set := Maps.To_Set (Span => ('0', '9'));
   Hexa      : constant Char_Set := Maps.To_Set ("abcdefABCDEF") or Digit;
   Graphic   : constant Char_Set := Maps.To_Set (Unicode.Graphic_Ranges);
   Spaces    : constant Char_Set := Maps.To_Set (' ' & Latin_1.HT);
   New_Line  : constant Char_Set := Maps.To_Set (Latin_1.CR & Latin_1.LF);
   Low_Line  : constant Char_Set := Maps.To_Set ('_');
   Hyphen    : constant Char_Set := Maps.To_Set ('-');

end Lib.Sets;
