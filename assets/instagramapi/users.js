// *************************************************** //
// Users Script
//
// This script is used to load, format and show user
// related data.
// *************************************************** //

//include other scripts used here
Qt.include(dirPaths.assetPath + "shared/global/instagramkeys.js");
Qt.include(dirPaths.assetPath + "shared/classes/authenticationhandler.js");
Qt.include(dirPaths.assetPath + "shared/classes/usertransformator.js");
Qt.include(dirPaths.assetPath + "shared/classes/mediatransformator.js");
Qt.include(dirPaths.assetPath + "shared/classes/networkhandler.js");
Qt.include(dirPaths.assetPath + "shared/structures/userdata.js");

// Load the user data for a given Instagram user id
// First parameter is the user id to get the data for
// Second parameter is the id of the calling page, which will receive the
// userProfileDataLoaded() signal
function getUserProfile(userId, callingPage) {
	// console.log("# Loading user profile for user " + userId);

	var req = new XMLHttpRequest();
	req.onreadystatechange = function() {
		// this handles the result for each ready state
		var jsonObject = network.handleHttpResult(req);

		// jsonObject contains either false or the http result as object
		if (jsonObject) {
			// prepare transformator and return object
			var userTransformator = new UserTransformator();
			var userItem = new InstagramUserData();

			// get user object and store it into return object
			userItem = userTransformator.getUserDataFromObject(jsonObject.data);

			// console.log("# Done loading user profile");
			callingPage.userProfileDataLoaded(userItem);
		} else {
			// normally there is no need for error handling here the normal
			// user page will execute getRelationship, which will handle the
			// error states however this method is also used for loading the
			// profile page data, which needs error handling either the
			// request is not done yet or an error occured check for both
			// and act accordingly
			// found error will be handed over to the calling page
			var instagramUserdata = auth.getStoredInstagramData();
			if (((network.requestIsFinished) && (network.errorData.errorCode != "")) && auth.isAuthenticated() && (instagramUserdata["id"] == userId)) {
				// console.log("# Error found with code " +
				// network.errorData.errorCode + " and message " +
				// network.errorData.errorMessage);
				callingPage.userProfileDataError(network.errorData);
				network.clearErrors();
			}
		}
	};

	var url = "";
	if (auth.isAuthenticated()) {
		// we need the auth token for users that are private
		var instagramUserdata = auth.getStoredInstagramData();
		url = instagramkeys.instagramAPIUrl + "/v1/users/" + userId + "?access_token=" + instagramUserdata["access_token"];
	} else {
		// calls with the client id can only show public users
		url = instagramkeys.instagramAPIUrl + "/v1/users/" + userId + "?client_id=" + instagramkeys.instagramClientId;
	}

	req.open("GET", url, true);
	req.send();
}

// Load the media data for a given Instagram user id
// First parameter is the user id to get the data for
// Second parameter is the pagination id given by Instagram for the next page
// Third parameter is the id of the calling page, which will receive the
// userMediaDataLoaded() signal
function getUserMedia(userId, paginationId, callingPage) {
	// console.log("# Loading media data for user " + userId);

	var req = new XMLHttpRequest();
	req.onreadystatechange = function() {
		// this handles the result for each ready state
		var jsonObject = network.handleHttpResult(req);

		// jsonObject contains either false or the http result as object
		if (jsonObject) {
			// prepare transformator and return object
			var mediaDataArray = new Array();
			var mediaTransformator = new MediaTransformator();

			// iterate through all media items
			for ( var index in jsonObject.data) {
				// get image object and store it into return object
				var mediaItem = new InstagramMediaData();
				mediaItem = mediaTransformator.getMediaDataFromObject(jsonObject.data[index]);
				mediaDataArray[index] = mediaItem;
			}

			// get pagination id
			var paginationId = 0;
			if (jsonObject.pagination.next_max_id != null) {
				paginationId = jsonObject.pagination.next_max_id;
			}

			// console.log("# Done loading media data for user");
			callingPage.userMediaDataLoaded(mediaDataArray, paginationId);
		} else {
			// either the request is not done yet or an error occured
			// check for both and act accordingly
			// found error will be handed over to the calling page
			if ((network.requestIsFinished) && (network.errorData.errorCode != "")) {
				// console.log("# Error found with code " +
				// network.errorData.errorCode + " and message " +
				// network.errorData.errorMessage);
				callingPage.userMediaDataError(network.errorData);
				network.clearErrors();
			}
		}
	};

	// only authenticated users can request media item data for a user
	var instagramUserdata = auth.getStoredInstagramData();
	var url = instagramkeys.instagramAPIUrl + "/v1/users/" + userId + "/media/recent?access_token=" + instagramUserdata["access_token"];

	// if a pagination id was given, add it to the request
	if (paginationId !== 0) {
		url += "&max_id=" + paginationId;
	}

	req.open("GET", url, true);
	req.send();
}

