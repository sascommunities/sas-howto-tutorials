/*****************************************************/
/* Demo 2: Using SAS Libraries on the Compute Server */
/*****************************************************/

/* Library visible in Library Connections */

LIBNAME sasLib base "home/student/Courses/PGVY/data";

PROC FREQ data=sasLib.orders;      
     TABLES Country /nocum nopercent; 
RUN;