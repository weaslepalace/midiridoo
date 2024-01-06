with AUnit;
with AUnit.Test_Fixtures;
with Interfaces; use Interfaces;

package Case_2 is

	type Test is new AUnit.Test_Fixtures.Test_Fixture with record
		I1 : Integer_32;
		I2 : Integer_32;
	end record;

	procedure Set_Up (T : in out Test);

	procedure Test_Addition (T : in out Test);
	procedure Test_Subtraction (T : in out Test);

end Case_2;