// Load the user id for a given Instagram user name
// First parameter is the user name to get the id for
// Second parameter is the id of the calling page, which will receive the
// userIdLoaded() signal
function getUserIdByName(userName, callingPage) {
	// console.log("# Loading user profile for user with name " + userName);

	var req = new XMLHttpRequest();
	req.onreadystatechange = function() {
		// this handles the result for each ready state
		var jsonObject = network.handleHttpResult(req);

		// jsonObject contains either false or the http result as object
		if (jsonObject) {
			// prepare return object
			var foundUserId = 0;

			// there may be multiple results for a given user name
			for ( var index in jsonObject.data) {
				// store the user id into the page
				// only store the first user id as the count parameter does not
				// work and Instagram always returns all users
				if (!foundUserId) {
					foundUserId = jsonObject.data[index].id;
				}
			}

			// console.log("# Done loading user is by name");
			callingPage.userIdLoaded(foundUserId, userName);
		} else {
			// normally there is no need for error handling here the normal
			// user page will execute getRelationship, which will handle the
			// error states however this method is also used for loading the
			// profile page data, which needs error handling either the
			// request is not done yet or an error occured check for both
			// and act accordingly
			// found error will be handed over to the calling page
			var instagramUserdata = auth.getStoredInstagramData();
			if (((network.requestIsFinished) && (network.errorData.errorCode != "")) && auth.isAuthenticated() && (instagramUserdata["id"] == userId)) {
				// console.log("# Error found with code " +
				// network.errorData.errorCode + " and message " +
				// network.errorData.errorMessage);
				callingPage.userIdError(network.errorData);
				network.clearErrors();
			}
		}
	};

	// only authenticated users can request the user id / do a user search
	var instagramUserdata = auth.getStoredInstagramData();
	var url = instagramkeys.instagramAPIUrl + "/v1/users/search?q=" + userName + "&count=1&access_token=" + instagramUserdata["access_token"];

	req.open("GET", url, true);
	req.send();
}

// Logout the current user
// This calls the logout page of Instagram and thus clears the web cache for the
// user. Actually this doesn't work for whatever reason, kept here for
// documentation purposes
function logoutUser() {
	// console.log("# Logging user out from Instagram");

	var req = new XMLHttpRequest();
	req.onreadystatechange = function() {
		// check if the server response is actually finished
		if (req.readyState === XMLHttpRequest.DONE) {
			// console.log("# Logout done, status " + req.status + " with text " + req.responseText);
		}
	};

	var url = "https://instagram.com/accounts/logout/";

	req.open("GET", url, true);
	req.send();
}

