/*Narrow-to-Wide Transpose*/

/*Step 1: Look at the default output (true transpose)*/
proc transpose data=acura_narrow;
run;

/*Step 2: Make it a narrow-to-wide transpose*/
proc transpose data=acura_narrow;
	by Model;
run;

/*Step 3: Rename the COLn variables*/
proc transpose data=acura_narrow;
	by Model;
	id Stat;
run;

/*Step 4: Only transpose value (no MSRP)*/
proc transpose data=acura_narrow;
	by Model;
	id Stat;
	var Value;
run;

/*Step 5 Tranpose all Stat values except EngineSize*/
proc transpose data=acura_narrow;
	by Model;
	id Stat;
	var Value;
	where Stat ne "Engine Size";
run;

/*Step 6: Bring Type over as a separate variable*/
proc transpose data=acura_narrow;
	by Model Type;
	id Stat;
	var Value;
	where Stat ne "EngineSize";
run;

/*Step 7: Rename the output table*/
proc transpose data=acura_narrow out=acura_wide;
	by Model Type;
	id Stat;
	var Value;
	where Stat ne "EngineSize";
run;

/*Step 8: Remove the _NAME_ variable*/
proc transpose data=acura_narrow out=acura_wide(drop=_NAME_);
	by Model Type;
	id Stat;
	var Value;
	where Stat ne "EngineSize";
run;
