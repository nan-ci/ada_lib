package Lib.Term is

   type Color is (Black, Red, Green, Brown, Blue, Magenta, Cyan, Gray, Dark_Gray, Light_Red,
                  Light_Green, Yellow, Light_Blue, Light_Magenta, Light_Cyan, White);

   subtype Dark_Color   is Color range Black     .. Gray;
   subtype Bright_Color is Color range Dark_Gray .. White;

   Clear_Line,
   Clear_Screen,
   Cursor_On,
   Cursor_Off,
   Default,
   Underline_On,
   Underline_Off : constant String;

   function Move (X, Y  : Positive)   return String;
   function Fore (Value : Color)      return String;
   function Back (Color : Dark_Color) return String;

private

   ESC : constant Character := Character'Val (27);

   Clear_Line    : constant String := ESC & "[2K";
   Clear_Screen  : constant String := ESC & "[2J";
   Cursor_On     : constant String := ESC & "[?25h";
   Cursor_Off    : constant String := ESC & "[?25l";
   Default       : constant String := ESC & "[0m";
   Underline_On  : constant String := ESC & "[4m";
   Underline_Off : constant String := ESC & "[24m";

end Lib.Term;
