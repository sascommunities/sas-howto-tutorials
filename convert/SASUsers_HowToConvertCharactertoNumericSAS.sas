* SAS Users YouTube Channel - How to convert character to numeric in SAS;

libname lib /*remove this comment and include the directory path to your SAS data sets */;

* CHARACTER TO NUMERIC; 
* Creating the DATE, numeric column before dropping, renaming, or formatting columns; 
data race_new;
	set lib.race;
	date = input(race_date,date9.);
run;

* Dropping, renaming, and formatting columns;
data race_new;
	set lib.race(rename=(race_date=old));
	race_date = input(old,date9.);
	drop old;
	format race_date mmddyy10.; 
run;

* NUMERIC TO CHARACTER;
* Creating our two character columns;
data NC_id;
	set lib.NC_data;
	area_c = put(areacode, 3.);
	county_c = put(county, z3.);
	* creating the NC_tag column; 
	NC_tag = catx('_',statecode,county_c,area_c);
	drop area_c county_c;
run;