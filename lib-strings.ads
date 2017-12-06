package Lib.Strings is

   type Suite is record
      Count : Integer;
      Set   : Char_Set;
   end record;

   type Sub is record
      First : Positive := 1;
      Last  : Natural  := 0;
   end record;

   type Char_Suite is array (Positive range <>) of Suite;
   type Sub_Array  is array (Positive range <>) of Sub;

   function "&" (Left : Str; Right : Suite) return Char_Suite;
   function "&" (Left : Suite; Right : Str) return Char_Suite;

   function "&" (Left : Char_Suite; Right : Str) return Char_Suite;
   function "&" (Left : Str; Right : Char_Suite) return Char_Suite;

   function Any (Set : Char_Set) return Suite;

   function Get (Item    : Str;
                 Pattern : Char_Suite) return Str;

   function Get (Item    : Str;
                 Pattern : Suite) return Str;

   function Suites (Item    : Str;
                    Pattern : Char_Suite) return Sub_Array;

   function Suites (Item    : Str;
                    Pattern : Suite) return Sub_Array;

   function Lines (Item : Str) return Sub_Array;

   function Slice (Item : Str;
                   Span : Sub) return Str;

   function Split (Item      : Str;
                   Separator : Char) return Sub_Array;

   function Words (Item : Str) return Sub_Array;

   function Split (Item      : Str;
                   Separator : Char_Set) return Sub_Array;

   type Token is record
      Key   : Char;
      Value : Char_Set;
   end record;

   type Token_Sequence is array (Positive range <>) of Token;

   Null_Sequence : constant Token_Sequence := (1 .. 0 => <>);

   function To_Suite (Pattern  : Str;
                      Matching : Token_Sequence := Null_Sequence) return Char_Suite;
end Lib.Strings;
