// JavaScript Document
function getQueryString() {
	var result = location.search.match(new RegExp("[\?\&][^\?\&]+=[^\?\&]+", "g"));
	if (!result) return {};
	for (var i = 0; i < result.length; i++) {
		result[i] = result[i].substring(1);
	}
	var oo = {};
	for (var i in result) {
		var ss = result[i].split('=');
		oo[ss[0]] = ss[1];
	}
	return oo;
}