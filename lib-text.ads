with Ada.Strings, Lib.Strings, Lib.Sets;

package Lib.Text is

   type T (Size : Natural) is tagged record
      Last : Natural := 0;
      Data : Str (1 .. Size);
   end record;

   subtype Trim_End   is Ada.Strings.Trim_End;    use all type Trim_End;
   subtype Direction  is Ada.Strings.Direction;   use all type Direction;
   subtype Membership is Ada.Strings.Membership;  use all type Membership;

   function "=" (Left : T; Right : String) return Boolean;

   function "+" (Item : Str) return T;

   function "+" (Item : String) return T;

   procedure Append (Item   : in out T;
                     Source : Str);

   procedure Append (Item   : in out T;
                     Source : T);

   procedure Clear (Item : in out T);

   function Cut (Item    : in out T;
                 Pattern : Char_Set;
                 Test    : Membership := Inside;
                 Going   : Direction  := Forward) return Str;

   function Cut (Item  : in out T;
                 Going : Direction := Forward) return Integer;

   function Cut (Item   : in out T;
                 Length : Natural) return Str;

   procedure Escape (Item    : in out Text.T;
                     Pattern : Char := ' ');

   procedure Find (Item    : in out T;
                   Pattern : Char_Set;
                   Test    : Membership := Inside;
                   Going   : Direction  := Forward);

   procedure Find (Item    : in out T;
                   Pattern : Str;
                   Going   : Direction := Forward);

   function Find (Item    : T;
                  Pattern : Char_Set;
                  Test    : Membership := Inside;
                  Going   : Direction  := Forward) return Natural;

   function Find (Item    : T;
                  Pattern : Str;
                  Going   : Direction := Forward) return Natural;

   function Find (Item    : T;
                  Pattern : Char_Set;
                  From    : Positive;
                  Test    : Membership := Inside;
                  Going   : Direction  := Forward) return Natural;

   function Find (Item    : T;
                  Pattern : Str;
                  From    : Positive;
                  Going   : Direction := Forward) return Natural;

   procedure Get (Item : out T);

   function Get (Item : T) return Str;

   function To_String (Item : T) return String;

   function To_UTF8 (Item : T) return String;

   procedure Head (Item  : in out T;
                   Count : Positive);

   procedure Insert (Item   : in out T;
                     Before : Positive;
                     Source : Str);

   procedure Insert (Item   : in out T;
                     Before : Positive;
                     Source : T);

   function Is_Empty (Item : T) return Boolean is (Item.Last = 0);

   function Lines (Item : T) return Strings.Sub_Array;

   procedure New_Line;

   procedure Put      (Item : T);
   procedure Put_Line (Item : T);

   procedure Set (Item   : in out T;
                  Source : Str);

   procedure Set (Item   : in out T;
                  Source : String);

   procedure Skip (Item    : in out T;
                   Pattern : Char_Set;
                   Test    : Membership := Inside;
                   Going   : Direction  := Forward);

   procedure Skip (Item    : in out T;
                   Pattern : Str;
                   Going   : Direction := Forward);

   function Skip (Item    : T;
                  Pattern : Char_Set;
                  Test    : Membership := Inside;
                  Going   : Direction  := Forward) return Natural;

   function Skip (Item    : T;
                  Pattern : Str;
                  Going   : Direction := Forward) return Natural;

   function Slice (Item : T;
                   Span : Strings.Sub) return Str;

   function Split (Item      : T;
                   Separator : Char) return Strings.Sub_Array;

   procedure Strip (Item  : in out T;
                    Count : Natural;
                    Going : Direction := Forward);

   procedure Strip (Item  : in out T;
                    First : Positive;
                    Last  : Natural);

   procedure Strip (Item    : in out T;
                    Pattern : Char_Set;
                    Test    : Membership := Inside);

   procedure Strip (Item    : in out T;
                    Pattern : Str);

   procedure Tail (Item  : in out T;
                   Count : Positive);

   procedure Trim (Item    : in out T;
                   Pattern : Char_Set := Sets.Spaces;
                   Side    : Trim_End := Both);
end Lib.Text;

--  S.UUID := List.Cut (Pattern => "hhhhhhhh-hhhh-hhhh-hhhh-hhhhhhhhhhhh",
--                      Suite   => ('h' => Sets.Hexadecimal)); -- to_suite to_str_set
--  S.UUID := List.Cut ((1 .. 8 | 10 .. 13 | 15 .. 18 | 20 .. 23 | 25 .. 36 =>
--                          Sets.Hexadecimal, 9 | 14 | 19 | 24 => Sets.Hyphen_Minus));
