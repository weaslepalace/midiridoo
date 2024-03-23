--
-- midi_parser-test.adb
--

with Midiridoo;
with AUnit.Assertions; use AUnit.Assertions;
with Ada.Text_IO;
with Ada.Integer_Text_IO;

with Ada.Strings.Fixed; use Ada.Strings.Fixed;

package body Midi_Parser_Test is

   procedure Set_Up (T : in out Test) is
   begin
      Byte_IO.Open (T.file_handle, Byte_IO.In_File, File_Name);
   end Set_Up;

   procedure Tear_Down (T : in out Test) is
   begin
      Byte_IO.Close (T.file_handle);
   end Tear_Down;

   procedure Read_MIDI_Bytes_From_File (T : in out Test) is
      use Midiridoo;
      byte : Unsigned_8;
      parse_status : Midiridoo.Status := Status'(NOT_OKAY);
      parser : aliased Midiridoo.Parser_State_Machine;
      subtype Header_Byte_Counter is String_Byte_Counter range 1 .. 4;
      subtype Byte_Counter_2 is Byte_Counter range 0 .. 1;
      subtype Byte_Counter_4 is Byte_Counter range 0 .. 3;

   begin

      for i in Header_Byte_Counter'Range loop
         Byte_IO.Read (T.file_handle, byte);
         parse_status := parser.Parse_Midi (byte);
         Assert (
            parse_status = Midiridoo.Status'(OKAY),
            "Incorrect header byte" & i'Image
         );
         Assert (
            parser.Get_String_Byte_Count = (i mod 4) + 1,
            "Incorrect byte count after parsing header byte" & i'Image & parser.Get_String_Byte_Count'Image
         );
      end loop; 
      Assert (
         parser.Get_String (1 .. 4) = "MThd",
         "Invalid string for Header " & String(parser.Get_String)
      );
 
      for i in Byte_Counter_4'Range loop
         Byte_IO.Read (T.file_handle, byte);
         parse_status := parser.Parse_Midi (byte);
         Assert (
         	parse_status = Midiridoo.Status'(OKAY),
         	"Incorrect header length byte" & i'Image & byte'Image
         );
         Assert (
         	parser.Get_Byte_Count = (i + 1) mod 4,
         	"Incorrect byte count after parsing header length byte" & i'Image & parser.Get_Byte_Count'Image
         );
      end loop;
      Assert (
         parser.Get_Value = 6,
         "Invalid value for Header Byte Count" & parser.Get_Value'Image
      );
   
      for i in Byte_Counter_2'Range loop
         Byte_IO.Read (T.file_handle, byte);
         parse_status := parser.Parse_Midi (byte);
         Assert (
            parse_status = Midiridoo.Status'(OKAY),
            "Parser data error" & i'Image & byte'Image
         );
         Assert (
            parser.Get_Byte_Count = Byte_Counter((i + 1) mod 2),
            "Incorrect byte count after parsing MIDI format byte" & i'Image
         );
      end loop;
      Assert (
         parser.Get_Value = 0,
         "Invalid value for MIDI format" & parser.Get_Value'Image
      );
   
      for i in Byte_Counter_2'Range loop
         Byte_IO.Read (T.file_handle, byte);
         parse_status := parser.Parse_Midi (byte);
         Assert (
            parse_status = Midiridoo.Status'(OKAY),
            "Parser data error" & i'Image & byte'Image
         );
         Assert (
            parser.Get_Byte_Count = Byte_Counter((i + 1) mod 2),
            "Incorrect byte count after parsing Number Of Tracks byte" & i'Image
         );
      end loop;
      Assert (
         parser.Get_Value = 1,
         "Invalid value for Number Of Tracks" & parser.Get_Value'Image
      );
   
      for i in Byte_Counter_2'Range loop
         Byte_IO.Read (T.file_handle, byte);
         parse_status := parser.Parse_Midi (byte);
         Assert (
            parse_status = Midiridoo.Status'(OKAY),
            "Parser data error" & i'Image & byte'Image
         );
         Assert (
            parser.Get_Byte_Count = Byte_Counter((i + 1) mod 2),
            "Incorrect byte count after parsing Time Division" & i'Image
         );
      end loop;
      Assert (
         parser.Get_Value = 16#01E0#,
         "Invalid value for Time Division" & parser.Get_Value'Image
      );

--      for i in Track_ 
   end Read_MIDI_Bytes_From_File;

end Midi_Parser_Test;
