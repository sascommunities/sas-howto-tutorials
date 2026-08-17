/*********************************************/
/* Demo 3: Creating a CAS Session and Caslib */
/*********************************************/

/* Create a CAS session to connect to the CAS server */

CAS CJsSession;

/* Create a caslib for data in the PGVY/data folder */
/* Is the caslib visible in Libraries? */

CASLIB dataCaslib PATH="home/student/Courses/PGVY/data";

/* Reset session */

CAS CJsSession;

/* Map a libref to caslib with LIBREF= */

CASLIB viyacas PATH="home/student/Courses/PGVY/data" LIBREF=viyacas;

/* What if you have a caslib but it's not mapped to a libref? */
/* View all predefined caslibs */

CASLIB _all_ list;

/* Use libname statement to map libref to predefined caslib */

LIBNAME mpd CAS CASLIB=ModelPerformanceData;