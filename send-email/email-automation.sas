/***************************************************************************************************
* Author:     Daniel Rodda from DRDataServices.com
* Created:    4/18/2021
* Purpose:  SAS Email Automation
*
*
***************************************************************************************************/
options validvarname=any;
%let path = /home/yourid;

/* pretending like we're sending official notices */
%let fromemail = official@nationalsafety.gov;
%let smtp = smtp.nationalsafety.gov;

/* to hold our Excel file with Cars data */
libname x XLSX "&path/cars.xlsx";

data _null_;
	call symput ('datenow',put (date(),date9.));
	call symput ('range',put (date()-30,date9.));
	call symput ('due',put (date()+30,date9.));
run;

* add Metric to filter on -- Model Count in this case;
* also add an email for each make, fictitious in this case;
Proc sql;
	create table x.make as
		select * , 
			cats('safety@',make,'-company.com') as email, 
			Count(model) as Model_Count
		from sashelp.cars
			Where make in ('Ford', 'Toyota', 'Kia','Acura', 'Audi', 'BMW' )
				group by make;
quit;

*Folder creation;
%Macro folders(Make);
	data _null_;
		NewDirectory=dcreate("&Make", "&path");
	run;
%Mend folders;

*Reports generated;
%Macro reports(make);
	Libname r XLSX "&path/&make/&make._&datenow..xlsx";
	proc sql;
		create table r.&make as
			select Make, model, Count(model) as Model_Count
				from x.make 
					where make = "&make";
	quit;
%mend reports;

data _null_;
	set x.make;
	by make;
	if first.make then
		do;
			call execute(cats('%folders(',make,')'));
			call execute(cats('%reports(',make,')'));
		end;
run;

*******Send Reports via email*****;
%macro sendreports(Email, Make, Model_Count);
 filename outbox EMAIL;
 data _null_;
  FILE outbox
		to=("&email" ) 
		/* to=( "&backup1" "&backup2" "&backup3") */
		from=("&fromemail")
		sender=("&fromemail")
		bcc=" "
		cc=" "
		replyto="&fromemail"
		importance="HIGH"
		sensitivity="CONFIDENTIAL"
		subject="NHTSA: &make Recall"
		attach=("&path/&make/&make._&datenow..xlsx");

	file outbox;
	put "Dear &make.,";
	put;
	put "National Highway Traffic Safety Administration (NHTSA) has identified &Model_count of your models as having potentially faulty airbags.";
	put "Thank you,";
	put "NHTSA Data Team";
  run;
%mend sendreports;

*SMTP FOR BASE SAS and EG;
*Configure per your email setup, might need to work with IT;
Options EMAILSYS=SMTP EMAILID ="&fromemail"
	EMAILHOST="&smtp" EMAILPORT=25;

data _null_;
	set x.make;
	by make;
	if first.make then
		do;
			call execute(cats('%sendreports(',Email,',',Make,',',Model_Count,')'));
		end;
run;

****Send text message of run status***;
* can use email to send a text, usually your phone number@carrier domain;
* example: 9195551212@txt.att.net;
%let phone = 9195551212@txt.att.net;
filename msg email to="&phone" 
	FROM = "SAS Bot <&fromemail.>"
	subject="SAS Program Successfully Ran";

data _null_;
	file msg;
	put "NHTSA data report ran";
run;

libname x clear;
libname r clear;