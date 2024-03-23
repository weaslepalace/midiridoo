--
-- midiridoo.adb
--

with Ada.Strings.Fixed; use Ada.Strings.Fixed;

package body Midiridoo is

   subtype Accumulator_Range is Byte_Counter range 0 .. 3;
   type Accumulator_Array is array (Accumulator_Range'Range) of Unsigned_8;
   for Accumulator_Array'Size use 32;
   type Accumulator_Access is access Accumulator_Array;
   accumulator : Accumulator_Array;

   procedure Reset_Accumulator is
   begin
      for index in accumulator'Range loop
         accumulator(index) := 0;
      end loop;
   end Reset_Accumulator;

   function Get_Accumulator
   return Unsigned_32 is
      accum_access
         : constant Accumulator_Access
         := new Accumulator_Array'(accumulator);
      accum_32 : Unsigned_32 with Address => accum_access.all'Address;
   begin 
      return accum_32;
   end Get_Accumulator;

   function Parse_Midi (
      self : access Parser_State_Machine;
      new_byte : Unsigned_8
   )
   return Status is
      parse_status : Status := NOT_OKAY;
      
--      type Header_Array is array (Byte_Counter range 0 .. 3) of Unsigned_8;
--      Header_Bytes : constant Header_Array := (16#4D#, 16#54#, 16#68#, 16#64#);
--      Header_Length_Bytes : constant Header_Array := (16#00#, 16#00#, 16#00#, 16#06#);
 
   begin

      case self.parser_state is

         when FIND_HEADER => 
            parse_status := OKAY;
            self.string_accumulator(self.string_byte_count) := Character'Val(Integer(new_byte));
            self.string_byte_count := self.string_byte_count + 1;
            if self.string_byte_count > 4 then
               self.string_byte_count := 1;
               self.byte_count := 0;
               self.parser_state := FIND_HEADER_LENGTH;
               self.value := 0;
               Reset_Accumulator;
            end if;

         when FIND_HEADER_LENGTH =>
            parse_status := OKAY;
            accumulator(3 - self.byte_count) := new_byte;
            self.byte_count := self.byte_count + 1;
            if self.byte_count = 4 then
               self.byte_count := 0;
               self.parser_state := FIND_MIDI_FORMAT;
               self.value := Get_Accumulator;
               Reset_Accumulator;
            end if;

         when FIND_MIDI_FORMAT =>
            parse_status := OKAY;
        	accumulator(1 - self.byte_count) := new_byte;
		 	self.byte_count := self.byte_count + 1;
			if self.byte_count = 2 then
               self.byte_count := 0;
               self.parser_state := FIND_NUMBER_OF_TRACKS;
               self.value := Get_Accumulator;
               Reset_Accumulator;
            end if;
    
         when FIND_NUMBER_OF_TRACKS =>
            parse_status := OKAY;
            accumulator(1 - self.byte_count) := new_byte;
            self.byte_count := self.byte_count + 1;
            if self.byte_count = 2 then
               self.byte_count := 0;
               self.parser_state := FIND_TIME_DIVISION;
               self.value := Get_Accumulator;
               Reset_Accumulator;
            end if;

         when FIND_TIME_DIVISION =>
            parse_status := OKAY;
            accumulator(1 - self.byte_count) := new_byte;
            self.byte_count := self.byte_count + 1;
            if self.byte_count = 2 then
                self.byte_count := 0;
                self.parser_state := FIND_HEADER;
                self.value := Get_Accumulator;
                Reset_Accumulator;
            end if;

         when FIND_TRACK_HEADER_LENGTH => 
            parse_status := OKAY;
            accumulator(1 - self.byte_count) := new_byte;
            self.byte_count := self.byte_count + 1;
            if self.byte_count = 2 then
                self.byte_count := 0;
                self.parser_state := FIND_HEADER;
                self.value := Get_Accumulator;
                Reset_Accumulator;
            end if;

         when others =>
            self.byte_count := 0;
            parse_status := NOT_OKAY;
            self.parser_state := FIND_HEADER;
            self.value := 0;
            Reset_Accumulator;

      end case;

      return parse_status;
         
   end Parse_Midi;

   function Get_Byte_Count ( self : access Parser_State_Machine )
   return Byte_Counter is
   begin
      return self.byte_count;
   end Get_Byte_Count;

   function Get_Parser_State ( self : access Parser_State_Machine )
   return State is
   begin
      return self.parser_state;
   end Get_Parser_State;

   function Get_Value ( self : access Parser_State_Machine )
   return Unsigned_32 is
   begin
      return self.value;
   end Get_Value;

   function Get_String_Byte_Count ( self : access Parser_State_Machine )
   return String_Byte_Counter is
   begin
      return self.string_byte_count;
   end Get_String_Byte_Count;

   function Get_String ( self : access Parser_State_Machine )
   return Midi_String is
   begin
      return self.string_accumulator;
   end Get_String;

end Midiridoo;
