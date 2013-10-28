//*************************************************** //
// Text Transformator Class
//
// This class contains methods to transform text
// into rich text that includes links and other logic.
//*************************************************** //

// Class function that gets the prototype methods
function TextTransformator() {
}

//convert text to rich text
//this is actually done by wrapping the text in html brackets
TextTransformator.prototype.escapeHTML = function(originalText) {
	var parsedText = "";

	parsedText =  originalText
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;");

	return parsedText;
};

// convert text to rich text
// this is actually done by wrapping the text in html brackets
TextTransformator.prototype.convertToRichText = function(originalText) {
	var parsedText = "";

	parsedText = "<html><body>" + originalText + "</body></html>";

	return parsedText;
};

// analyze text and add links to hashtags
// hashtags start with # followed by the actual tag
TextTransformator.prototype.addHashtagLinksToText = function(originalText) {
	var parsedText = "";

	var regexp = new RegExp('#([^\\s]*)', 'g');
	parsedText = originalText.replace(regexp, function(u) {
		var hashtag = u.replace("#", "");
		var hashtaglink = "<a href=\"hashtag:" + hashtag + "\">" + u + "</a>";
		return hashtaglink;
	});

	return parsedText;
};

// analyze text and add links to user names
// user names start with @ followed by the actual name
TextTransformator.prototype.addUserLinksToText = function(originalText) {
	var parsedText = "";

	var regexp = new RegExp('[@]+[A-Za-z0-9-_]+', 'g');
	parsedText = originalText.replace(regexp, function(u) {
		var username = u.replace("@", "");
		var userlink = "<a href=\"user:" + username + "\">" + u + "</a>";
		return userlink;
	});

	return parsedText;
};
