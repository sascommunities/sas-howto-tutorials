libname party xlsx "C:/Users/doweat/Desktop/SAS Users tutorial/party.xlsx";

title "Party invitation contact information";

proc sql;
select *
	from party.invited inner join party.contacts 
	on Name=First_Name ;
quit;

*libname party close;
