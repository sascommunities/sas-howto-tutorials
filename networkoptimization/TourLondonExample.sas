/* lines */

%let dl = /folder/;

/* maps */

%let dm = /folder/;

/* cas session */ 

cas;

libname mycas cas sessref=casauto;

/* points of interest */

data places;
	length name $30;
	infile datalines delimiter=",";
	input name $ x y;
datalines;
British Museum,51.519563,-0.126592
Tower of London,51.508293,-0.075992
Buckingham Palace,51.501531,-0.141922
Portobello Road Market,51.521084,-0.209128
Westminster Abbey,51.499625,-0.127585
Picadilly Circus,51.510070,-0.134993
Hyde Park,51.507295,-0.165720
National Gallery,51.509129,-0.128310
Tower Bridge,51.504334,-0.076193
London Eye,51.503484,-0.119564
St. Paul's Cathedral,51.514032,-0.098383
Big Ben,51.500785,-0.124632
Camden Market,51.541673,-0.145782
The Dove,51.490665,-0.234528
The French House,51.512926,-0.131758
The Lamb & Flag,51.511897,-0.125707
The Mayflower,51.501949,-0.053579
Camden Town Brewery,51.546681,-0.146676
Waterloo Tap,51.507293,-0.115164
Bravas Tapas,51.508838,-0.071302
Borough Market,51.505627,-0.090974
Mercato Metropolitano,51.498615,-0.098439
Kensington Palace,51.505243,-0.187198
Madame Tussauds,51.524890,-0.154568
Marble Arch,51.514824,-0.159662
Albert Hall,51.501351,-0.177474
Natural History Museum,51.496849,-0.176401
Market Hall Victoria,51.497668,-0.144163
Trafalgar Square,51.509771,-0.127832
Southwark Brewing Company,51.500610,-0.076464
citizenM,51.510365,-0.076698
;
run;

/* create the HTML file with the places */

filename arq "&dm/londonplaces.htm";

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
			put 'var mymap=L.map("mapid").setView([51.507513,-0.127719],13);';
			put 'L.tileLayer("https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token=pk.eyJ1IjoibWFwYm94IiwiYSI6ImNpejY4NXVycTA2emYycXBndHRqcmZ3N3gifQ.rJcFIG214AriISLbB6B5aw",{maxZoom:20,id:"mapbox.streets"}).addTo(mymap);';
		end;
	linha='L.marker(['||x||','||y||']).addTo(mymap).bindTooltip("'||name||'",{permanent:true,opacity:0.7}).openTooltip();'; 
	if name = 'citizenM' then
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

filename arq "&dm/londonvectors.htm";

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
			put 'var mymap=L.map("mapid").setView([51.507513,-0.127719],13);';
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
	distance=geodist(xdst,ydst,xorg,yorg,'M');
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
	if org = 'citizenM' then	
		k+1;
	if k = 1 then
		do;
			drop k;
			output;
			if dst = 'citizenM' then
				K+1;
		end;
run;

/* calculate distance and time for the walk tour */

proc sql;
	select sum(distance), sum(distance)/3.1 from stepsstart;
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

filename arq "&dm/londontour.htm";

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
			put 'var mymap=L.map("mapid").setView([51.507513,-0.127719],13);';
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

data lines;
	infile "&dl/LondonLines.csv" encoding="utf-8" delimiter=',' missover dsd lrecl=32767 firstobs=2;
	length line $30. station_from $60. station_to $60. color $7.;
	input line $ station_from $ station_to $ color $;
run;

data stations;
	infile "&dl/LondonStations.csv" encoding="utf-8" delimiter=',' missover dsd lrecl=32767 firstobs=2;
	length station $60. osx 8. osy 8. latitude 8. longitude 8. zone $7. postcode $8.;
	input station $ osx osy latitude longitude zone $ postcode $;
run;

proc sql;
	select count(distinct line) from lines;
	select count(distinct station) from stations;
