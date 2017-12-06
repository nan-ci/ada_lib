with Ada.Numerics.Discrete_Random, Ada.Directories, GNAT.Expect, Lib.File, Log;

package body Lib.Process is

   package Dir renames Ada.Directories;
   package Exp renames GNAT.Expect;

   use type OS.String_Access;

   procedure Save_Log (Message : Str) is
   begin
      if Logging then
         Log (Path, Message);
      end if;
   end Save_Log;

   function Internal (Args   : in out OS.Argument_List_Access;
                      Status :    out Integer) return Str is
      Cmd  : OS.String_Access := Args (1);
      Code : aliased Integer;
   begin
      Save_Log ("spawning");

      for A of Args.all loop
         Save_Log (To_UTF32 (A.all));
      end loop;

      if not Dir.Exists (Cmd.all) then
         Cmd := OS.Locate_Exec_On_Path (Args (1).all);

         if Cmd = null then
            Save_Log ("Cannot locate program");
            OS.Free (Args);
            Status := 127;
            return "";
         end if;
      end if;

      declare
         Result : constant Str := To_UTF32 (Exp.Get_Command_Output (Command    => Cmd.all,
                                                                    Arguments  => Args (2 .. Args'Last),
                                                                    Input      => "",
                                                                    Status     => Code'Access,
                                                                    Err_To_Out => True));
      begin
         Save_Log ("status is" & Integer'Wide_Wide_Image (Code));
         Save_Log ("output is '" & Result & ''');
         Save_Log ("");
         OS.Free (Cmd);
         OS.Free (Args);
         Status := Code;
         return Result;
      end;
   end Internal;

   procedure Spawn (Command     : Str;
                    Raise_Error : Boolean := True) is
      Code : Integer;

      Result : constant Str := Output (Command, Code);
   begin
      if Code /= 0 and Raise_Error then
         raise Execution_Error;
      end if;
   end Spawn;

   function Spawn (Command : Str) return Boolean is
      Code : Integer;

      Result : constant Str := Output (Command, Code);
   begin
      return Code = 0;
   end Spawn;

   function Spawn (Command : Str) return Integer is
      Code : Integer;

      Result : constant Str := Output (Command, Code);
   begin
      return Code;
   end Spawn;

   function Spawn (Command : in out OS.Argument_List_Access) return Integer is
      Code : Integer;

      Result : constant Str := Internal (Command, Code);
   begin
      return Code;
   end Spawn;

   function Output (Command : Str) return Str is
      Code : Integer;
   begin
      return Output (Command, Code);
   end Output;

   function Output (Command : Str;
                    Status  : out Integer) return Str is
      Args : OS.Argument_List_Access := OS.Argument_String_To_List (To_UTF8 (Command));
   begin
      return Internal (Args, Status);
   end Output;

end Lib.Process;
