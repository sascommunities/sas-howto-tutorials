data work.salesrange;
  set sashelp.shoes;
  length salesCat $9;
  if sales lt 100000 then salesCat ="Class_A";
  else if sales le 200000 then salesCat="Class_AA";
  else if sales >  200000 then salesCat="Class_AAA";
run;

proc freq data=work.salesrange;
  table salesCat;
run;

proc means data= work.salesrange min max;
  class salesCat;
  var sales;
run;
  