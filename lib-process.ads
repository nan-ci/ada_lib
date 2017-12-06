with GNAT.OS_Lib;

package Lib.Process is

   package OS renames GNAT.OS_Lib;

   Execution_Error : exception;

   procedure Spawn (Command     : Str;
                    Raise_Error : Boolean := True);

   function Spawn (Command : Str) return Boolean;
   function Spawn (Command : Str) return Integer;

   function Spawn (Command : in out OS.Argument_List_Access) return Integer;

   function Output (Command : Str) return Str;

   function Output (Command : Str;
                    Status  : out Integer) return Str;
private

   Logging : constant Boolean := True;

   Path : constant Str := "/run/lib-process.log";

end Lib.Process;
