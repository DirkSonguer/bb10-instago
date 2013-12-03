//*************************************************** //
// Media Transformator Class
//
// This class contains methods to transform the data
// from Instagram into usable stuctures.
//
// Author: Dirk Songuer
// License: GPL v2
// See: http://choosealicense.com/licenses/gpl-v2/
//*************************************************** //

// include other scripts used here
Qt.include(dirPaths.assetPath + "global/globals.js");
Qt.include(dirPaths.assetPath + "classes/texttransformator.js");
Qt.include(dirPaths.assetPath + "classes/usertransformator.js");
Qt.include(dirPaths.assetPath + "classes/commenttransformator.js");
Qt.include(dirPaths.assetPath + "structures/mediadata.js");
Qt.include(dirPaths.assetPath + "structures/userdata.js");
Qt.include(dirPaths.assetPath + "structures/commentdata.js");

// Class function that gets the prototype methods
function MediaTransformator() {
}

// Format an Instagram time stamp into readable format / date object
// Return format will be mm/dd/yy, HH:MM
MediaTransformator.prototype.formatInstagramTime = function(instagramTime) {
	var time = new Date(instagramTime * 1000);
	var timeStr = (time.getMonth() + 1) + "/" + time.getDate() + "/" + time.getFullYear() + ", ";

	// make sure hours have 2 digits
	if (time.getHours() < 10) {
		timeStr += "0" + time.getHours();
	} else {
		timeStr += time.getHours();
	}

	timeStr += ":";

	// make sure minutes have 2 digits
	if (time.getMinutes() < 10) {
		timeStr += "0" + time.getMinutes();
	} else {
		timeStr += time.getMinutes();
	}

	return timeStr;
};

// Calculate the elapsed time for a timestamp until now
// Return format will be XX seconds / minutes / days / months / years ago
MediaTransformator.prototype.calculateElapsedTime = function(instagramTime) {
	var msPerMinute = 60 * 1000;
	var msPerHour = msPerMinute * 60;
	var msPerDay = msPerHour * 24;
	var msPerMonth = msPerDay * 30;
	var msPerYear = msPerDay * 365;

	var currentTime = new Date().getTime();
	var time = new Date(instagramTime * 1000).getTime();
	var elapsed = currentTime - time;

	if (elapsed < msPerMinute) {
		return Math.round(elapsed / 1000) + 's';
	} else if (elapsed < msPerHour) {
		return Math.round(elapsed / msPerMinute) + 'm';
	} else if (elapsed < msPerDay) {
		return Math.round(elapsed / msPerHour) + 'h';
	} else if (elapsed < msPerMonth) {
		return Math.round(elapsed / msPerDay) + 'd';
	} else if (elapsed < msPerYear) {
		return (Math.round(elapsed / msPerMonth) * 4) + 'w';
	} else {
		return Math.round(elapsed / msPerYear) + 'y';
	}
};

// Analyze text and add links to hashtags
// Hashtags start with # followed by the actual tag and end on a blank
MediaTransformator.prototype.addHashtagLinksToText = function(originalText) {
	var parsedText = "";

	var regexp = new RegExp('#([^\\s]*)', 'g');
	parsedText = originalText.replace(regexp, function(u) {
		var hashtag = u.replace("#", "");
		var hashtaglink = "<a href=\"hashtag:" + hashtag + "\">" + u + "</a>";
		return hashtaglink;
	});

	return parsedText;
};

// Analyze text and add links to user names
// User names start with @ followed by the actual name and end on a blank
MediaTransformator.prototype.addUserLinksToText = function(originalText) {
	var parsedText = "";

	var regexp = new RegExp('[@]+[A-Za-z0-9-_]+', 'g');
	parsedText = originalText.replace(regexp, function(u) {
		var username = u.replace("@", "");
		var userlink = "<a href=\"user:" + username + "\">" + u + "</a>";
		return userlink;
	});

	return parsedText;
};

