with Ada.Calendar;

package Lib.File is

   procedure Exclude (Path : Str);

   function Read (Path : Str) return Str;

   procedure Delete (Path : Str);

   procedure Append    (Path, Item : Str);
   procedure Overwrite (Path, Item : Str);
   procedure Write     (Path, Item : Str);

   function Exists (Path : Str) return Boolean;

   procedure Change_Date (Path : Str;
                          Date : Ada.Calendar.Time);
end Lib.File;
