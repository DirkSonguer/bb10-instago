//*************************************************** //
// Comment Transformator Class
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
Qt.include(dirPaths.assetPath + "structures/commentdata.js");
Qt.include(dirPaths.assetPath + "structures/userdata.js");
Qt.include(dirPaths.assetPath + "classes/texttransformator.js");
Qt.include(dirPaths.assetPath + "classes/usertransformator.js");

// Class function that gets the prototype methods
function CommentTransformator() {
}
// Extract all user data from a user object
// The resulting media data is in the standard media format as
// InstagramUserData()
CommentTransformator.prototype.getCommentDataFromObject = function(commentObject) {
	var commentData = new InstagramCommentData();

	// comment id
	commentData.commentId = commentObject.id;

	// general user information
	// this is stored as InstagramUserData()
	var userTransformator = new UserTransformator();
	commentData.userData = userTransformator.getUserDataFromObject(commentObject.from);

	// transform text so that it contains hashtags and users as links
	commentData.text = commentObject.text;
	commentData.createdTime = commentObject.created_time;
	
	var textTransformator = new TextTransformator();
	commentData.richText = commentData.text;
	commentData.richText = textTransformator.escapeHTML(commentData.richText);
	commentData.richText = textTransformator.addHashtagLinksToText(commentData.richText);
	commentData.richText = textTransformator.addUserLinksToText(commentData.richText);
	commentData.richText = textTransformator.convertToRichText(commentData.richText);

	return commentData;
};
