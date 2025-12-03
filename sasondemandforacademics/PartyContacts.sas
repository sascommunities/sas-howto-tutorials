libname party xlsx "<insert-path>/party.xlsx";

title "Party invitation contact information";

proc sql;
select *
	from party.invited inner join party.contacts 
	on Name=First_Name ;
quit;

*libname party close;
