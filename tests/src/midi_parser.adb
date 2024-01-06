with AUnit.Assertions; use AUnit.Assertions;

package body Midi_Parser is

	procedure Set_Up (T : in out Test) is
	begin
		Byte_IO.Open (T.file_handle, Byte_IO.In_File, File_Name);
	end Set_Up;

	procedure Tear_Down (T : in out Test) is
	begin
		Byte_IO.Close (T.file_handle);
	end Tear_Down;

	procedure Read_MIDI_Bytes_From_File (T : in out Test) is
		byte : Unsigned_8;
	begin

		Byte_IO.Read (T.file_handle, byte);
		Assert (byte = 16#4D#, "Incorrect header byte 0");

	end Read_MIDI_Bytes_From_File;

end Midi_Parser;
