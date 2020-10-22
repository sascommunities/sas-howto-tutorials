/* lines */

%let dl = /r/ge.unx.sas.com/vol/vol610/u61/careis/MadridLines;

/* maps */

%let dm = /r/ge.unx.sas.com/vol/vol610/u61/careis/MadridMaps;

/* cas session */ 

cas;

libname mycas cas sessref=casauto;

/* points of interest */

data places;
	length name $30;
	infile datalines delimiter=",";
	input name $ x y;
datalines;
Museo del Prado,40.413974,-3.692138
Parque de El Retiro,40.415489,-3.684553
Palacio Real,40.418192,-3.714033
Puerta del Sol,40.417184,-3.703494
Gran Via,40.420391,-3.705863
Plaza Mayor,40.415789,-3.707068
Mercado de San Miguel,40.415496,-3.708975
Chocolateria San Gines,40.417050,-3.706770
Circulo de Bellas Artes,40.418355,-3.696543
El Rastro,40.408480,-3.707334
Atocha Cercanias,40.409980,-3.689837
Corral de la Moreria,40.412805,-3.714159
Casa Julio,40.426067,-3.704378
Bodega de la Ardosa,40.423956,-3.701748
Museo del Jamon,40.416840,-3.701573
Cerveceria la Surena,40.414982,-3.703786
Platea Madrdid,40.426113, -3.688780
Canas y Tapas,40.417618,-3.706071
Jamoneria Julian Becerro,40.419855,-3.708835
Plaza de Espana,40.426127,-3.712165
Puerta de Alcala,40.422103,-3.689031
Templo de Debod,40.424019,-3.718730
La Cocina de San Anton,40.422256,-3.697565
El Sur,40.411259,-3.699531
Museo del Ferrocarril,40.398917,-3.691469
Casa de la Moneda,40.422646, -3.669143
Taberna El Papelon,40.414143,-3.703762
Puente de Toledo,40.400430,-3.714953
Puente de Segovia,40.414118, -3.722805
Centro de Arte Reina Sofia,40.408117,-3.694589
NH Palacio de Tepa,40.413918,-3.701668
;
run;

/* create the HTML file with the places */

filename arq "&dm/madridplaces.htm";

data _null_;
	set places end=eof;
	file arq;
	length linha $1024.;
	k+1;
	if k=1 then
		do;
			put '<!DOCTYPE html>';
			put '<html>';
			put '<head>';
			put '<title>SAS Network Optimization</title>';
			put '<meta charset="utf-8" />';
			put '<meta name="viewport" content="width=device-width, initial-scale=1.0">';
			put '<link rel="stylesheet" href="https://unpkg.com/leaflet@1.5.1/dist/leaflet.css" integrity="sha512-xwE/Az9zrjBIphAcBb3F6JVqxf46+CDLwfLMHloNu6KEQCAWi6HcDUbeOfBIptF7tcCzusKFjFw2yuvEpDL9wQ==" crossorigin=""/>';
			put '<script src="https://unpkg.com/leaflet@1.5.1/dist/leaflet.js" integrity="sha512-GffPMF3RvMeYyc1LWMHtK8EbPv0iNZ8/oTtHPx9/cc2ILxQ+u905qIwdpULaqDkyBKgOaB57QTMg7ztg8Jm2Og==" crossorigin=""></script>';
    		put '<style>body{padding:0;margin:0;}html,body,#mapid{height:100%;width:100%;}</style>';
			put '</head>';
			put '<body>';
			put '<div id="mapid"></div>';
			put '<script>';
			put 'var mymap=L.map("mapid").setView([40.412630,-3.705098],15);'; 
			put 'L.tileLayer("https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token=pk.eyJ1IjoibWFwYm94IiwiYSI6ImNpejY4NXVycTA2emYycXBndHRqcmZ3N3gifQ.rJcFIG214AriISLbB6B5aw",{maxZoom:20,id:"mapbox.streets"}).addTo(mymap);';
		end;
	linha='L.marker(['||x||','||y||']).addTo(mymap).bindTooltip("'||name||'",{permanent:true,opacity:0.7}).openTooltip();'; 
	if name = 'NH Palacio de Tepa' then
		do;
			linha='L.marker(['||x||','||y||']).addTo(mymap).bindTooltip("'||name||'",{permanent:true,opacity:1}).openTooltip();'; 
			linha='L.circle(['||x||','||y||'],{radius:75,color:"'||'blue'||'"}).addTo(mymap).bindTooltip("'||name||'",{permanent:true,opacity:1}).openTooltip();'; 
		end;
	put linha;
	if eof then 
		do;
	  		put '</script>';
  			put '</body>';
  			put '</html>';
		end;