quit;

proc sql;
	create table metrolinks as 
		select c.line, c.color, c.org, c.org_lat, c.org_lon,
				c.dst, d.latitude as dst_lat, d.longitude as dst_lon,
				geodist(d.latitude,d.longitude,c.org_lat,c.org_lon,'M') as dist from 
			(select a.line, a.color, a.station_from as org, b.latitude as org_lat, b.longitude as org_lon,
					a.station_to as dst
				from lines as a 
					inner join stations as b
						on a.station_from eq b.station) as c
			inner join stations as d 
				on c.dst eq d.station;
quit;

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

/* create the HTML file with the transportation network */

filename arq "&dm/londonmetro.htm";

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
			put 'var mymap=L.map("mapid").setView([51.507513,-0.127719],13);';
			put 'L.tileLayer("https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token=pk.eyJ1IjoibWFwYm94IiwiYSI6ImNpejY4NXVycTA2emYycXBndHRqcmZ3N3gifQ.rJcFIG214AriISLbB6B5aw",{maxZoom:20,id:"mapbox.streets"}).addTo(mymap);';
		end;
	linha='L.polyline([['||org_lat||','||org_lon||'],['||dst_lat||','||dst_lon||']],{weight:3,color:"'||color||'"}).addTo(mymap);'; 
	put linha;
	if al ne line and k gt 1 then
		do;
			linha='L.polyline([['||ox||','||oy||'],['||dx||','||dy||']],{weight:3,color:"'||ac||'"}).addTo(mymap).bindTooltip("'||al||'",{permanent:true,opacity:0.75}).openTooltip();'; 
			put linha;
		end;
	if eof then 
		do;
			linha='L.polyline([['||org_lat||','||org_lon||'],['||dst_lat||','||dst_lon||']],{weight:3,color:"'||color||'"}).addTo(mymap).bindTooltip("'||line||'",{permanent:true,opacity:0.75}).openTooltip();'; 
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
	distance=geodist(xs,ys,xp,yp,'M');
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

filename arq "&dm/londonstationplace.htm";

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
			put 'var mymap=L.map("mapid").setView([51.507513,-0.127719],13);';
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
	pldist=geodist(xporg,yporg,xpdst,ypdst,'M');
	stdist=geodist(xsorg,ysorg,xsdst,ysdst,'M');
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
	if plorg = 'citizenM' then	
		k+1;
	if k = 1 then
		do;
			order+1;
			drop k;
			output;
			if pldst = 'citizenM' then
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
		(select case when type='W' then distance/3.1 
					when type='T' then distance/20.5 end as time, type, distance from  
			(select type, coalesce(sum(dist),sum(distance)) as distance
				from stationplacetourfinal 
					group by type));
quit;

/* create the HTML file with the final multimodal tour */

filename arq "&dm/londonstpltour.htm";

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
			put 'var mymap=L.map("mapid").setView([51.507513,-0.127719],13);';
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
					linha='setTimeout(function(){L.polyline([['||xporg||','||yporg||'],['||xsorg||','||ysorg||']],{weight:4,color:"'||'red'||'",dashArray:"'||'5,10'||'"}).addTo(mymap).bindTooltip("'||order||'",{permanent:false,opacity:0.75}).openTooltip()},'||t||');';
					put linha;
					linha='setTimeout(function(){L.circle(['||xsdst||','||ysdst||'],{radius:40,color:"'||'red'||'"}).addTo(mymap).bindTooltip("'||stdst||'",{permanent:true,opacity:0.5}).openTooltip()},'||t||');'; 
					put linha;
					linha='setTimeout(function(){L.polyline([['||xsdst||','||ysdst||'],['||xpdst||','||ypdst||']],{weight:4,color:"'||'red'||'",dashArray:"'||'5,10'||'"}).addTo(mymap).openTooltip()},'||t||');';
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
