/* lines */

%let dl = /r/ge.unx.sas.com/vol/vol610/u61/careis/LisbonLines;

/* maps */

%let dm = /r/ge.unx.sas.com/vol/vol610/u61/careis/LisbonMaps;

/* cas session */ 

cas;

libname mycas cas sessref=casauto;

/* points of interest */

data places;
	length name $35;
	infile datalines delimiter=",";
	input name $ x y;
datalines;
Jardim Zoologico,38.745604,-9.171049
Museu Gulbenkian,38.739311,-9.153797
Miradouro Senhora do Monte,38.720362,-9.133026
Bemposta Palace,38.723194,-9.138480
Miradouro Monte Agudo,38.726242,-9.131539
Praca do Comercio,38.708177,-9.136432
Se de Lisboa,38.710377,-9.132667
Panteao Nacional,38.715472,-9.124672
Parque Eduardo VII,38.728379,-9.152460
Castelo de Sao Jorge,38.714328,-9.133553
Varanda,38.725858,-9.155217
Igreja de Sao Roque,38.713983,-9.143513
Convento do Carmo,38.712623,-9.140276
Aqueduto das Aguas Livres,38.728235,-9.166718
Palacete Sao Bento,38.713076,-9.155399
Miradouro Santa Catarina,38.709970,-9.147716
Padrao dos Descobrimentos,38.693783,-9.205773
Torre de Belem,38.691813,-9.216043
Pasteis de Belem,38.697709,-9.203212
Mosteiro dos Jeronimos,38.698071,-9.206735
Casa Pia,38.699446,-9.206868
Praca Luis de Camoes,38.710858,-9.143277
Jardim Sao Pedro Alcantara,38.715476,-9.144247
Restaurante Laurentina,38.737381,-9.151332
Fonte Luminosa,38.737461,-9.130448
Portugalia,38.706032,-9.149271
Amoreiras 360,38.724150,-9.161325
Casa Portuguesa Pastel Bacalhau,38.710424,-9.137453
Palacio Nacional da Ajuda,38.708856,-9.198087
A Casa do Bacalhau,38.732268,-9.106452
NH Collection,38.720295,-9.144893
;
run;

/* create the HTML file with the places */

filename arq "&dm/lisbonplaces.htm";

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
			put 'var mymap=L.map("mapid").setView([38.723427,-9.172330],14);'; 
			put 'L.tileLayer("https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token=pk.eyJ1IjoibWFwYm94IiwiYSI6ImNpejY4NXVycTA2emYycXBndHRqcmZ3N3gifQ.rJcFIG214AriISLbB6B5aw",{maxZoom:20,id:"mapbox.streets"}).addTo(mymap);';
		end;
	linha='L.marker(['||x||','||y||']).addTo(mymap).bindTooltip("'||name||'",{permanent:true,opacity:0.7}).openTooltip();'; 
	if name = 'NH Collection' then
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

filename arq "&dm/lisbonvectors.htm";

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
			put 'var mymap=L.map("mapid").setView([38.723427,-9.172330],14);';
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
	if org = 'NH Collection' then	
		k+1;
	if k = 1 then
		do;
			drop k;
			output;
			if dst = 'NH Collection' then
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

filename arq "&dm/lisbontour.htm";

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
			put 'var mymap=L.map("mapid").setView([38.723427,-9.172330],14);';
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

data linemet;
 	infile "&dl/estacoes_metropolitano.csv" encoding="utf-8" dlm=',' missover dsd lrecl=32767 firstobs=2 termstr=crlf; 
	informat sequence best32. name $25. lat best32. lon best32. line $10. color $7.;
	format sequence best12. name $25. lat best12. lon best12. line $10. color $7.;
	input sequence name $ lat lon line $ color $;
run;

data linecp3stop;
 	infile "&dl/stops.txt" encoding="utf-8" dlm=',' missover dsd lrecl=32767 firstobs=2 termstr=crlf; 
	informat stop_id best32. stop_code $1. stop_name $25. stop_desc $1. stop_lat best32. stop_lon best32. zone_id $1. location_type $1. parent_station $1.;
	format stop_id best12. stop_code $1. stop_name $25. stop_desc $1. stop_lat best12. stop_lon best12. zone_id $1. location_type $1. parent_station $1.;
	input stop_id stop_code $ stop_name $ stop_desc $ stop_lat stop_lon zone_id $ location_type $ parent_station $;
run;