run;

/* identify all possible connections between the places to visit */

proc sql;
	create table placeslinktmp as
		select a.name as org, a.x as xorg, a.y as yorg, b.name as dst, b.x as xdst, b.y as ydst 
			from places as a, places as b;
quit;

data placeslink;
	set placeslinktmp;
	if org ne dst then
		output;
run;

/* create the HTML file with the vectors */

filename arq "&dm/madridvectors.htm";

data _null_;
	set placeslink end=eof;
	file arq;
	length linha $1024.;
	k+1;
	if k=1 then
		do;
			put '<!DOCTYPE html>';
			put '<html>';
			put '<head>';
			put '<title>SAS Network Optimization</title>';
			put '<meta charset="utf-8" />';
			put '<meta name="viewport" content="width=device-width, initial-scale=1.0">';
			put '<link rel="stylesheet" href="https://unpkg.com/leaflet@1.5.1/dist/leaflet.css" integrity="sha512-xwE/Az9zrjBIphAcBb3F6JVqxf46+CDLwfLMHloNu6KEQCAWi6HcDUbeOfBIptF7tcCzusKFjFw2yuvEpDL9wQ==" crossorigin=""/>';
			put '<script src="https://unpkg.com/leaflet@1.5.1/dist/leaflet.js" integrity="sha512-GffPMF3RvMeYyc1LWMHtK8EbPv0iNZ8/oTtHPx9/cc2ILxQ+u905qIwdpULaqDkyBKgOaB57QTMg7ztg8Jm2Og==" crossorigin=""></script>';
	    	put '<style>body{padding:0;margin:0;}html,body,#mapid{height:100%;width:100%;}</style>';
			put '</head>';
			put '<body>';
			put '<div id="mapid"></div>';
			put '<script>';
			put 'var mymap=L.map("mapid").setView([40.412630,-3.705098],15);';
			put 'L.tileLayer("https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token=pk.eyJ1IjoibWFwYm94IiwiYSI6ImNpejY4NXVycTA2emYycXBndHRqcmZ3N3gifQ.rJcFIG214AriISLbB6B5aw",{maxZoom:20,id:"mapbox.streets"}).addTo(mymap);';
		end;
	linha='L.polyline([['||xorg||','||yorg||'],['||xdst||','||ydst||']],{weight:1}).addTo(mymap);';
	put linha;
	linha='L.circleMarker(['||xorg||','||yorg||']).addTo(mymap);';
	put linha;
	if eof then 
		do;
			put '</script>';
	  		put '</body>';
  			put '</html>';
		end;
run;

/* compute the Euclidian distance between all pairs of locations */

data mycas.placesdist;
	set placeslink;
	distance=geodist(xdst,ydst,xorg,yorg,'K');
	output;
run;

/* network optimization - compute the optimal tour based on a walking tour */

proc optnetwork
	direction = directed
	links = mycas.placesdist
	out_nodes = mycas.placesnodes
	;
	linksvar
		from = org
		to = dst
		weight = distance
	;
	tsp
		cutstrategy = none
		heuristics = none
		milp = true
		out = mycas.placesTSP
	;
run;

/* select the right sequence of the tour staring and ending at the hotel */

data steps;
	set mycas.placestsp mycas.placestsp;
run;

data stepsstart;
	set steps;
	if org = 'NH Palacio de Tepa' then	
		k+1;
	if k = 1 then
		do;
			drop k;
			output;
			if dst = 'NH Palacio de Tepa' then
				K+1;
		end;
run;

/* calculate distance and time for the walk tour */

proc sql;
	select sum(distance), sum(distance)/5 from stepsstart;
quit;

/* create the HTML file with the best walk tour */

proc sql;
	create table placestour as
		select c.org, c.xorg, c.yorg, c.dst, d.x as xdst, d.y as ydst from
			(select a.org, b.x as xorg, b.y as yorg, a.dst
				from stepsstart as a 
					inner join places as b 
						on a.org = b.name) as c
				inner join places as d 
					on c.dst = d.name;
