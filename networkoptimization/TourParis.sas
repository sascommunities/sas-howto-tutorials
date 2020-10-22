/* lines */

%let dl = /r/ge.unx.sas.com/vol/vol610/u61/careis/ParisLines;

/* maps */

%let dm = /r/ge.unx.sas.com/vol/vol610/u61/careis/ParisMaps;

/* cas session */ 

cas;

libname mycas cas sessref=casauto;

/* points of interest */

data places;
	length name $20;
	infile datalines delimiter=",";
	input name $ x y;
datalines;
Novotel,48.860886,2.346407
Tour Eiffel,48.858093,2.294694
Louvre,48.860819,2.33614
Jardin des Tuileries,48.86336,2.327042
Trocadero,48.861157,2.289276
Arc de Triomphe,48.873748,2.295059
Jardin du Luxembourg,48.846658,2.336451
Fontaine Saint Michel,48.853218,2.343757
Notre-Dame,48.852906,2.350114
Le Marais,48.860085,2.360859
Les Halles,48.862371,2.344731
Sacre-Coeur,48.88678,2.343011
Musee dOrsay,48.859852,2.326634
Opera,48.87053,2.332621
Pompidou,48.860554,2.352507
Tour Montparnasse,48.842077,2.321967
Moulin Rouge,48.884124,2.332304
Pantheon,48.846128,2.346117
Hotel des Invalides,48.856463,2.312762
Madeleine,48.869853,2.32481
Quartier Latin,48.848663,2.342126
Bastille,48.853156,2.369158
Republique,48.867877,2.363756
Canal Saint-Martin,48.870834,2.365655
Place des Vosges,48.855567,2.365558
Luigi Pepone,48.841696,2.308398
Josselin,48.841711,2.325384
The Financier,48.842607,2.323681
Berthillon,48.851721,2.35672
The Frog & Rosbif,48.864309,2.350315
Moonshiner,48.855677,2.371183
Cafe de lIndustrie,48.855655,2.371812
Chez Camille,48.84856,2.378099
Beau Regard,48.854614,2.333307
Maison Sauvage,48.853654,2.338045
Les Negociants,48.837129,2.351927
Les Cailloux,48.827689,2.34934
Cafe Hugo,48.855913,2.36669
La Chaumiere,48.852816,2.353542
Cafe Gaite,48.84049,2.323984
Au Trappiste,48.858295,2.347485
;
run;

/* create the HTML file with the places */

filename arq "&dm/parisplaces.htm";

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
			put 'var mymap=L.map("mapid").setView([48.856358, 2.351632],14);';
			put 'L.tileLayer("https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token=pk.eyJ1IjoibWFwYm94IiwiYSI6ImNpejY4NXVycTA2emYycXBndHRqcmZ3N3gifQ.rJcFIG214AriISLbB6B5aw",{maxZoom:20,id:"mapbox.streets"}).addTo(mymap);';
		end;
	linha='L.marker(['||x||','||y||']).addTo(mymap).bindTooltip("'||name||'",{permanent:true,opacity:0.7}).openTooltip();'; 
	if name = 'Novotel' then
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

filename arq "&dm/parisvectors.htm";

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
			put 'var mymap=L.map("mapid").setView([48.856358, 2.351632],14);';
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
	if org = 'Novotel' then	
		k+1;
	if k = 1 then
		do;
			drop k;
			output;
			if dst = 'Novotel' then
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

filename arq "&dm/paristour.htm";

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
			put 'var mymap=L.map("mapid").setView([48.856358, 2.351632],14);';
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

%macro importstops(line,arq);
data S&line;
	infile "&arq" encoding="utf-8" delimiter=',' missover dsd lrecl=32767 firstobs=2;
	informat trip_id best18.;
	informat arrival_time time11.;
	informat departure_time time11.;
	informat stop_id best12.;
	informat stop_sequence best2.;
	informat stop_headsign $1. ;
	informat shape_dist_traveled $1.;
	format trip_id best18.;
	format arrival_time time8.;
	format departure_time time8.;
	format stop_id best12.;
	format stop_sequence best2.;
	format stop_headsign $1. ;
	format shape_dist_traveled $1.;
	input trip_id arrival_time departure_time stop_id stop_sequence stop_headsign $ shape_dist_traveled $;
run;
proc sort data=s&line nodupkey;
	by stop_sequence;
run;
%mend importstops;

%macro importlines(line,arq);
data L&line;
	infile "&arq" encoding="utf-8" delimiter=',' missover dsd lrecl=32767 firstobs=2;
	informat stop_id best12.;
	informat stop_code $1.;
	informat stop_name $50.;
	informat stop_desc $50.;
	informat stop_lat best18.;
	informat stop_lon best18.;
	informat location_type best1.;
	informat parent_station $1.;
	format stop_id best12.;
	format stop_code $1.;
	format stop_name $50.;
	format stop_desc $50.;
	format stop_lat best18.;
	format stop_lon best18.;
	format location_type best1.;
	format parent_station $1.;
	input stop_id stop_code $ stop_name $ stop_desc $ stop_lat stop_lon location_type parent_station $;
