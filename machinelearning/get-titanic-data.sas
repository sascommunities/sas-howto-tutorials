/* SAS program to fetch Titanic passenger manifest */
/* from Vanderbilt BioStat repository              */
filename data temp;
proc http
 url="http://biostat.mc.vanderbilt.edu/wiki/pub/Main/DataSets/titanic3.csv"
 method="GET"
 out=data;
run;

proc import out=titanic
 datafile=data
 dbms=csv
 replace;
run;

 