quit;

filename arq "&dm/madridtour.htm";

data _null_;
	set placestour end=eof;
	file arq;
	length linha $1024.;
	k+1;
	if k=1 then
		do;
			put '<!DOCTYPE html>';
			put '<html>';
			put '<head>';
			put '<title>SAS Network Optimization</title>';
			put '<meta charset="utf-8" />';
			put '<meta name="viewport" content="width=device-width, initial-scale=1.0">';
			put '<link rel="stylesheet" href="https://unpkg.com/leaflet@1.5.1/dist/leaflet.css" integrity="sha512-xwE/Az9zrjBIphAcBb3F6JVqxf46+CDLwfLMHloNu6KEQCAWi6HcDUbeOfBIptF7tcCzusKFjFw2yuvEpDL9wQ==" crossorigin=""/>';
			put '<script src="https://unpkg.com/leaflet@1.5.1/dist/leaflet.js" integrity="sha512-GffPMF3RvMeYyc1LWMHtK8EbPv0iNZ8/oTtHPx9/cc2ILxQ+u905qIwdpULaqDkyBKgOaB57QTMg7ztg8Jm2Og==" crossorigin=""></script>';
    		put '<style>body{padding:0;margin:0;}html,body,#mapid{height:100%;width:100%;}</style>';
			put '</head>';
			put '<body>';
			put '<div id="mapid"></div>';
			put '<script>';
			put 'var mymap=L.map("mapid").setView([40.412630,-3.705098],15);';
			put 'L.tileLayer("https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token=pk.eyJ1IjoibWFwYm94IiwiYSI6ImNpejY4NXVycTA2emYycXBndHRqcmZ3N3gifQ.rJcFIG214AriISLbB6B5aw",{maxZoom:20,id:"mapbox.streets"}).addTo(mymap);';
		end;
	linha='setTimeout(function(){L.marker(['||xorg||','||yorg||']).addTo(mymap).bindTooltip("'||org||'",{permanent:true,opacity:0.6}).openTooltip()},'||k*100||');'; 
	put linha;
	linha='setTimeout(function(){L.polyline([['||xorg||','||yorg||'],['||xdst||','||ydst||']]).addTo(mymap).bindTooltip("'||k||'",{permanent:false,opacity:1}).openTooltip()},'||((k*100)+50)||');';
	put linha;
	if eof then 
		do;
  			put '</script>';
  			put '</body>';
  			put '</html>';
		end;
run;

/* load the transportation data */

data madridlines;
	infile "&dl/stop_times.txt" encoding="utf-8" delimiter=',' missover dsd lrecl=32767 firstobs=2;
	length trip_id $31. arrival_time 8 departure_time 8 stop_id $9. stop_sequence 8 stop_headsign $1. pickup_type $1. drop_off_type $1. shape_dist_traveled $1.;
	format arrival_time time8. departure_time time8. stop_sequence best2. ;
	informat arrival_time time11. departure_time time11. stop_sequence best2.;
	input trip_id :$char31. arrival_time :?? time8. departure_time :?? time8. stop_id :$char9. stop_sequence :?? best2. stop_headsign :$char1. pickup_type :$char1. drop_off_type :$char1. shape_dist_traveled :$char1.;
run;

data madridstations;
	infile "&dl/stops.txt" encoding="utf-8" delimiter=',' missover dsd lrecl=32767 firstobs=2;
	length stop_id $14. stop_code 8 stop_name $57. stop_desc $44. stop_lat 8 stop_lon 8 zone_id $2. stop_url $18. location_type 8 parent_station $9. stop_timezone $13. wheelchair_boarding 8;
	input stop_id $ stop_code stop_name $ stop_desc $ stop_lat stop_lon zone_id $ stop_url $ location_type parent_station $ stop_timezone $ wheelchair_boarding;
run;

proc sql;
	create table linestation as
		select a.trip_id, compress(translate(substr(a.trip_id,26,2),'','_')) as line, a.stop_id, a.stop_sequence, 
				b.stop_name, b.stop_lat, b.stop_lon 
			from madridlines as a 
				inner join madridstations as b 
					on a.stop_id eq b.stop_id;
quit;

data lcolor;
	length line $2 color $7;
	infile datalines delimiter=",";
	input line $ color $;
