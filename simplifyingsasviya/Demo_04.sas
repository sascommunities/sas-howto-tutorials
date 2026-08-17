/***************************************/
/* Demo 4: Exploring Caslib Attributes */
/***************************************/

/* Reset session */

CAS CJsSession;

/* View attributes of CASUSER caslib */

CASLIB casuser list;

/* Creating a new caslib changes the active caslib */

CASLIB viyacas PATH="home/student/Courses/PGVY/data" LIBREF=viyacas;

CASLIB viyaCas list;

CASLIB casuser list;