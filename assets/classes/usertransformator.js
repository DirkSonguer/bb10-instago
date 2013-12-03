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
Qt.include("../global/globals.js");
Qt.include("../structures/userdata.js");

// Class function that gets the prototype methods
function UserTransformator() {
}

// Extract all user data from a user object
// The resulting media data is in the standard media format as
// InstagramUserData()
UserTransformator.prototype.getUserDataFromObject = function(userObject) {
	var userData = new InstagramUserData();

	userData.userId = userObject.id;
	userData.username = userObject.username;
	userData.fullName = userObject.full_name;
	if (userData.fullName == "") {
		userData.fullName = userData.username;		
	}

	userData.bio = userObject.bio;
	if (userData.bio == "") {
		userData.bio = "No user bio";
	}

	userData.website = userObject.website;
	userData.profilePicture = userObject.profile_picture;

	// this might be null as it is not included in the user summary
	if (userObject.counts != null) {
		userData.numberOfPhotos = userObject.counts["media"];
		if (userData.numberOfPhotos > 10000)
			userData.numberOfPhotos = Math.floor(userData.numberOfPhotos / 1000) + "K";

		userData.numberOfFollowers = userObject.counts["followed_by"];
		if (userData.numberOfFollowers > 10000)
			userData.numberOfFollowers = Math.floor(userData.numberOfFollowers / 1000) + "K";

		userData.numberOfFollows = userObject.counts["follows"];
		if (userData.numberOfFollows > 10000)
			userData.numberOfFollows = Math.floor(userData.numberOfFollows / 1000) + "K";
	}

	return userData;
};