datalines;
1,#67C0DD
2,#e0292f
3,#fdd700
4,#cf7700
5,#98be13
6,#c0bab0
7,#f19c0c
8,#eba6c9
9,#9E2F8A
10,#005FA9
11,#009739
12,#af9f00
R,#007ba3
;
run;

proc sql;
	create table linestationcolor as
		select a.*, b.* from linestation as a
			inner join lcolor as b
				on a.line=b.line;
quit;

%let out=1;

data metrolinks;
	op=symget('out');
	length la $2. ca $7. org $57. dst $57.;
	la=line;
	ca=color;
	org=stop_name;
	org_lat=stop_lat;
	org_lon=stop_lon;
	ssa=stop_sequence;
	set linestationcolor;
	if la eq line and ssa lt stop_sequence and org ne stop_name then
		if op eq 1 then
			do;
				dst=stop_name;
				dst_lat=stop_lat;
				dst_lon=stop_lon;
				dist=geodist(dst_lat,dst_lon,org_lat,org_lon,'K'); 
				keep line color org org_lat org_lon dst dst_lat dst_lon dist;
				output;
			end;
	if op eq 1 and la eq line and ssa gt stop_sequence then
		call symput('out',0);
	if op eq 0 and la ne line then
		call symput('out',1);
run;

data mycas.metrolinks;
	set metrolinks;
run;

proc sql;
	create table metronodes as
		select node, max(lat) as lat, max(lon) as lon from (
			select distinct org as node, org_lat as lat, org_lon as lon from mycas.metrolinks
				union 
			select distinct dst as node, dst_lat as lat, dst_lon as lon from mycas.metrolinks)
				group by node;
quit;

data mycas.metronodes;
	set metronodes;
run;

proc sql;
	create table metrolinksdirected as
		select org, org_lat, org_lon, dst, dst_lat, dst_lon, color, line, dist 
			from mycas.metrolinks
				union all
		select dst as org, dst_lat as org_lat, dst_lon as org_lon, org as dst, org_lat as dst_lat, org_lon as dst_lon, color, line, dist 
			from mycas.metrolinks;
quit;

data mycas.metrolinksdirected;
	set metrolinksdirected;
run;

proc sql;
	select count(distinct org), count(distinct line) from metrolinksdirected;
quit;

/* create the HTML file with the transportation network */

filename arq "&dm/madridmetro.htm";

data _null_;
	length linha $32767.;
	length al $30.;
	length ac $7.;
	al=line;
	ac=color;
	ox=org_lat;
	oy=org_lon;
	dx=dst_lat;
	dy=dst_lon;
	set metrolinks end=eof;
	file arq;
	k+1;
	if k=1 then
		do;
			put '<!DOCTYPE html>';
			put '<html>';
			put '<head>';
			put '<title>SAS Network Optimization</title>';
			put '<meta charset="utf-8" />';
			put '<meta name="viewport" content="width=device-width, initial-scale=1.0">';
			put '<link rel="stylesheet" href="https://unpkg.com/leaflet@1.5.1/dist/leaflet.css" integrity="sha512-xwE/Az9zrjBIphAcBb3F6JVqxf46+CDLwfLMHloNu6KEQCAWi6HcDUbeOfBIptF7tcCzusKFjFw2yuvEpDL9wQ==" crossorigin=""/>';
			put '<script src="https://unpkg.com/leaflet@1.5.1/dist/leaflet.js" integrity="sha512-GffPMF3RvMeYyc1LWMHtK8EbPv0iNZ8/oTtHPx9/cc2ILxQ+u905qIwdpULaqDkyBKgOaB57QTMg7ztg8Jm2Og==" crossorigin=""></script>';
	    	put '<style>body{padding:0;margin:0;}html,body,#mapid{height:100%;width:100%;}</style>';
			put '</head>';
			put '<body>';
			put '<div id="mapid"></div>';
			put '<script>';
			put 'var mymap=L.map("mapid").setView([40.412630,-3.705098],14);';
			put 'L.tileLayer("https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token=pk.eyJ1IjoibWFwYm94IiwiYSI6ImNpejY4NXVycTA2emYycXBndHRqcmZ3N3gifQ.rJcFIG214AriISLbB6B5aw",{maxZoom:20,id:"mapbox.streets"}).addTo(mymap);';
		end;
	linha='L.polyline([['||org_lat||','||org_lon||'],['||dst_lat||','||dst_lon||']],{weight:5,color:"'||color||'"}).addTo(mymap);'; 
	put linha;
	if al ne line and k gt 1 then
		do;
			linha='L.polyline([['||ox||','||oy||'],['||dx||','||dy||']],{weight:5,color:"'||ac||'"}).addTo(mymap).bindTooltip("'||al||'",{permanent:true,opacity:0.75}).openTooltip();'; 
			put linha;
		end;
	if eof then 
		do;
			linha='L.polyline([['||org_lat||','||org_lon||'],['||dst_lat||','||dst_lon||']],{weight:5,color:"'||color||'"}).addTo(mymap).bindTooltip("'||line||'",{permanent:true,opacity:0.75}).openTooltip();'; 
			put linha;
			put '</script>';
	  		put '</body>';
  			put '</html>';
		end;
