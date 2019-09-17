********************
*  ACCESS DATA     *
********************;
%let path=C:\Users\YouTubeFiles; /*Location of the CSV files*/
options validvarname=v7; /*Follow rules for SAS column names*/


**************************************************;
*  IMPORT a file with headings                   *; 
**************************************************;

********************
*  First Attempt   *
********************;
/*Start import of CSV with headers. Will contain truncation issues because SAS determines length and type from the first 20 rows by default*/
proc import datafile="&path\cars.csv" 
            out=cars 
  			dbms=csv replace;
run;


********************
*  Second Attempt  *
********************;
/*Fix truncation issues*/
proc import datafile="&path\cars.csv" 
            out=cars 
  			dbms=csv replace;
	guessingrows=max; /*Allows SAS to scan all rows in every column to determine the exact length and type needed*/
run;





*****************************************************;
* IMPORT a file without headings and row starts at 6*; 
*****************************************************;

********************
*  First Attempt   *
********************;
/*Uses line 1 as column names even thought CSV file doesn't contain colum names, begins data import at line 2 which contains a comment*/
proc import datafile="&path\cars_noheaders.csv" 
            out=cars
  			dbms=csv replace;
	guessingrows=max;
run;


/*Specifies no column headers in the CSV file, begins data import on line 6, adds column names manually*/
proc import datafile="&path\cars_noheaders.csv" 
            out=cars(rename=(Var1=Make Var2=Model)) /*Use RENAME= to add column names*/
  			dbms=csv replace;
	guessingrows=max;
	getnames=no; /*Does not use column names from the CSV file*/
	datarow=6; /*Begins data import on line 6*/
run;