run;
%mend importlines;

data _null_;
	array line {1:27} $3. line1-line27 ('1','2','3','3b','4','5','6','7','7b','8','9','10','11','12','13','14','orv','A','B','T1','T2','T3a','T3b','T5','T6','T7','T8');
	do i = 1 to 27; 
		call execute('%importstops('||line(i)||','||"&dl/stop_times"||compress(line(i))||'.txt'||')');
		call execute('%importlines('||line(i)||','||"&dl/stops"||compress(line(i))||'.txt'||')');
	end;
run;

%macro joinlinestop(line);
proc sql;
	create table ls&line as
		select a.*, b.stop_sequence from l&line as a
			inner join s&line as b
				on a.stop_id = b.stop_id
					order by stop_sequence;
quit;
%mend joinlinestop;

data _null_;
	array line {1:27} $3. line1-line27 ('1','2','3','3b','4','5','6','7','7b','8','9','10','11','12','13','14','orv','A','B','T1','T2','T3a','T3b','T5','T6','T7','T8');
	do i = 1 to 27; 
		call execute('%joinlinestop('||compress(line(i))||')');
	end;
run;

%macro appendline(line,color);
data ls&line;
	length line $3. color $7.;
	set ls&line;
	line="&line";
	color="&color";
run;
proc append base=lines data=ls&line force; 
run;
%mend appendline;

data lines;
	input stop_id stop_code $1. stop_name $50. stop_desc $50. stop_lat stop_lon location_type parent_station $1. stop_sequence line $3. color $7.;
datalines;
run;

data _null_;
	array line {1:27} $3. line1-line27 ('1','2','3','3b','4','5','6','7','7b','8','9','10','11','12','13','14','orv','A','B','T1','T2','T3a','T3b','T5','T6','T7','T8');
	array color (1:27) $7. color1-color27 ('#FFCD00','#003CA6','#837902','#6EC4E8','#CF009E','#FF7E2E','#6ECA97','#FA9ABA','#6ECA97','#E19BDF','#B6BD00','#C9910D','#704B1C','#007852','#6EC4E8','#62259D','#050D9E','#E2231A','#7BA3DC','#003CA6','#CF009E','#FF7E2E','#00AE41','#62259D','#E2231A','#704B1C','#837902');
	do i = 1 to 27; 
		call execute('%appendline('||compress(line(i))||','||compress(color(i))||')');
	end;
run;

proc sql;
	select count(distinct stop_name), count(distinct line) from lines;
quit;

proc sql;
	select count(*) into :nl from lines;
quit;

data mycas.metrolinks;
	length asn $50.;
	length ac $7.;
	length al $3.;
	asn = stop_name;
	alat = stop_lat;
	alon = stop_lon;
	ac = color;
	al = line;
	set lines;
	if al = line then
		do;
			org = asn;
			org_lat = alat;
			org_lon = alon;
			dst=stop_name;
			dst_lat = stop_lat;
			dst_lon = stop_lon;
			dist = geodist(stop_lat,stop_lon,org_lat,org_lon,'K');
			keep org org_lat org_lon dst dst_lat dst_lon color line dist;
			output;
		end;
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

/* create the HTML file with the transportation network */

filename arq "&dm/parismetro.htm";

data _null_;
	length linha $32767.;
	length al $3.;
	length ac $7.;
	al=line;
	ac=color;
	set lines end=eof;
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
			put 'var mymap=L.map("mapid").setView([48.856358, 2.351632],14);';
			put 'L.tileLayer("https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token=pk.eyJ1IjoibWFwYm94IiwiYSI6ImNpejY4NXVycTA2emYycXBndHRqcmZ3N3gifQ.rJcFIG214AriISLbB6B5aw",{maxZoom:20,id:"mapbox.streets"}).addTo(mymap);';
			linha='L.polyline([['||stop_lat||','||stop_lon||']';
		end;
	else
		if al ne line then
			do;
				linha=catt(linha,'],{weight:5,color:"'||ac||'"}).addTo(mymap).bindTooltip("'||al||'",{permanent:true,opacity:0.75}).openTooltip();'); 
				put linha;
				linha='L.polyline([['||stop_lat||','||stop_lon||']';
			end;
		else
			linha=catt(linha,',['||stop_lat||','||stop_lon||']'); 
	if eof then 
		do;
			linha=catt(linha,'],{weight:5,color:"'||color||'"}).addTo(mymap).bindTooltip("'||line||'",{permanent:true,opacity:0.75}).openTooltip();'); 
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
	length ap $20.;
	ap=place;
	set placesstationsdist;
	if ap ne place then 
		do;
			drop ap;
			output;
		end;
run;

/* create the HTML file with the stations and locations */

