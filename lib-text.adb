with Ada.Strings.Wide_Wide_Fixed, Ada.Wide_Wide_Text_IO, Ada.Strings.Wide_Wide_Maps;

package body Lib.Text is

   package TIO   renames Ada.Wide_Wide_Text_IO;
   package Maps  renames Ada.Strings.Wide_Wide_Maps;
   package Fixed renames Ada.Strings.Wide_Wide_Fixed;

   use type Char_Set;

   function "not" (Test : Membership) return Membership is
      (if Test = Inside then
          Outside
       else
          Inside);

   function "=" (Left : T; Right : String) return Boolean is (Left.To_String = Right);

   function "+" (Item : Str) return T is
   begin
      return Output : T (Item'Length) do
         Output.Set (Item);
      end return;
   end "+";

   function "+" (Item : String) return T is (+To_Str (Item));

   procedure Append (Item : in out T; Source : Str) is
      Last : constant Natural := Item.Last + Source'Length;
   begin
      Item.Data (Item.Last + 1 .. Last) := Source;
      Item.Last := Last;
   end Append;

   procedure Append (Item : in out T; Source : T) is
   begin
      Item.Append (Source.Data (1 .. Source.Last));
   end Append;

   procedure Clear (Item : in out T) is
   begin
      Item.Last := 0;
      Item.Data := (others => Char'First);
      pragma Assert (for all C of Item.Data => C = Char'First);
   end Clear;

   procedure Escape (Item    : in out Text.T;
                     Pattern : Char := ' ') is
      I : Positive := 1;
   begin
      while I <= Item.Last loop
         if Item.Data (I) = Pattern then
            Item.Insert (I, "\");
            I := I + 1;
         end if;

         I := I + 1;
      end loop;
   end Escape;

   procedure Find (Item    : in out T;
                   Pattern : Char_Set;
                   Test    : Membership := Inside;
                   Going   : Direction  := Forward) is
      I : constant Natural := Item.Find (Pattern, Test, Going);
   begin
      if I = 0 then
         Item.Clear;
      else
         if Going = Forward then
            Item.Strip (First => 1, Last => I - 1);
         else
            Item.Strip (First => I + 1, Last => Item.Last);
         end if;
      end if;
   end Find;

   procedure Find (Item    : in out T;
                   Pattern : Str;
                   Going   : Direction  := Forward) is
      I : constant Natural := Item.Find (Pattern, Going);
   begin
      if I = 0 then
         Item.Clear;
      else
         if Going = Forward then
            Item.Strip (First => 1, Last => I - 1);
         else
            Item.Strip (First => I + Pattern'Length, Last => Item.Last);
         end if;
      end if;
   end Find;

   function Find (Item    : T;
                  Pattern : Char_Set;
                  Test    : Membership := Inside;
                  Going   : Direction  := Forward) return Natural is
      (Item.Find (Pattern => Pattern,
                  From    => (if Going = Forward then
                                 1
                              else
                                 Item.Last),
                  Test    => Test,
                  Going   => Going));

   function Find (Item    : T;
                  Pattern : Str;
                  Going   : Direction := Forward) return Natural is
      (Item.Find (Pattern => Pattern,
                  From    => (if Going = Forward then
                                 1
                              else
                                 Item.Last),
                  Going   => Going));

   function Find (Item    : T;
                  Pattern : Char_Set;
                  From    : Positive;
                  Test    : Membership := Inside;
                  Going   : Direction  := Forward) return Natural is
      (Fixed.Index (Source => Item.Data (1 .. Item.Last),
                    Set    => Pattern,
                    From   => From,
                    Test   => Test,
                    Going  => Going));

   function Find (Item    : T;
                  Pattern : Str;
                  From    : Positive;
                  Going   : Direction := Forward) return Natural is
      (Fixed.Index (Source  => Item.Data (1 .. Item.Last),
                    Pattern => Pattern,
                    From    => From,
                    Going   => Going));

   function Cut (Item  : in out T;
                 Going : Direction  := Forward) return Integer is
      (Integer'Wide_Wide_Value (Item.Cut (Pattern => Sets.Digit,
                                          Test    => Inside,
                                          Going   => Going)));

   function Cut (Item    : in out T;
                 Pattern : Char_Set;
                 Test    : Membership := Inside;
                 Going   : Direction  := Forward) return Str is
      First : constant Natural := Item.Find (Pattern, Test, Going);

      Last : Natural;
   begin
      if First = 0 then
         Item.Clear;
         return "";
      end if;

      Last := Item.Find (Pattern => Pattern,
                         From    => First,
                         Test    => not Test,
                         Going   => Going);

      if Going = Forward then
         if Last = 0 then
            Last := Item.Last + 1;
         end if;

         return Output : constant Str := Item.Data (First .. Last - 1) do
            Item.Strip (First => 1, Last => Last - 1);
         end return;
      else
         return Output : constant Str := Item.Data (Last + 1 .. First) do
            Item.Strip (First => Last + 1, Last => Item.Last);
         end return;
      end if;
   end Cut;

   function Cut (Item    : in out T;
                 Pattern : Char_Set;
                 Test    : Membership := Inside;
                 Going   : Direction  := Forward) return String is
      (To_String (Item.Cut (Pattern => Pattern,
                            Test    => Test,
                            Going   => Going)));

   function Cut (Item    : in out T;
                 Pattern : Char_Set;
                 Test    : Membership := Inside;
                 Going   : Direction  := Forward) return T is (+Str'(Cut (Item, Pattern, Test, Going)));

   function Cut (Item   : in out T;
                 Length : Natural) return Str is
      Output : constant Str := Item.Data (1 .. Length);
   begin
      Item.Strip (Length);
      return Output;
   end Cut;

   function Get (Item : T) return Str is (Item.Data (1 .. Item.Last));

   procedure Get (Item : out T) is
   begin
      Item.Set (TIO.Get_Line);
   end Get;

   function To_String (Item : T) return String is (To_String (Item.Get));

   function To_UTF8 (Item : T) return String is (To_UTF8 (Item.Get));

   procedure Head (Item : in out T;  Count : Positive) is
   begin
      Item.Strip (Item.Last - Count, Going => Backward);
   end Head;

   procedure Insert (Item   : in out T;
                     Before : Positive;
                     Source : Str) is
      SL    : constant Natural := Source'Length;
      Total : constant Natural := Item.Last + Source'Length;
   begin
      Item.Data (Before + SL .. Total) := Item.Data (Before .. Item.Last);
      Item.Data (Before .. Before + SL - 1) := Source;
      Item.Last := Total;
   end Insert;

   procedure Insert (Item   : in out T;
                     Before : Positive;
                     Source : T) is
   begin
      Item.Insert (Before, Source.Data (1 .. Source.Last));
   end Insert;

   function Lines (Item : T) return Strings.Sub_Array is
      (Strings.Lines (Item.Data (1 .. Item.Last)));

   procedure New_Line is
   begin
      TIO.New_Line;
   end New_Line;

   procedure Put (Item : T) is
   begin
      TIO.Put (Item.Data (1 .. Item.Last));
   end Put;

   procedure Put_Line (Item : T) is
   begin
      Item.Put;
      New_Line;
   end Put_Line;

   procedure Set (Item : in out T; Source : Str) is
   begin
      Item.Data (1 .. Source'Length) := Source;
      Item.Last := Source'Length;
   end Set;

   procedure Set (Item : in out T; Source : String) is
   begin
      Item.Set (To_Str (Source));
   end Set;

   procedure Skip (Item    : in out T;
                   Pattern : Char_Set;
                   Test    : Membership := Inside;
                   Going   : Direction  := Forward) is
      I : constant Natural := Item.Skip (Pattern, Test, Going);
   begin
      if I = 0 then
         Item.Clear;
      else
         if Going = Forward then
            Item.Strip (First => 1, Last => I - 1);
         else
            Item.Strip (First => I + 1, Last => Item.Last);
         end if;
      end if;
   end Skip;

   procedure Skip (Item    : in out T;
                   Pattern : Str;
                   Going   : Direction := Forward) is
      I : constant Natural := Item.Skip (Pattern, Going);
   begin
      if I = 0 then
         Item.Clear;
      else
         if Going = Forward then
            Item.Strip (First => 1, Last => I - 1);
         else
            Item.Strip (First => I + 1, Last => Item.Last);
         end if;
      end if;
   end Skip;

   function Skip (Item    : T;
                  Pattern : Char_Set;
                  Test    : Membership := Inside;
                  Going   : Direction  := Forward) return Natural is
      First : constant Natural := Item.Find (Pattern, Test, Going);

      Last : Natural;
   begin
      if First = 0 then
         return 0;
      end if;

      Last := Item.Find (Pattern => Pattern,
                         From    => First,
                         Test    => not Test,
                         Going   => Going);
      if Last = 0 then
         Last := (if Going = Forward then
                     Item.Last
                  else
                     1);
      end if;

      return Last;
   end Skip;

   function Skip (Item    : T;
                  Pattern : Str;
                  Going   : Direction  := Forward) return Natural is
      First : constant Natural := Item.Find (Pattern, Going);
   begin
      if First = 0 then
         return 0;
      end if;

      return (if Going = Forward then
                 First + Pattern'Length
              else
                 First - Pattern'Length);
   end Skip;

   function Slice (Item : T;
                   Span : Strings.Sub) return Str is
      (Strings.Slice (Item => Item.Data (1 .. Item.Last),
                      Span => Span));

   function Split (Item      : T;
                   Separator : Char) return Strings.Sub_Array is
      (Strings.Split (Item      => Item.Data (1 .. Item.Last),
                      Separator => Separator));

   procedure Strip (Item  : in out T;
                    Count : Natural;
                    Going : Direction := Forward) is
   begin
      if Going = Forward then
         Item.Strip (1, Count);
      else
         Item.Last := Item.Last - Count;
      end if;
   end Strip;

   procedure Strip (Item  : in out T;
                    First : Positive;
                    Last  : Natural) is
      New_Last : constant Natural := Item.Last - Last + First - 1;
   begin
      if Last <= Item.Last and then First <= Item.Last and then First <= Last then
         if Last = Item.Last then
            Item.Last := First - 1;
         else
            Item.Data (First .. New_Last) := Item.Data (Last + 1 .. Item.Last);
            Item.Last := New_Last;
         end if;
      end if;
   end Strip;

   procedure Strip (Item    : in out T;
                    Pattern : Char_Set;
                    Test    : Membership := Inside) is
      First : Positive;
      Last  : Natural;
   begin
      loop
         Fixed.Find_Token (Source => Item.Data (1 .. Item.Last),
                           Set    => Pattern,
                           Test   => Test,
                           First  => First,
                           Last   => Last);
         exit when Last = 0;
         Item.Strip (First, Last);
      end loop;
   end Strip;

   procedure Strip (Item    : in out T;
                    Pattern : Str) is
      I : Natural;
   begin
      loop
         I := Item.Find (Pattern);
         exit when I = 0;
         Item.Strip (I, I + Pattern'Length - 1);
      end loop;
   end Strip;

   procedure Trim (Item    : in out T;
                   Pattern : Char_Set := Sets.Spaces;
                   Side    : Trim_End := Both) is
   begin
      if Side = Both or else Side = Left then
         Item.Find (Pattern, Outside, Forward);
      end if;

      if Side = Both or else Side = Right then
         Item.Find (Pattern, Outside, Backward);
      end if;
   end Trim;

   procedure Tail (Item : in out T; Count : Positive) is
   begin
      Item.Strip (Item.Last - Count, Going => Forward);
   end Tail;

end Lib.Text;
