with Ada.Calendar.Formatting, Ada.Directories, Ada.Streams.Stream_IO, Lib.Process, Ada.Characters.Wide_Wide_Latin_1, Lib.Text;

package body Lib.File is

   package Maps    renames ada.Strings.Wide_Wide_Maps;
   package Latin_1 renames Ada.Characters.Wide_Wide_Latin_1;
   package Dir     renames Ada.Directories;
   package SIO     renames Ada.Streams.Stream_IO;

   use type Text.T;

   procedure Delete (Path : Str) is
   begin
      Dir.Delete_File (To_UTF8 (Path));
   end Delete;

   procedure Exclude (Path : Str) is
   begin
      if Exists (Path) then
         Delete (Path);
      end if;
   end Exclude;

   function Read (Path : Str) return Str is
      UTF8_Path : constant String := To_UTF8 (Path);

      File   : SIO.File_Type;
      Buffer : String (1 .. Natural (Dir.Size (UTF8_Path)));
   begin
      SIO.Open (File, SIO.In_File, UTF8_Path);
      String'Read (SIO.Stream (File), Buffer);
      SIO.Close (File);
      return To_UTF32 (Buffer);
   end Read;

   procedure Append (Path, Item : Str) is
      File : SIO.File_Type;
   begin
      if Exists (Path) then
         SIO.Open (File, SIO.Append_File, To_UTF8 (Path));
         String'Write (SIO.Stream (File), To_UTF8 (Item & Latin_1.LF));
         SIO.Close (File);
      else
         Overwrite (Path, Item);
      end if;
   end Append;

   procedure Overwrite (Path, Item : Str) is
      File : SIO.File_Type;
   begin
      SIO.Create (File, SIO.Out_File, To_UTF8 (Path));
      String'Write (SIO.Stream (File), To_UTF8 (Item & Latin_1.LF));
      SIO.Close (File);
   end Overwrite;

   procedure Write (Path, Item : Str) is
   begin
      if Exists (Path) then
         raise Program_Error;
      end if;

      Overwrite (Path, Item);
   end Write;

   function Exists (Path : Str) return Boolean is (Dir.Exists (To_UTF8 (Path)));

   procedure Change_Date (Path : Str;
                          Date : Ada.Calendar.Time) is
      Image : Text.T (50);
   begin
      Image.Set (Ada.Calendar.Formatting.Image (Date));
      Image.Escape;
      Process.Spawn ("touch -md " & Image.Get & ' ' & Path);
   end Change_Date;

end Lib.File;