filename arq "&dm/stationplace.htm";

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
			put 'var mymap=L.map("mapid").setView([48.856358, 2.351632],14);';
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
	if plorg = 'Novotel' then	
		k+1;
	if k = 1 then
		do;
			order+1;
			drop k;
			output;
			if pldst = 'Novotel' then
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
	create table stpltoursp as
		select a.*, b.source as source, b.sink as sink, b.order as suborder, b.org as org, b.dst as dst, b.dist as dist 
			from stationplacet as a
				inner join mycas.shortpathmetrotour as b
					on a.storg = b.source and a.stdst = b.sink
						order by a.order, b.order;
quit;

data stpltourspseq;
	set stationplaceW stpltoursp;
run;

proc sql;
	create table stationplacetourfinaltmp as
		select a.*, b.line, b.color, b.org_lat, b.org_lon, b.dst_lat, b.dst_lon
			from stpltourspseq as a
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

data stpltour;
	set lines stationplacetourfinal;
run;

proc sql;
	select sum(distance) from stationplacetourfinal where type='W';
quit;

proc sql;
	select sum(time), sum(distance) from 
		(select case when type='W' then distance/5 
					when type='T' then distance/25.1 end as time, type, distance from  
			(select type, coalesce(sum(dist),sum(distance)) as distance
				from stationplacetourfinal 
					group by type));
quit;

/* create the HTML file with the final multimodal tour */

filename arq "&dm/stpltour.htm";

data _null_;
	length linha $32767.;
	length al $3.;
	length ac $7.;
	al=line;
	ac=color;
	set stpltour end=eof;
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
			put 'var mymap=L.map("mapid").setView([48.856358, 2.351632],14);';
			put 'L.tileLayer("https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token=pk.eyJ1IjoibWFwYm94IiwiYSI6ImNpejY4NXVycTA2emYycXBndHRqcmZ3N3gifQ.rJcFIG214AriISLbB6B5aw",{maxZoom:20,id:"mapbox.streets"}).addTo(mymap);';
			linha='L.polyline([['||stop_lat||','||stop_lon||']';
		end;
	else
		if stop_id ne . then
			if al ne line then
				do;
					linha=catt(linha,'],{weight:2,color:"'||ac||'"}).addTo(mymap);'); 
					put linha;
					linha='L.polyline([['||stop_lat||','||stop_lon||']';
				end;
			else
				linha=catt(linha,',['||stop_lat||','||stop_lon||']'); 
	if k=&nl then
		do;
			linha=catt(linha,'],{weight:2,color:"'||color||'"}).addTo(mymap);'); 
			put linha;
		end;
	if stop_id eq . then
		do;
			j+1;
			t=j*100+50;		
			linha='setTimeout(function(){L.marker(['||xporg||','||yporg||']).addTo(mymap).bindTooltip("'||plorg||'",{permanent:true,opacity:0.8}).openTooltip()},'||t||');'; 
			put linha;
			if type eq 'W' then
				do;
					linha='setTimeout(function(){L.polyline([['||xporg||','||yporg||'],['||xpdst||','||ypdst||']],{weight:5,color:"'||'maroon'||'",dashArray:"'||'5,10'||'"}).addTo(mymap).bindTooltip("'||order||'",{permanent:false,opacity:0.75}).openTooltip()},'||t||');';
					put linha;
				end;
			else
				do;
					if suborder eq 1 then
						do;
							linha='setTimeout(function(){L.circle(['||xsorg||','||ysorg||'],{radius:50,color:"'||'red'||'"}).addTo(mymap).bindTooltip("'||storg||'",{permanent:true,opacity:0.5}).openTooltip()},'||t||');'; 
							put linha;
							linha='setTimeout(function(){L.polyline([['||xporg||','||yporg||'],['||xsorg||','||ysorg||']],{weight:5,color:"'||'red'||'",dashArray:"'||'5,10'||'"}).addTo(mymap).bindTooltip("'||order||'",{permanent:false,opacity:0.75}).openTooltip()},'||t||');';
							put linha;
							linha='setTimeout(function(){L.circle(['||xsdst||','||ysdst||'],{radius:50,color:"'||'red'||'"}).addTo(mymap).bindTooltip("'||stdst||'",{permanent:true,opacity:0.5}).openTooltip()},'||t||');'; 
							put linha;
							linha='setTimeout(function(){L.polyline([['||xsdst||','||ysdst||'],['||xpdst||','||ypdst||']],{weight:5,color:"'||'red'||'",dashArray:"'||'5,10'||'"}).addTo(mymap).openTooltip()},'||t||');';
							put linha;
							linha='setTimeout(function(){L.polyline([['||org_lat||','||org_lon||'],['||dst_lat||','||dst_lon||']],{weight:5,color:"'||color||'"}).addTo(mymap).openTooltip()},'||t||');';
							put linha;
						end;
					else
						do;
							linha='setTimeout(function(){L.polyline([['||org_lat||','||org_lon||'],['||dst_lat||','||dst_lon||']],{weight:5,color:"'||color||'"}).addTo(mymap).openTooltip()},'||t||');';
							put linha;
						end;
				end;
		end;
	if eof then 
		do;
			put '</script>';
  			put '</body>';
  			put '</html>';
		end;
run;
