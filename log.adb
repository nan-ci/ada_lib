with Ada.Calendar.Formatting, Lib.File;
use Lib;

procedure Log (Path, Message : Str) is
   package Cal renames Ada.Calendar;
begin
   File.Append (Path, To_Str (Cal.Formatting.Image (Date                  => Cal.Clock,
                                                    Include_Time_Fraction => True)) & ' ' & Message);
end Log;
