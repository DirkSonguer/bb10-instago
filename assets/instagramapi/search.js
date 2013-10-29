// *************************************************** //
// Search Script
//
// This script is used to load, format and show user
// or tag searches as well as provide user actions
// related to search.
// *************************************************** //

//include other scripts used here
Qt.include(dirPaths.assetPath + "global/instagramkeys.js");
Qt.include(dirPaths.assetPath + "classes/authenticationhandler.js");
Qt.include(dirPaths.assetPath + "classes/networkhandler.js");
Qt.include(dirPaths.assetPath + "classes/mediatransformator.js");
Qt.include(dirPaths.assetPath + "classes/usertransformator.js");
Qt.include(dirPaths.assetPath + "structures/userdata.js");
Qt.include(dirPaths.assetPath + "structures/mediadata.js");

// Load the media items that match the given search terms
// First parameter is the search string to get the data for
// Second parameter is the id of the calling page, which will receive the
// searchMediaDataLoaded() signal
function getMediaSearchResults(searchTags, paginationId, callingPage) {
	// console.log("# Searching for media items with tag(s) " + searchTags);

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

			// console.log("# Done loading media data for search");
			callingPage.searchMediaDataLoaded(mediaDataArray, paginationId);
		} else {
			// either the request is not done yet or an error occured
			// check for both and act accordingly
			// found error will be handed over to the calling page
			if ((network.requestIsFinished) && (network.errorData.errorCode != "")) {
				// console.log("# Error found with code " + network.errorData.errorCode + " and message " + network.errorData.errorMessage);
				callingPage.searchDataError(network.errorData);
				network.clearErrors();
			}
		}
	};

	// only authenticated users can search
	var instagramUserdata = auth.getStoredInstagramData();
	var url = instagramkeys.instagramAPIUrl + "/v1/tags/" + searchTags + "/media/recent?&access_token=" + instagramUserdata["access_token"];

	// if a pagination id was given, add it to the request
	if (paginationId !== 0) {
		url += "&max_id=" + paginationId;
	}
	
	console.log("# asset " + url);
	req.open("GET", url, true);
	req.send();
}

// Load the users that match the given search terms
// First parameter is the search term to get the data for
// Second parameter is the id of the calling page, which will receive the
// searchUserDataLoaded() signal
function getUserSearchResults(searchTags, callingPage) {
	// console.log("# Searching for users with tag(s) " + searchTags);

	var req = new XMLHttpRequest();
	req.onreadystatechange = function() {
		// this handles the result for each ready state
		var jsonObject = network.handleHttpResult(req);

		// jsonObject contains either false or the http result as object
		if (jsonObject) {
			// prepare transformator and return object
			var userTransformator = new UserTransformator();
			var userArray = new Array();

			// iterate through all user items
			for ( var index in jsonObject.data) {
				// get user object and store it into return object
				var userItem = new InstagramUserData();
				userItem = userTransformator.getUserDataFromObject(jsonObject.data[index]);
				userArray[index] = userItem;
			}

			// console.log("# Done loading user search data");
			callingPage.searchUserDataLoaded(userArray);
		} else {
			// either the request is not done yet or an error occured
			// check for both and act accordingly
			// found error will be handed over to the calling page
			if ((network.requestIsFinished) && (network.errorData.errorCode != "")) {
				// console.log("# Error found with code " + network.errorData.errorCode + " and message " + network.errorData.errorMessage);
				callingPage.searchDataError(network.errorData);
				network.clearErrors();
			}
		}
	};

	// only authenticated users can request follower data
	var instagramUserdata = auth.getStoredInstagramData();
	var url = instagramkeys.instagramAPIUrl + "/v1/users/search?q=" + searchTags + "&access_token=" + instagramUserdata["access_token"];

	console.log("# asset " + url);
	req.open("GET", url, true);
	req.send();
}