// Replace line breaks with <br /> for use with html / rich text fields
MediaTransformator.prototype.replaceLineBreaks = function(originalText) {
	var parsedText = "";

	parsedText = originalText.replace("\n", "<br />");

	return parsedText;
};

// Extract all image data from an image object
// The resulting media data is in the standard media format as
// InstagramMediaData()
MediaTransformator.prototype.getMediaDataFromObject = function(imageObject) {
	var mediaData = new InstagramMediaData();

	// general image information and links
	mediaData.mediaId = imageObject.id;
	mediaData.mediaType = imageObject.type;
	// console.log("# Image with ID " + mediaData.mediaId + " is of type " + mediaData.mediaType);

	// image and video links
	mediaData.mediaThumbnailUrl = imageObject.images["thumbnail"]["url"];
	mediaData.mediaStandardImage = imageObject.images["standard_resolution"]["url"];
	if ((typeof imageObject.videos !== "undefined") && (imageObject.videos["standard_resolution"]["url"] !== undefined)) {
		mediaData.mediaStandardVideo = imageObject.videos["standard_resolution"]["url"];
	}

	// general user information
	// this is stored as InstagramUserData()
	var userTransformator = new UserTransformator();
	mediaData.userData = userTransformator.getUserDataFromObject(imageObject.user);

	// likes
	mediaData.numberOfLikes = imageObject.likes["count"];

	// don't trust imageObject.comments["count"] as it will be wrong for some
	// users however this call just returns a maximum of 8 comments so we can
	// only fact check up to 8
	mediaData.numberOfComments = imageObject.comments["count"];
	if (mediaData.numberOfComments <= 8) {
		var tempCommentArray = new Array();
		tempCommentArray = imageObject.comments["data"];
		mediaData.numberOfComments = tempCommentArray.length;
	}
	
	// extract the preview comments
	// this is stored as InstagramCommentData()
	var commentTransformator = new CommentTransformator();
	mediaData.commentData = new Array();
    for (var index in imageObject.comments["data"]) {
    	var tempCommentObject = commentTransformator.getCommentDataFromObject(imageObject.comments["data"][index]);
    	mediaData.commentData.push(tempCommentObject);
    }

	// get and format date
	mediaData.timestamp = imageObject.created_time;
	mediaData.createdTime = this.formatInstagramTime(imageObject.created_time);
	mediaData.elapsedTime = this.calculateElapsedTime(imageObject.created_time);

	// image may have no location
	// note that if this is the case the whole location node is missing
	// however if the location has no name, the node is there but not the nodes
	// inside it
	if ((imageObject.location !== null) && (imageObject.location["name"] !== undefined)) {
		mediaData.locationId = imageObject.location["id"];
		mediaData.locationName = imageObject.location["name"];
		mediaData.locationLatitude = imageObject.location["latitude"];
		mediaData.locationLongitude = imageObject.location["longitude"];
	}

	// image may be liked by user
	// this node is only in the result set if the user is logged in
	if (imageObject.user_has_liked !== null) {
		mediaData.userHasLiked = imageObject.user_has_liked;
	}

	// images that are new and just updated may not have an Instagram page yet
	// their link will thus be null
	if (imageObject.link !== null) {
		mediaData.linkToInstagram = imageObject.link;
	}

	// caption node may not exist if empty
	if (imageObject.caption !== null) {
		// add actual text content
		mediaData.caption = imageObject.caption["text"];

		var textTransformator = new TextTransformator();
		mediaData.richCaption = mediaData.caption;
		mediaData.richCaption = textTransformator.escapeHTML(mediaData.richCaption);
		mediaData.richCaption = textTransformator.addHashtagLinksToText(mediaData.richCaption);
		mediaData.richCaption = textTransformator.addUserLinksToText(mediaData.richCaption);
		mediaData.richCaption = textTransformator.convertToRichText(mediaData.richCaption);
	}

	return mediaData;
};
