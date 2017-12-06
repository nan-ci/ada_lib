package Lib.Locking is

   task type T is
      entry Create (Path    : Str;
                    Timeout : Duration := 60.0);
      entry Delete;
   end T;

   Locking_Error : exception;

private

   Refresh : constant Duration := 5.0;

end Lib.Locking;