run;

/* -------------------------------------------------------------- */
/* travelling salesman problem - multimodal transportation system */
/* -------------------------------------------------------------- */

/* comuting distances between places and between places and stations */

proc sql;
	create table placesstations as
		select a.name as place, a.x as xp, a.y as yp, b.node as station, b.lat as xs, b.lon as ys 
			from places as a, metronodes as b;
quit;

data placesstationsdist;
	set placesstations;
	distance=geodist(xs,ys,xp,yp,'K');
	output;
run;

proc sort data=placesstationsdist;
	by place distance;
run;

data stationplace;
	length ap $30.;
	ap=place;
	set placesstationsdist;
	if ap ne place then 
		do;
			drop ap;
			output;
		end;
run;

/* create the HTML file with the stations and locations */

filename arq "&dm/madridstationplace.htm";

data _null_;
	set stationplace end=eof;
	file arq;
	length linha $1024.;
	k+1;
	if k=1 then
		do;
			put '<!DOCTYPE html>';
			put '<html>';
			put '<head>';
			put '<title>SAS Network Optimization</title>';
			put '<meta charset="utf-8" />';
			put '<meta name="viewport" content="width=device-width, initial-scale=1.0">';
			put '<link rel="stylesheet" href="https://unpkg.com/leaflet@1.5.1/dist/leaflet.css" integrity="sha512-xwE/Az9zrjBIphAcBb3F6JVqxf46+CDLwfLMHloNu6KEQCAWi6HcDUbeOfBIptF7tcCzusKFjFw2yuvEpDL9wQ==" crossorigin=""/>';
			put '<script src="https://unpkg.com/leaflet@1.5.1/dist/leaflet.js" integrity="sha512-GffPMF3RvMeYyc1LWMHtK8EbPv0iNZ8/oTtHPx9/cc2ILxQ+u905qIwdpULaqDkyBKgOaB57QTMg7ztg8Jm2Og==" crossorigin=""></script>';
    		put '<style>body{padding:0;margin:0;}html,body,#mapid{height:100%;width:100%;}</style>';
			put '</head>';
			put '<body>';
			put '<div id="mapid"></div>';
			put '<script>';
			put 'var mymap=L.map("mapid").setView([40.412630,-3.705098],15);';
			put 'L.tileLayer("https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token=pk.eyJ1IjoibWFwYm94IiwiYSI6ImNpejY4NXVycTA2emYycXBndHRqcmZ3N3gifQ.rJcFIG214AriISLbB6B5aw",{maxZoom:20,id:"mapbox.streets"}).addTo(mymap);';
		end;
	linha='L.circle(['||xs||','||ys||'],{radius:75,color:"'||'blue'||'"}).addTo(mymap).bindTooltip("'||station||'",{permanent:true,opacity:0.5}).openTooltip();'; 
	put linha;
	linha='L.marker(['||xp||','||yp||']).addTo(mymap).bindTooltip("'||place||'",{permanent:true,opacity:0.5}).openTooltip();'; 
	put linha;
	linha='L.polyline([['||xp||','||yp||'],['||xs||','||ys||']],{weight:2,color:"'||'black'||'"}).addTo(mymap);';
	put linha;
	if eof then 
		do;
	  		put '</script>';
  			put '</body>';
  			put '</html>';
		end;
run;

/* calculate distances between places and places and stations */

