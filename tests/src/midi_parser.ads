--
-- tests/midi_parser.ads
--

with AUnit;
with AUnit.Test_Fixtures;
with Interfaces; use Interfaces;
with Ada.Sequential_IO;

package Midi_Parser is
	
	package Byte_IO is new Ada.Sequential_IO (Unsigned_8);

	type Test is new AUnit.Test_Fixtures.Test_Fixture with record
		file_handle : Byte_IO.File_Type;
	end record;

	File_Name : constant String := "share/morse_code_a.mid";

	procedure Set_Up (T : in out Test);
	procedure Tear_Down (T : in out Test);

	procedure Read_MIDI_Bytes_From_File (T : in out Test);

end Midi_Parser;