// Load the popular image stream from Instagram
// First parameter is the pagination id given by Instagram for the next page
// Second parameter is the id of the calling page, which will receive the
// personalFeedLoaded() signal
function getPersonalFeed(paginationId, callingPage) {
	// console.log("Loading personal feed");

	var req = new XMLHttpRequest();
	req.onreadystatechange = function() {
		// this handles the result for each ready state
		var jsonObject = network.handleHttpResult(req);

		// jsonObject contains either false or the http result as object
		if (jsonObject) {
			// prepare transformator and return object
			var mediaTransformator = new MediaTransformator();
			var mediaDataArray = new Array();

			// iterate through all media items
			for ( var index in jsonObject.data) {
				// get image object and store it into return object
				var mediaItem = new InstagramMediaData();
				mediaItem = mediaTransformator.getMediaDataFromObject(jsonObject.data[index]);
				mediaDataArray[index] = mediaItem;
			}

			// get pagination id
			var paginationId = 0;
			if (jsonObject.pagination.next_max_id != null) {
				paginationId = jsonObject.pagination.next_max_id;
			}

			// console.log("# Done loading personal feed");
			callingPage.personalFeedLoaded(mediaDataArray, paginationId);
		} else {
			// either the request is not done yet or an error occured
			// check for both and act accordingly
			// found error will be handed over to the calling page
			if ((network.requestIsFinished) && (network.errorData.errorCode != "")) {
				// console.log("# Error found with code " +
				// network.errorData.errorCode + " and message " +
				// network.errorData.errorMessage);
				callingPage.personalFeedError(network.errorData);
				network.clearErrors();
			}
		}
	};

	var instagramUserdata = auth.getStoredInstagramData();
	var url = instagramkeys.instagramAPIUrl + "/v1/users/self/feed?access_token=" + instagramUserdata["access_token"];

	// if a pagination id was given, add it to the request
	if (paginationId !== 0) {
		url += "&max_id=" + paginationId;
	}

	req.open("GET", url, true);
	req.send();
}

// Load the favorite media for the currently logged in user
// First parameter is the pagination id given by Instagram for the next page
// Second parameter is the id of the calling page, which will receive the
// onUserFavoritesDataLoaded() signal
function getUserFavorites(paginationId, callingPage) {
	// console.log("# Loading favorite media data for pagination ID " + paginationId + " on page " + callingPage);

	var req = new XMLHttpRequest();
	req.onreadystatechange = function() {
		// this handles the result for each ready state
		var jsonObject = network.handleHttpResult(req);

		// jsonObject contains either false or the http result as object
		if (jsonObject) {
			// prepare transformator and return object
			var mediaDataArray = new Array();
			var mediaTransformator = new MediaTransformator();

			// iterate through all media items
			for ( var index in jsonObject.data) {
				// get image object and store it into return object
				var mediaItem = new InstagramMediaData();
				mediaItem = mediaTransformator.getMediaDataFromObject(jsonObject.data[index]);
				mediaDataArray[index] = mediaItem;
			}

			// get pagination id
			var paginationId = 0;
			if (jsonObject.pagination.next_max_id != null) {
				paginationId = jsonObject.pagination.next_max_id;
			}

			// console.log("# Done loading media data for user");
			callingPage.userFavoritesDataLoaded(mediaDataArray, paginationId);
		} else {
			// either the request is not done yet or an error occured
			// check for both and act accordingly
			// found error will be handed over to the calling page
			if ((network.requestIsFinished) && (network.errorData.errorCode != "")) {
				// console.log("# Error found with code " +
				// network.errorData.errorCode + " and message " +
				// network.errorData.errorMessage);
				callingPage.userFavoritesDataError(network.errorData);
				network.clearErrors();
			}
		}
	};

	// only authenticated users can request media item data for a user
	var instagramUserdata = auth.getStoredInstagramData();
    var url = instagramkeys.instagramAPIUrl + "/v1/users/self/media/liked?access_token=" + instagramUserdata["access_token"];

	// if a pagination id was given, add it to the request
	if (paginationId !== 0) {
		url += "&max_id=" + paginationId;
	}

	req.open("GET", url, true);
	req.send();
}
