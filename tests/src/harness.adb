with Midi_Suite;
with AUnit.Run;
with AUnit.Reporter.Text;

procedure Harness is
	procedure Runner is new AUnit.Run.Test_Runner (Midi_Suite.Suite);
	Reporter : AUnit.Reporter.Text.Text_Reporter;
begin
	Runner (Reporter);
end Harness;
