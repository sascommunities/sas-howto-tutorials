/*Read in the data*/
%deltable(table=work.import)

FILENAME REFFILE FILESRVC FOLDERPATH='/YOURDIRECTORY'  FILENAME='Heath data.xlsx';

PROC IMPORT DATAFILE=REFFILE
	DBMS=XLSX
	OUT=WORK.IMPORT;
	GETNAMES=YES;
RUN;

proc sql noprint;
	create table work.filter as select * from WORK.IMPORT
		where(Shoot_cm_2009 NE .);
quit;

ods noproctitle;
ods graphics / imagemap=on;

/*Recode values*/
data work.wide;
	set work.filter; 
	Drought = treatment;
	select (treatment);
		when ('Control') Drought='NoDrought';
		when ('D') Drought='Drought';
		when ('N') Drought='NoDrought';
		when ('D+N') Drought='Drought';
		otherwise Drought=treatment;
	end;
	N_Fert = treatment;
	select (N_Fert);
		when ('Control') N_Fert='No_N_Fert';
		when ('D') N_Fert='No_N_Fert';
		when ('N') N_Fert='N_Fert';
		when ('D+N') N_Fert='N_Fert';
		otherwise N_Fert=treatment;
	end;
run;

/*Overparameterized model*/
proc mixed data=WORK.WIDE method=reml plots=(residualPanel) alpha=0.05;
	class Heathland_site Drought N_Fert Block Treatment;
	model Shoot_cm_2009=Heathland_site Drought N_Fert Heathland_site*Drought 
		Heathland_site*N_Fert Drought*N_Fert Heathland_site*Drought*N_Fert /;
run;

/*Mixed model covering one year alone.*/
proc mixed data=WORK.WIDE method=reml plots=(residualPanel) alpha=0.05;
	class Heathland_site Treatment Drought Uniq_Plot_ID Block N_Fert;
	model Shoot_cm_2009=Drought N_Fert Drought*N_Fert /;
	random Intercept Block / type=VC subject=Heathland_site;
run;

/*Transpose the data*/
proc sort data=WORK.wide out=WORK.SORTTempTableSorted;
	by N_Fert Drought 'Heathland_site'n treatment Block;
run;

proc transpose data=WORK.SORTTempTableSorted out=work.long
		prefix=Shoots_CM name=Year;
	var Shoot_cm_2009 Shoot_cm_2010 Shoot_cm_2011;
	by N_fert Drought 'Heathland_site'n treatment Block;
run;

proc delete data=WORK.SORTTempTableSorted;
run;

data work.long;
set work.long;
	drop '_LABEL_'n ;
	Shoots_CM = Shoots_CM1;
	drop '_LABEL_'n Shoots_CM1 Shoots_CM2 Shoots_CM3;
Run;

proc print data=work.long(obs=10);
	title "Subset of Long table";
run;

/*Final Model*/
proc mixed data=WORK.LONG method=reml plots=(studentPanel) alpha=0.05;
	class N_Fert Drought Heathland_site Treatment Block Year;
	model Shoots_CM=N_Fert Drought N_Fert*Drought / solution;
	random Intercept Block / type=VC subject=Heathland_site;
	repeated / group=Year;
run;

/*SAS model studio code*/

/* Training code Node #1 . Note this node’s scoring code is left blank*/
proc lmixed  data=&dm_data dmmethod=sparse;
	class N_Fert Drought Heathland_site Treatment Block Year;
	model  %dm_dec_target= N_Fert Drought N_Fert*Drought / solution;
	random  Intercept Block / type=VC subject=Heathland_site;
	random int / group=Year;
	savestate rstore=&dm_data_rstore;
run;


/* Training code Node #2 */
%dmcas_metachange(name=%dm_predicted_var, role=predict, level=interval)

/* Scoring code Node #2 */*/
length %dm_predicted_var 8;
%dm_predicted_var=PRED;

