with Ada.Wide_Wide_Characters.Handling, Ada.Strings.Wide_Wide_Fixed, Lib.File, Lib.Strings;

package body Lib.Config is

   package Fixed    renames Ada.Strings.Wide_Wide_Fixed;
   package Handling renames Ada.Wide_Wide_Characters.Handling;

   procedure Load is
      Txt : constant Str := File.Read (Path);

      Space : Natural;
   begin
      for Line_Span of Strings.Lines (Txt) loop
         Space := Fixed.Index (Txt (Line_Span.First .. Line_Span.Last), " ");

         if Space /= 0 then
            for Item in Key'Range loop
               if Key'Wide_Wide_Image (Item) = Handling.To_Upper (Txt (Line_Span.First .. Space - 1)) then
                  Cfg (Item).Set (Txt (Space + 1 .. Line_Span.Last));
               end if;
            end loop;
         end if;
      end loop;
   end Load;

   function Get (Item : Key) return Str is (Cfg (Item).Get);

end Lib.Config;
