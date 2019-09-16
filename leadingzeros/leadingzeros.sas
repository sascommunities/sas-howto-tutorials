data customer;
	infile datalines dlm="|";
	input CustomerID: 8. Zip: 8. City:$25. Income: 8. CreditScore: 8. Value 8.;
	datalines4;
1928446490 |55901 |Rochester |6833.58 |596 | 67.04
1900730536 |07010 |Cliffside Park |. |746 | 6.02
1960231260 |07203 |Roselle |64183.78 |585 | 59.12
1995545096 |07087 |Union City |65974.21 |662 | .38
1943535328 |01850 |Lowell |. |657 | .26
1989152037 |01752 |Marlborough |63857.83 |660 | 11.2
1989638715 |31901 |Columbus |. |682 | 4.78
1953531885 |30042 |Lawrenceville |47999.48 |711 | 31.82
1908378591 |60502 |Aurora |58486 |695 | 41.11
1944290137 |01850 |Lowell |. |689 | .79
1908316871 |52627 |Fort Madison |72123.43 |644 | .2333
1987648131 |47701 |Evansville |. |667 | 1.8
1941732136 |47801 |Terre Haute |59351.19 |. | 61.1
1993690772 |71291 |West Monroe |. |616 | 3.7888
1963535911 |07101 |Newark |52353.55 |676 | 25.062
;;;;
run;


/*Documentation - https://go.documentation.sas.com/?docsetId=ds2ref&docsetTarget=p1h8l8v2o11xhnn1oue05oue1hvx.htm&docsetVersion=3.1&locale=en*/
/*Z Format - Writes standard numeric data with leading 0s.*/
