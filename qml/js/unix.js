.pragma library;
var stringTable = [
	"---",
	"--x",
	"-w-",
	"-wx",
	"r--",
	"r-x",
	"rw-",
	"rwx",
];

function octal2string(s, type) {
	if (typeof type == 'undefined') type = '-';
	var sticky=false;
	var suid=false;
	var sgid=false;
	var i = (parseInt(s,10));
	if (i > 999) {
		// FIXME: this is embarrassing:
		var bit = s.toString()[0];
		if (bit == 1) { sticky = true }
		if (bit == 2) { sgid = true }
		if (bit == 3) { sticky = true; sgid = true }
		if (bit == 4) { suid = true }
		if (bit == 5) { sticky = true; suid = true }
		if (bit == 6) { sgid = true ; suid = true }
		if (bit == 7) { sticky = true; sgid = true ; suid = true }
	}
	var o = parseInt(s%1000, 8);
	if (!o) { console.warn("invalid input"); return ""};
	var other = (o & 7);
	var group =  ((o >> 3) & 7);
	var owner =  ((o >> 6) & 7);

	// FIXME: this is embarrassing:
	var ret = type
		+ stringTable[owner].replace(/x$/, suid ? "s" : "x" ).replace(/-$/, suid ? "S" : "-" )
		+ stringTable[group].replace(/x$/, sgid ? "s" : "x" ).replace(/-$/, sgid ? "S" : "-" )
		+ stringTable[other].replace(/x$/, sticky ? "t" : "x" ).replace(/-$/, sticky ? "T" : "-" )
	console.debug("got:", s, ret);
	return ret;
}
