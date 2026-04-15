/* SAS Dates and Formatting */

data example;
    start_date = "01FEB2019"d;
    format start_date Monyy7.;
run;
proc print data = example;
run;

/* Creating Sample Data */
data my_transactions;
format purchase_dt date9.;
    do i = 1 to 100;
        purchase_dt = '01JAN2025'd + floor(ranuni(1234) * 91); /* Random date between Jan 1, 2025, and April 1, 2025 */
        amount = floor(ranuni(1234) * 251); /* Random amount between 0 and 250 */
        output;
    end;
    drop i;
run;

/* Summarize data with PROC SQL with a format on my date variable */
proc sql;
    create table monthly_sum as
    select purchase_dt format = monyy7.,
            sum(amount) as monthly_sum

    from my_transactions
    group by purchase_dt;
quit;

/* Grouping by a Character Variable */
/* Convert date variable to a character string with MONYY7. format */
DATA transcation_formatted_opt1;
    set my_transactions;
    purchase_date_MONYEAR = put(purchase_dt, MONYY7.);
run;

/* Create a table that SUMS the AMOUNT variable by MONTH using PROC SQL**/
proc sql;
    create table AMT_BY_MONTH_OPT1 as 
    select purchase_date_monyear
            , sum(amount) as MONTHLY_AMOUNT
    from transcation_formatted_opt1
    group by purchase_date_MONYEAR
    ;
quit;

/* print & review the results */
proc print;
run;

/* Grouping by a Numeric Variable */
/* Convert date variable to a date variable with MONYY7. format */
DATA transcation_formatted_opt2;
    set my_transactions;
    purchase_date_MONYEAR = input(put(purchase_dt, MONYY7.),MONYY7.);
    format purchase_date_MONYEAR date9.;
run;

/* Create a table that SUMS the AMOUNT variable by MONTH using PROC SQL**/
proc sql;
    create table AMT_BY_MONTH_OPT2 as 
    select purchase_date_monyear
            , sum(amount) as MONTHLY_AMOUNT
    from transcation_formatted_opt2
    group by purchase_date_MONYEAR
    ;
quit;
/* print & review the results */
proc print;
run;


/* Using the INTNX Function */
/* Use the INTNX function to create a date variable that is the first day of the month for each purchase date */
DATA transcation_formatted_opt3;
    set my_transactions;
    purchase_date_MONYEAR = intnx('MONTH',purchase_dt,0,'BEGINNING');
    format purchase_date_MONYEAR date9.;
run;
/* Create a table that SUMS the AMOUNT variable by MONTH using PROC SQL**/
proc sql;
    create table AMT_BY_MONTH_OPT3 as 
    select purchase_date_monyear
            , sum(amount) as MONTHLY_AMOUNT
    from transcation_formatted_opt3
    group by purchase_date_MONYEAR
    ;
quit;
/* print & review the results */
proc print;
run;

/* Summarizing with PROC MEANS */
proc means data = my_transactions;
    var amount; 
    class purchase_dt;
    format purchase_dt monyy7.;
    output out = AMT_BY_MONTH_OPT3 sum = AMOUNT;
run;


