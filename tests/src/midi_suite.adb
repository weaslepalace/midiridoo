--
-- tests/midi_suite.adb
--

with Midi_Parser_Test;

with AUnit.Test_Caller;

package body Midi_Suite is

	package Midi_Parser_Caller is
		new AUnit.Test_Caller (Midi_Parser_Test.Test);

	function Suite return AUnit.Test_Suites.Access_Test_Suite is
		Result : constant Access_Test_Suite := new Test_Suite;
	begin
		Result.Add_Test (
			Midi_Parser_Caller.Create (
				"Read MIDI bytes from file"
				, Midi_Parser_Test.Read_MIDI_Bytes_From_File'Access
			)
		);
		return Result;
	end Suite;

end Midi_Suite;
