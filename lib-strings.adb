with Ada.Characters.Wide_Wide_Latin_1, Ada.Strings.Wide_Wide_Fixed, Text_IO, Lib.Sets;

package body Lib.Strings is  use type Char_Set;

   package Maps    renames Ada.Strings.Wide_Wide_Maps;
   package Latin_1 renames Ada.Characters.Wide_Wide_Latin_1;
   package Fixed   renames Ada.Strings.Wide_Wide_Fixed;

   function Get (Item    : Str;
                 Pattern : Char_Suite) return Sub is
      Low  : Positive := Item'First;
      High : Natural  := Low - 1;

      function Found (S : Suite) return Boolean is
      begin
         if S.Count = -1 then
            if not Maps.Is_In (Item (High + 1), S.Set) then
               return False;
            end if;

            High := High + 1;

            for I in High + 1 .. Item'Last loop
               exit when not Maps.Is_In (Item (I), S.Set);
               High := High + 1;
            end loop;

         elsif S.Count = 0 then
            for I in High + 1 .. Item'Last loop
               exit when not Maps.Is_In (Item (I), S.Set);
               High := High + 1;
            end loop;

         elsif S.Count > 0 then
            if High + S.Count > Item'Last or else
               (for some C of Item (High + 1 .. High + S.Count) => not Maps.Is_In (C, S.Set)) then
               return False;
            end if;

            High := High + S.Count;
         else
            raise Constraint_Error;
         end if;

         return True;
      end Found;

      P : Positive := Pattern'First;
   begin
      while Low <= Item'Last and P in Pattern'Range loop
         if not Found (Pattern (P)) then
            P    := Pattern'First;
            Low  := Low + 1;
            High := Low - 1;
         else
            P := P + 1;
         end if;
      end loop;

      return (if P > Pattern'Last then
                 Sub'(Low, High)
              else
                 Sub'(others => <>));
   end Get;

   function "&" (Left : Str; Right : Suite) return Char_Suite is (To_Suite (Left) & Right);
   function "&" (Left : Suite; Right : Str) return Char_Suite is (Left & To_Suite (Right));

   function "&" (Left : Char_Suite; Right : Str) return Char_Suite is (Left & To_Suite (Right));
   function "&" (Left : Str; Right : Char_Suite) return Char_Suite is (To_Suite (Left) & Right);

   function Any (Set : Char_Set) return Suite is ((-1, Set));

   function Get (Item    : Str;
                 Pattern : Char_Suite) return Str is
      Span : constant Sub := Get (Item, Pattern);
   begin
      return Item (Span.First .. Span.Last);
   end Get;

   function Get (Item    : Str;
                 Pattern : Suite) return Str is (Get (Item, Char_Suite'(1 => Pattern)));

   function Suites (Item    : Str;
                    Pattern : Char_Suite) return Sub_Array is
      Result : Sub_Array (1 .. Item'Length);
      Span   : Sub := (First => Item'First, Last => 0);
      Count  : Natural := 0;
   begin
      loop
         Span := Get (Item (Span.First .. Item'Last), Pattern);
         exit when Span.First > Span.Last;
         Count := Count + 1;
         Result (Count) := Span;
         Span.First := Span.Last + 1;
      end loop;

      return Result (1 .. Count);
   end Suites;

   function Suites (Item    : Str;
                    Pattern : Suite) return Sub_Array is (Suites (Item, Char_Suite'(1 => Pattern)));

   function Lines (Item : Str) return Sub_Array is
      Source : constant Sub_Array := Split (Item, Sets.New_Line);

      Result : Sub_Array (Source'Range);
      Count  : Natural := 0;
   begin
      for Span of Source loop
         if Span.First <= Span.Last then
            Count := Count + 1;
            Result (Count) := Span;
         end if;
      end loop;

      return Result (1 .. Count);
   end Lines;

   function Slice (Item : Str;
                   Span : Sub) return Str is (Item (Span.First .. Span.Last));

   function Split (Item      : Str;
                   Separator : Char) return Sub_Array is
      Result : Sub_Array (1 .. Item'Length);
      First  : Positive;
      Last   : Natural := Item'First - 1;
      Count  : Natural := 0;
   begin
      while Last <= Item'Last loop
         First := Last + 1;
         Last  := Fixed.Index (Source  => Item,
                               Pattern => (1 .. 1 => Separator),
                               From    => First);
         if Last = 0 then
            Last := Item'Last + 1;
         end if;

         Count := Count + 1;
         Result (Count) := (First, Last - 1);
      end loop;

      return Result (1 .. Count);
   end Split;

   function Words (Item : Str) return Sub_Array is
      Source : constant Sub_Array := Split (Item, Sets.Spaces or Sets.Line_Feed);

      Result : Sub_Array (Source'Range);
      Count  : Natural := 0;
   begin
      for Span of Source loop
         if Span.First <= Span.Last then
            Count := Count + 1;
            Result (Count) := Span;
         end if;
      end loop;

      return Result (1 .. Count);
   end Words;

   function Split (Item      : Str;
                   Separator : Char_Set) return Sub_Array is
      Result : Sub_Array (1 .. Item'Length);
      First  : Positive;
      Last   : Natural := Item'First - 1;
      Count  : Natural := 0;
   begin
      loop
         Fixed.Find_Token (Source => Item,
                           Set    => Separator,
                           From   => Last + 1,
                           Test   => Ada.Strings.Outside,
                           First  => First,
                           Last   => Last);
         exit when Last = 0;
         Count := Count + 1;
         Result (Count) := (First, Last);
      end loop;

      return Result (1 .. Count);
   end Split;

   function To_Suite (Pattern  : Str;
                      Matching : Token_Sequence := Null_Sequence) return Char_Suite is
      function Find_Set (C : Char) return Char_Set is
      begin
         for M of Matching loop
            if M.Key = C then
               return M.Value;
            end if;
         end loop;

         return Maps.To_Set (C);
      end Find_Set;

      Result : Char_Suite (1 .. Pattern'Length);
      R      : Natural  := 0;
      P      : Positive := Pattern'First;
      Span   : Sub;
   begin
      while P <= Pattern'Last loop
         Span := Get (Item    => Pattern (P .. Pattern'Last),
                      Pattern => (1 => Suite'(Count => -1,
                                              Set   => Maps.To_Set (Pattern (P)))));
         if Span.Last = 0 then
            raise Constraint_Error;
         end if;

         R := R + 1;
         Result (R) := Suite'(Count => Span.Last - Span.First + 1,
                              Set   => Find_Set (Pattern (P)));
         P := P + Result (R).Count;
      end loop;

      return Result (1 .. R);
   end To_Suite;

end Lib.Strings;
