* SAS Users YouTube Channel - Merging Data Sets in SAS using SQL;

* Complete the LIBNAME statement to point to the location where you have saved the SAS data sets;

libname join /*replace this comment with the quoted file path to the directory with your SAS data sets*/;

* PROC SQL - INNER JOIN 
Only rows of data where the student ID was found in both tables;
proc sql;
	select sc.*, sg.gpa
		from join.student_contact as sc
			inner join
	 		join.student_grades as sg
	on sc.student_ID = sg.student_ID
;
quit;

* PROC SQL - LEFT JOIN 
Include Tammy's information because she is in student_contact; 
proc sql;
	select sc.*, sg.gpa
		from join.student_contact as sc
			left join
	 		join.student_grades as sg
	on sc.student_ID = sg.student_ID
;
quit;