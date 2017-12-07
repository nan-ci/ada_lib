private with Lib.Text;

generic

   Path : Str;

   type Key is (<>);

package Lib.Config is

   procedure Load;

   function Get (Item : Key) return Str;

private

   Cfg : array (Key) of Text.T (Size => 1000);

end Lib.Config;
