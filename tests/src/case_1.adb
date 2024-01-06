with Interfaces; use Interfaces;
with AUnit.Assertions; use AUnit.Assertions;

package body Case_1 is

	procedure Run_Test (T : in out Test) is
	begin
		T.X := 12;
		T.Y := 14;
		Assert ( T.X + T.Y = 25, "Addition is incorrect");
	end Run_Test;

end Case_1;