proc sql;
	create table stationplacelinktmp as
		select a.place as plorg, a.xp as xporg, a.yp as yporg, a.station as storg, a.xs as xsorg, a.ys as ysorg, a.distance as distorg,
 				b.place as pldst, b.xp as xpdst, b.yp as ypdst, b.station as stdst, b.xs as xsdst, b.ys as ysdst, b.distance as distdst
			from stationplace as a, stationplace as b;
quit;

data stationplacelink;
	set stationplacelinktmp;
	if plorg ne pldst then
		output;
run;

/* comparing when to walk and when to take transportation based on the distance between locations */

data mycas.stationplacelinkdist;
	set stationplacelink;
	pldist=geodist(xporg,yporg,xpdst,ypdst,'K');
	stdist=geodist(xsorg,ysorg,xsdst,ysdst,'K');
	if pldist lt (distorg+distdst) then
		do;
			distance=pldist;
			type='W';
		end;
	else
		do;
			distance=distorg+stdist+distdst;
			type='T';
		end;
	output;
run;

/* calculate the optimal tour based on multimodal transportation network */

proc optnetwork
	direction = directed
	links = mycas.stationplacelinkdist
	out_nodes = mycas.stationplacenodes
	;
	linksvar
		from = plorg
		to = pldst
		weight = distance
	;
	tsp
		cutstrategy = none
		heuristics = none
		milp = true
		out = mycas.stationplaceTSP
	;
run;

/* select the right sequence of the tour staring and ending at the hotel */

data stationplacestep;
	set mycas.stationplacetsp mycas.stationplacetsp;
run;

data stationplacestepstart;
	set stationplacestep;
	if plorg = 'NH Palacio de Tepa' then	
		k+1;
	if k = 1 then
		do;
			order+1;
			drop k;
			output;
			if pldst = 'NH Palacio de Tepa' then
				K+1;
		end;
run;

proc sql;
	create table stationplacetour as
		select a.order, b.* from stationplacestepstart as a 
			inner join mycas.stationplacelinkdist as b 
				on a.plorg = b.plorg and a.pldst = b.pldst
					order by a.order;
quit;

/* calculate all shortest paths by pairs of locations within the tour when taking the public transportation */

data stationplaceW stationplaceT;
	set stationplacetour;
	if type = 'W' then
		output stationplaceW;
	else 
		output stationplaceT;
run;

proc optnetwork
	direction = undirected
	links = mycas.metrolinks
	;
	linksvar
		from = org
		to = dst
		weight = dist
	;
	shortestpath
		outpaths = mycas.shortpathmetrotour
	;
run;

/* define all sequences from the shortest paths for the public transportation */

proc sql;
	create table stpltourm as
		select a.*, b.source as source, b.sink as sink, b.order as suborder, b.org as org, b.dst as dst, b.dist as dist 
			from stationplacet as a
				inner join mycas.shortpathmetrotour as b
					on a.storg = b.source and a.stdst = b.sink
						order by a.order, b.order;
quit;

data stpltourseq;
	set stationplaceW stpltourm;
run;

proc sql;
	create table stationplacetourfinaltmp as
		select a.*, b.line, b.color, b.org_lat, b.org_lon, b.dst_lat, b.dst_lon
			from stpltourseq as a
				left join metrolinksdirected as b  
					on a.org = b.org and a.dst = b.dst
						order by order, suborder, line;
quit;

/* joining all steps for the optimal tour: walking and shortest path for public transportation */

data stationplacetourfinal;
	ao = order;
	as = suborder;
	set stationplacetourfinaltmp;
	if not (order eq ao and suborder eq as) then
		do;
			drop ao as;
			output;
		end;
run;

/* calculate distance and time for the multimodal walk tour */

proc sql;
	select sum(distance) from stationplacetourfinal where type='W';
quit;

proc sql;
	select sum(time), sum(distance) from 
		(select case when type='W' then distance/5 
					when type='T' then distance/30 end as time, type, distance from  
			(select type, coalesce(sum(dist),sum(distance)) as distance
				from stationplacetourfinal 
					group by type));
quit;

/* create the HTML file with the final multimodal tour */

filename arq "&dm/madridstpltour.htm";

