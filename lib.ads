with Ada.Strings.UTF_Encoding.Wide_Wide_Strings, Ada.Strings.Wide_Wide_Maps;

package Lib is

   package Maps renames Ada.Strings.Wide_Wide_Maps;

   subtype Str      is Wide_Wide_String;
   subtype Char     is Wide_Wide_Character;
   subtype Char_Set is Maps.Wide_Wide_Character_Set;

   use type Char_Set;

   function "or" (Left : Char_Set; Right : Str) return Char_Set is (Left or Maps.To_Set (Right));
   function "or" (Left : Str; Right : Char_Set) return Char_Set is (Maps.To_Set (Left) or Right);

   function To_UTF8 (Item : Str;  Output_BOM : Boolean  := False) return String
      renames Ada.Strings.UTF_Encoding.Wide_Wide_Strings.Encode;

   function To_UTF32 (Item : String) return Str
      renames Ada.Strings.UTF_Encoding.Wide_Wide_Strings.Decode;

   function To_String (Item : Str) return String;
   function To_Str    (Item : String) return Str;

   function Value (Item : Str)    return Integer;
   function Value (Item : String) return Integer;

end Lib;
