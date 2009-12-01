var sc_width=screen.width;		
var sc_referer = ""+document.referrer;
// var sc_referer = parent.document.referrer;
var sc_title = "";
var sc_url = "";
var sc_unique = 0;
var sc_returning = 0;
var sc_returns = 0;
var sc_agent = navigator.appName+' '+navigator.appVersion;
var sc_base_dir;
var sc_error=0;
var sc_remove=0;
var sc_http_url="http";
var sc_link_back_start = "";
var sc_link_back_end = "";
var sc_security_code = "";


if(window.sc_https) {
	if(sc_https==1) {
		sc_doc_loc = ''+document.location;
		myRE = new RegExp("^https", "i")
		if(sc_doc_loc.match(myRE)) {
			sc_http_url = "https";
		}
		else {
			sc_http_url = "http";
		}
	}
	else
		sc_http_url = "http";
}


if(window.sc_partition) {
	var sc_counter = sc_partition+1;
	sc_base_dir = sc_http_url+"://c"+sc_counter+".statcounter.com/";
}
else {
	sc_base_dir = sc_http_url+"://c1.statcounter.com/";
	var sc_partition=0;
}

if(window.sc_text)
	sc_base_dir += "text.php?";
else
	sc_base_dir += "t.php?";

if(window.sc_project) {
	sc_base_dir += "sc_project="+sc_project;
	if((sc_project==1395484)||(sc_project==1395532)||(sc_project==1300900)||(sc_project==1420550)||(sc_project==1301977)||(sc_project==1299576)||(sc_project==1286300))
		sc_remove=1;
}
else if(window.usr) {
	sc_base_dir += "usr="+usr;
}
else {
	sc_error = 1;
}

if(window.sc_remove_link) {
	sc_link_back_start = "";
	sc_link_back_end = "";
}
else {
	sc_link_back_start = "<a href=\"http://www.StatCounter.com\" target=\"_blank\">";
	sc_link_back_end = "<\/a>";
}

sc_date = new Date();
sc_time = sc_date.getTime();
sc_agent = sc_agent.toUpperCase();

sc_time_difference = 60*60*1000;

sc_title = ""+document.title;
sc_url = ""+document.location;
sc_referer = sc_referer.substring(0, 150);
sc_title = sc_title.substring(0, 150);
sc_url = sc_url.substring(0, 150);
sc_referer = escape(sc_referer);
sc_title = escape(sc_title);
sc_url = escape(sc_url);

if (window.sc_security) {
	sc_security_code = sc_security;
}

var sc_tracking_url = sc_base_dir+"&resolution="+sc_width+"&camefrom="+sc_referer+"&u="+sc_url+"&t="+sc_title+"&java=1&security="+sc_security_code+"&sc_random="+Math.random();

// if no usr or project set then display visibile

// if usr=="someuser" then display visibile

if(sc_error==1) {
		document.writeln("Code corrupted. Insert fresh copy.");
}
else if(sc_remove==1) {
		document.writeln("<b>StatCounter cannot track a high volume website like yours for free. This was stated several times during the sign up process. Please remove the code ASAP.</b>");
}
//else if(sc_partition==6) {
	// down at the moment
//}
else if (window.sc_invisible) {
	if(window.sc_invisible==1) {
	sc_img = new Image();
	sc_img.src = sc_tracking_url;
	}
	else {
		document.writeln(sc_link_back_start+"<IMG SRC=\""+sc_tracking_url+"\" ALT=\"StatCounter - Free Web Tracker and Counter\" BORDER=\"0\">"+sc_link_back_end);
	}
}
else if (window.sc_text) {
	document.writeln('<scr' + 'ipt language="JavaScript"' + ' src=' + sc_tracking_url+"&text=" + sc_text+ '></scr' + 'ipt>');
}
else {
	document.writeln(sc_link_back_start+"<IMG SRC=\""+sc_tracking_url+"\" ALT=\"StatCounter - Free Web Tracker and Counter\" BORDER=\"0\">"+sc_link_back_end);
}