data linecp3stoptime;
 	infile "&dl/stop_times.txt" encoding="utf-8" dlm=',' missover dsd lrecl=32767 firstobs=2 termstr=crlf; 
	informat trip_id best32. arrival_time time11. departure_time time11. stop_id best32. stop_sequence best32. stop_headsign $1. pickup_type $1. drop_off_type $1. shape_dist_traveled $1.;
	format trip_id best12. arrival_time time8. departure_time time8. stop_id best12. stop_sequence best12. stop_headsign $1. pickup_type $1. drop_off_type $1. shape_dist_traveled $1.;
	input trip_id arrival_time departure_time stop_id stop_sequence stop_headsign $ pickup_type $ drop_off_type $ shape_dist_traveled $;
run;

proc sql;
	create table linecp3 as 
		select a.*, b.*
			from linecp3stoptime as a 
				inner join linecp3stop as b 
					on a.stop_id eq b.stop_id
						order by trip_id, stop_sequence; 
quit;

data cp3linkstmp;
	length asn $25;
	line='CP3';
	color='#006600';
	at = trip_id;
	alat = stop_lat;
	alon = stop_lon;
	asn = stop_name;
	set linecp3;
	if at = trip_id then
		do;
			org = asn;
			org_lat = alat;
			org_lon = alon;
			dst=stop_name;
			dst_lat = stop_lat;
			dst_lon = stop_lon;
			dist = geodist(stop_lat,stop_lon,alat,alon,'K');
			keep org org_lat org_lon dst dst_lat dst_lon color line dist;
			output;
		end;
run;

proc sql;
	create table cp3linksdirected as 
		select distinct line, color, org, org_lat, org_lon, dst, dst_lat, dst_lon, dist
			from cp3linkstmp;
quit;

proc sql;
	create table cp3links as 
		select line, color, org, org_lat, org_lon, dst, dst_lat, dst_lon, dist
			from cp3linksdirected
				where org lt dst;
quit;

proc sort
	data=linemet;
	by line sequence;
run;

data metlinks;
	length an $25.;
	length ac $7.;
	length al $9.;
	an = name;
	alat = lat;
	alon = lon;
	ac = color;
	al = line;
	set linemet;
	if al = line then
		do;
			org = an;
			org_lat = alat;
			org_lon = alon;
			dst=name;
			dst_lat = lat;
			dst_lon = lon;
			dist = geodist(lat,lon,alat,alon,'K');
			keep org org_lat org_lon dst dst_lat dst_lon color line dist;
			output;
		end;
run;

data metrolinks mycas.metrolinks;
	set metlinks cp3links;
run;

proc sql;
	create table metlinksdirected as
		select org, org_lat, org_lon, dst, dst_lat, dst_lon, color, line, dist 
			from metlinks
				union all
		select dst as org, dst_lat as org_lat, dst_lon as org_lon, org as dst, org_lat as dst_lat, org_lon as dst_lon, color, line, dist 
			from metlinks;
quit;

data metrolinksdirected mycas.metrolinksdirected;
	set metlinksdirected cp3linksdirected;
run;

proc sql;
	create table metronodes as
		select node, max(lat) as lat, max(lon) as lon from (
			select distinct org as node, org_lat as lat, org_lon as lon from metrolinks
				union 
			select distinct dst as node, dst_lat as lat, dst_lon as lon from metrolinks)
				group by node;
quit;

data mycas.metronodes;
	set metronodes;
run;

proc sql;
	select count(distinct org), count(distinct line) from metrolinksdirected;
quit;

/* create the HTML file with the transportation network */

filename arq "&dm/lisbonmetro.htm";

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
			put 'var mymap=L.map("mapid").setView([38.723427,-9.172330],14);';
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
	length ap $35.;
	ap=place;
	set placesstationsdist;
	if ap ne place then 
		do;
			drop ap;
			output;
		end;
run;

/* create the HTML file with the stations and locations */

filename arq "&dm/lisbonstationplace.htm";

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
			put 'var mymap=L.map("mapid").setView([38.723427,-9.172330],14);';
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
	if plorg = 'NH Collection' then	
		k+1;
	if k = 1 then
		do;
			order+1;
			drop k;
			output;
			if pldst = 'NH Collection' then
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

proc sql;
	select sum(distance), (sum(distance)-sum(stdist)) from stationplacetour;
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
					when type='T' then distance/25.5 end as time, type, distance from  
			(select type, coalesce(sum(dist),sum(distance)) as distance
				from stationplacetourfinal 
					group by type));
quit;

/* create the HTML file with the final multimodal tour */

filename arq "&dm/lisbonstpltour.htm";

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
			put 'var mymap=L.map("mapid").setView([38.723427,-9.172330],14);';
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
