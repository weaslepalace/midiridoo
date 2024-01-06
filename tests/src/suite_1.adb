with Case_1; 
with Case_2;

with AUnit.Test_Caller;

package body Suite_1 is

	package Caller_1 is new AUnit.Test_Caller (Case_1.Test);
	package Caller_2 is new AUnit.Test_Caller (Case_2.Test);

	function Suite return AUnit.Test_Suites.Access_Test_Suite is
		Result : constant Access_Test_Suite := new Test_Suite;
	begin
		Result.Add_test (Caller_1.Create ("Test addition #1", Case_1.Run_Test'Access));
		Result.Add_Test (Caller_2.Create ("Test addition #2", Case_2.Test_Addition'Access));
		Result.Add_Test (Caller_2.Create ("Test subtraction", Case_2.Test_Subtraction'Access));
		return Result;
	end Suite;

end Suite_1;
