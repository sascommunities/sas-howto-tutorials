/**************************************************/
/* Demo 1: Running SAS Code on the Compute Server */
/**************************************************/

/* Data is loaded into and out of memory 3 times */

DATA work.cars_SUV;  
     SET sashelp.cars;  
     WHERE Type= "SUV";  
RUN;
   
PROC MEANS data= work.cars_SUV;  
     VAR MPG_Highway;  
RUN;
   
PROC FREQ data= work.cars_SUV;  
     TABLES Make;  
RUN;