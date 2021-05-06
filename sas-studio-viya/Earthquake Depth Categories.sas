data work.earthquakes;
    set sashelp.quakes;
    length Depth_Cat $ 12;
    Magnitude=round(Magnitude, .1);
    if Depth<70 then Depth_Cat="Shallow";
    if Depth<300 then Depth_Cat="Intermediate";
    if Depth<=700 then Depth_Cat="Deep";
run;