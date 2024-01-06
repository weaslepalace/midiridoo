with AUnit;
with AUnit.Test_Fixtures;
with Interfaces; use Interfaces;

package Case_1 is

	type Test is new AUnit.Test_Fixtures.Test_Fixture with record
		X : Integer_32;
		Y : Integer_32;
	end record;

	procedure Run_Test (T : in out Test);

end Case_1;
