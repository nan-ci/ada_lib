package body Lib is

   function To_String (Item : Str) return String is
      Output : String (Item'Range);
   begin
      for I in Item'Range loop
         Output (I) := Character'Val (Char'Pos (Item (I)));
      end loop;

      return Output;
   end To_String;

   function To_Str (Item : String) return Str is
      Output : Str (Item'Range);
   begin
      for I in Item'Range loop
         Output (I) := Char'Val (Character'Pos (Item (I)));
      end loop;

      return Output;
   end To_Str;

   function Value (Item : Str)    return Integer is (Integer'Wide_Wide_Value (Item));
   function Value (Item : String) return Integer is (Integer'Value (Item));

end Lib;
