with Ada.Calendar, Ada.Directories, Ada.Numerics.Float_Random, Lib.File, Lib.Process, Lib.Text;

package body Lib.Locking is

   package Cal renames Ada.Calendar;
   package Dir renames Ada.Directories;
   package RNG renames Ada.Numerics.Float_Random;

   use type Cal.Time;

   task body T is
      Target : Text.T (255);

      procedure Adjust_Mtime is
      begin
         File.Change_Date (Target.Get, Cal.Clock + Refresh + 1.0);
      end Adjust_Mtime;

      G        : RNG.Generator;
      Deadline : Cal.Time;
      Now      : Cal.Time;
   begin
      loop
         select
            accept Create (Path    : Str;
                           Timeout : Duration := 60.0) do
               Target.Set (Path);
               Deadline := Cal.Clock + Timeout;

               loop
                  begin
                     Dir.Create_Directory (Target.To_String);
                     Adjust_Mtime;
                     exit;
                  exception
                     when Dir.Use_Error =>
                        delay Duration (RNG.Random (G) / 2.0 + 0.1);
                        Now := Cal.Clock;

                        if Now > Deadline then
                           raise Locking_Error;
                        elsif Now > Dir.Modification_Time (Target.To_String) then
                           begin
                              Dir.Delete_Directory (Target.To_String);
                           exception
                              when others => null;
                           end;
                        end if;
                  end;
               end loop;
            end Create;

            loop
               select
                  accept Delete;
                  Dir.Delete_Directory (Target.To_String);
                  exit;
               or
                  delay Refresh;
                  Adjust_Mtime;
               end select;
            end loop;
         or
            terminate;
         end select;
      end loop;
   end T;

end Lib.Locking;
