with Suite_1;
with AUnit.Run;
with AUnit.Reporter.Text;

procedure Harness is
	procedure Runner is new AUnit.Run.Test_Runner (Suite_1.Suite);
	Reporter : AUnit.Reporter.Text.Text_Reporter;
begin
	Runner (Reporter);
end Harness;
