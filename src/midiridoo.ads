--
-- midiridoo.ads
--

with Interfaces; use Interfaces;

package Midiridoo is
   
   type Status is (
      OKAY
      , NOT_OKAY
   );

   type Byte_Counter is range 0..4;
   subtype String_Byte_Counter is Integer range 1..256;

   type Midi_String is new String (String_Byte_Counter'Range);

   type State is (
      FIND_HEADER
      , FIND_HEADER_LENGTH
      , FIND_MIDI_FORMAT
      , FIND_NUMBER_OF_TRACKS
      , FIND_TIME_DIVISION
      , FIND_TRACK_HEADER
      , FIND_TRACK_HEADER_LENGTH
   );

   type Parser_State_Machine is tagged record
      string_byte_count : String_Byte_Counter := 1;
      byte_count : Byte_Counter := 0;
      parser_state : State := FIND_HEADER;
      value : Unsigned_32 := 0;
      string_accumulator : Midi_String;
   end record;

   function Parse_Midi (
      self : access Parser_State_Machine;
      new_byte : Unsigned_8
   )
   return Status;

   function Get_Byte_Count ( self : access Parser_State_Machine )
   return Byte_Counter;
  
   function Get_Parser_State ( self : access Parser_State_Machine )
   return State;

   function Get_Value ( self : access Parser_State_Machine )
   return Unsigned_32;

   function Get_String_Byte_Count ( self : access Parser_State_Machine )
   return String_Byte_Counter;

   function Get_String ( self : access Parser_State_Machine )
   return Midi_String;

end Midiridoo;
