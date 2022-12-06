/*Wide-to-Narrow Transpose*/

/*Step 1: Look at the default output (true transpose)*/
proc transpose data=acura_wide;
run;

/*Step 2: Make it a wide-to-narrow transpose*/
proc transpose data=acura_wide;
	by Model;
run;

/*Step 3: Tranpose Type, MPG_City, and MPG_Highway (no MSRP or EngineSize)*/
proc transpose data=acura_wide;
	by Model;
	var Type MPG_City MPG_Highway;
run;

/*Step 4: Bring Type over as a separate variable*/
proc transpose data=acura_wide;
	by Model Type;
	var MPG_City MPG_Highway;
run;

/*Step 5: Rename the output table*/
proc transpose data=acura_wide out=acura_narrow;
	by Model Type;
	var MPG_City MPG_Highway;
run;

/*Step 6: Rename the _NAME_ variable*/
proc transpose data=acura_wide out=acura_narrow name=Stat;
	by Model Type;
	var MPG_City MPG_Highway;
run;

/*Step 7: Rename the COLn variable*/
proc transpose data=acura_wide out=acura_narrow(rename=(COL1=Value)) name=Stat;
	by Model Type;
	var MPG_City MPG_Highway;
run;