data _null_;
	length linha $32767.;
	length al $3.;
	length ac $7.;
	al=line;
	ac=color;
	set stationplacetourfinal end=eof;
	retain linha;
	file arq;
	k+1;
	if k=1 then
		do;
			put '<!DOCTYPE html>';
			put '<html>';
			put '<head>';
			put '<title>SAS Network Optimization</title>';
			put '<meta charset="utf-8" />';
			put '<meta name="viewport" content="width=device-width, initial-scale=1.0">';
			put '<link rel="stylesheet" href="https://unpkg.com/leaflet@1.5.1/dist/leaflet.css" integrity="sha512-xwE/Az9zrjBIphAcBb3F6JVqxf46+CDLwfLMHloNu6KEQCAWi6HcDUbeOfBIptF7tcCzusKFjFw2yuvEpDL9wQ==" crossorigin=""/>';
			put '<script src="https://unpkg.com/leaflet@1.5.1/dist/leaflet.js" integrity="sha512-GffPMF3RvMeYyc1LWMHtK8EbPv0iNZ8/oTtHPx9/cc2ILxQ+u905qIwdpULaqDkyBKgOaB57QTMg7ztg8Jm2Og==" crossorigin=""></script>';
    		put '<style>body{padding:0;margin:0;}html,body,#mapid{height:100%;width:100%;}</style>';
			put '</head>';
			put '<body>';
			put '<div id="mapid"></div>';
			put '<script>';
			put 'var mymap=L.map("mapid").setView([40.412630,-3.705098],15);';
			put 'L.tileLayer("https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token=pk.eyJ1IjoibWFwYm94IiwiYSI6ImNpejY4NXVycTA2emYycXBndHRqcmZ3N3gifQ.rJcFIG214AriISLbB6B5aw",{maxZoom:20,id:"mapbox.streets"}).addTo(mymap);';
		end;
	j+1;
	t=j*100+50;
	if suborder eq . or suborder eq 1 then
		do;
			linha='setTimeout(function(){L.marker(['||xporg||','||yporg||']).addTo(mymap).bindTooltip("'||plorg||'",{permanent:true,opacity:1}).openTooltip()},'||t||');'; 
			put linha;
		end;
	if type eq 'W' then
		do;
			linha='setTimeout(function(){L.polyline([['||xporg||','||yporg||'],['||xpdst||','||ypdst||']],{weight:3,color:"'||'maroon'||'",dashArray:"'||'5,10'||'"}).addTo(mymap).bindTooltip("'||order||'",{permanent:false,opacity:0.75}).openTooltip()},'||t||');';
			put linha;
		end;
	else
		do;
			if suborder eq 1 then
				do;
					linha='setTimeout(function(){L.circle(['||xsorg||','||ysorg||'],{radius:40,color:"'||'red'||'"}).addTo(mymap).bindTooltip("'||storg||'",{permanent:true,opacity:0.5}).openTooltip()},'||t||');'; 
					put linha;
					linha='setTimeout(function(){L.polyline([['||xporg||','||yporg||'],['||xsorg||','||ysorg||']],{weight:3,color:"'||'red'||'",dashArray:"'||'5,10'||'"}).addTo(mymap).bindTooltip("'||order||'",{permanent:false,opacity:0.75}).openTooltip()},'||t||');';
					put linha;
					linha='setTimeout(function(){L.circle(['||xsdst||','||ysdst||'],{radius:40,color:"'||'red'||'"}).addTo(mymap).bindTooltip("'||stdst||'",{permanent:true,opacity:0.5}).openTooltip()},'||t||');'; 
					put linha;
					linha='setTimeout(function(){L.polyline([['||xsdst||','||ysdst||'],['||xpdst||','||ypdst||']],{weight:3,color:"'||'red'||'",dashArray:"'||'5,10'||'"}).addTo(mymap).openTooltip()},'||t||');';
					put linha;
					linha='setTimeout(function(){L.polyline([['||org_lat||','||org_lon||'],['||dst_lat||','||dst_lon||']],{weight:4,color:"'||color||'"}).addTo(mymap).openTooltip()},'||t||');';
					put linha;
				end;
			else
				do;
					linha='setTimeout(function(){L.polyline([['||org_lat||','||org_lon||'],['||dst_lat||','||dst_lon||']],{weight:4,color:"'||color||'"}).addTo(mymap).openTooltip()},'||t||');';
					put linha;
				end;
		end;
	if eof then 
		do;
			put '</script>';
  			put '</body>';
  			put '</html>';
		end;
run;
