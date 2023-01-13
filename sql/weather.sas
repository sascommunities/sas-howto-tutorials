*WHERE CLAUSE IN SQL;

/*  Question - Know thy data */
/* 1 SQL Basic Mandatory Clauses */

proc sql;
	select * 
		from weather.JAN2022
;
quit;

/* Question - Curious: What Days Are We Going To Get The Most Snow? */
/* 2 Introduce the WHERE clause */

proc sql;
	select * 
		from weather.jan2022
			where TotalSnowCm > 20
;
quit;

*ACTION -multiple layers, snow boots, serious shoveling ahead;

/* Question - How Can I Filter On the Fahrenheit Equivalent? */
/* 3. Building And Filtering A Column */

proc sql;
	select Date, TotalSnowCm,weather, temp5pmC, 
		   (temp5pmC * 1.8 ) + 32 as TempF
		from weather.jan2022
;
quit;

*45 F Is Cold. 20 F Is Very Cold And Below That Is Very Very Cold;

proc sql;
	select Date, TotalSnowCm, weather, temp5pmC, 
		   (temp5pmC * 1.8 ) + 32 as TempF
		from weather.jan2022
			where  TempF <=20
;
quit;

*Try The Calculated Keyword;
proc sql;
	select Date,TotalSnowCm, SnowOnGroundCM, weather, temp5pmC, 
	       (temp5pmC * 1.8 ) + 32 as TempF
		from weather.jan2022
			where calculated TempF <=20
;
quit;

/* Question - Curious: What Gear To Wear When Its Windy AND Snowing */
/* 4 Complex Where, Using The Logical Operator AND. */

proc sql;
	select * 
		from weather.jan2022
			where WindChillC  > -20  and totalsnowcm > 0
;
quit;

*ACTION - Snow pants & Give Myself Plenty Of Time To Get To The Dog Park;

/* Question - Curious - What To Wear When Its Freezing OR Icy */
/* 5 Special Where, IN Operator For A List Of Values Instead Of OR */

*Get To Know Data Values For Columns Using PROC FREQ;
proc freq data=weather.jan2022;
 tables weather comments;
run;

proc sql;
	select * 
		from weather.jan2022
			where weather = 'freezing' or weather='icy'
;
quit;

proc sql;
	select * 
		from weather.jan2022
			where weather in ( 'freezing', 'icy')
;
quit;

*ACTION  Wear Snowpants, Layer Up, Snow Boots, Cleats Plus Dog Boots;

/* Question - Curious - How Do I Look for Variations On Freez */
/* 6 Looking For A Pattern */

proc sql;
	select *
		from weather.jan2022
			where comments like '%freez%'
;
quit;

* ACTION - Snow Ploughs/Salt Trucks Indicate Mean Roads That Can Burn Paws;

/* Question - How Many Snow/No Snow Days In January */
/* 7 Filtering Using The Boolean */

proc sql;
	select *
		from weather.jan2022
			where TotalSnowCm = .
;
quit;

proc sql;
	select *
		from weather.jan2022
			where TotalSnowCm Is Missing
;
quit;

proc sql;
	select *
		from weather.jan2022
			where TotalSnowCm Is Null
;
quit;

proc sql;
	select date, (TotalSnowCm >0) as Snow,
				 (TotalSnowCm = .) as NoSnow
		from weather.jan2022			
;
quit;

proc sql;
	select sum(TotalSnowCm > 0) as Snow,
		   sum(TotalSnowCm = .) as NoSnow
		from weather.jan2022
;
quit;

/* ACTION - Maybe I Can Talk With My Insurance Company To Give Me A Price Break :) */

