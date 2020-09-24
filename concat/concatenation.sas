/* 
   if name = 'Andy' and age is 35
   what we end up with is
   "Andy, Age: 35"
*/

data report(keep=combo);
 set sashelp.class;
 combo = cats(name, ', Age: ', age);
run;

/* older way of concatenation */

data report(keep=combo);
 set sashelp.class;
 combo = trim(name) || ', Age: ' || trim(age);
run;

/* back to the CAT functions! 
   Example output: "Andy,35,175,75.5"
*/

data csv (keep=extract);
 set sashelp.class;
 extract = catx(',', name, age, weight, height);
run;

/* Using shortcut of variable list */

data all (keep=full);
 set sashelp.class;
 full = catx(',', of name--weight);
run;

/* 
   other examples of variable lists in functions
   of month1 - month12 (this includes all 12 months)
   of month: (this includes any variable beginning with 'month')
   of _ALL_   (this includes all variables)
*/
