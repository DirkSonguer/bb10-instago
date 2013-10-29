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
Qt.include(dirPaths.assetPath + "classes/locationtransformator.js");
Qt.include(dirPaths.assetPath + "classes/usertransformator.js");
Qt.include(dirPaths.assetPath + "structures/userdata.js");
Qt.include(dirPaths.assetPath + "structures/mediadata.js");

// Load the media items that match the given location id
// First parameter is the location id to get the data for
// Second parameter is the pagination id given by Instagram for the next page
// Third parameter is the id of the calling page, which will receive the
// locationDataLoaded() signal
function getRecentMediaForLocation(locationId, paginationId, callingPage) {
	// console.log("# Loading media items for location id " + locationId + "
	// with pagination id " + paginationId);

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

			// console.log("# Done loading media data for location");
			callingPage.locationDataLoaded(mediaDataArray, paginationId);
		} else {
			// either the request is not done yet or an error occured
			// check for both and act accordingly
			// found error will be handed over to the calling page
			if ((network.requestIsFinished) && (network.errorData.errorCode != "")) {
				// console.log("# Error found with code " +
				// network.errorData.errorCode + " and message " +
				// network.errorData.errorMessage);
				callingPage.locationDataError(network.errorData);
				network.clearErrors();
			}
		}
	};

	// only authenticated users can search
	var instagramUserdata = auth.getStoredInstagramData();
	var url = instagramkeys.instagramAPIUrl + "/v1/locations/" + locationId + "/media/recent?access_token=" + instagramUserdata["access_token"];

	// if a pagination id was given, add it to the request
	if (paginationId !== 0) {
		url += "&max_id=" + paginationId;
	}

	req.open("GET", url, true);
	req.send();
}

// Load the media items that match the given geolocation
// First parameter is the location object to get the data for
// Second parameter is the pagination id given by Instagram for the next page
// Third parameter is the id of the calling page, which will receive the
// locationDataLoaded() signal
function getMediaForGeoLocation(GeoLocationObject, paginationId, callingPage) {
	// console.log("# Loading media items for location id " + locationId + "
	// with pagination id " + paginationId);

	var req = new XMLHttpRequest();
	req.onreadystatechange = function() {
		// this handles the result for each ready state
		var jsonObject = network.handleHttpResult(req);

		// jsonObject contains either false or the http result as object
		if (jsonObject) {
			// prepare transformator and return object
			var locationTransformator = new LocationTransformator();
			var mediaDataArray = new Array();

			// iterate through all media items
			for ( var index in jsonObject.data) {
				// get image object and store it into return object
				var mediaItem = new InstagramMediaData();
				mediaItem = locationTransformator.getLocationDataFromObject(jsonObject.data[index]);
				mediaDataArray[index] = mediaItem;
			}

			// console.log("# Done loading media data for location");
			callingPage.locationDataLoaded(mediaDataArray, paginationId);
		} else {
			// either the request is not done yet or an error occured
			// check for both and act accordingly
			// found error will be handed over to the calling page
			if ((network.requestIsFinished) && (network.errorData.errorCode != "")) {
				// console.log("# Error found with code " +
				// network.errorData.errorCode + " and message " +
				// network.errorData.errorMessage);
				callingPage.locationDataError(network.errorData);
				network.clearErrors();
			}
		}
	};

	// only authenticated users can search
	var instagramUserdata = auth.getStoredInstagramData();
	var url = instagramkeys.instagramAPIUrl + "/v1/locations/search?access_token=" + instagramUserdata["access_token"];
	url += "&lat=" + GeoLocationObject.latitude;
	url += "&lng=" + GeoLocationObject.longitude;
	
	console.log("# Location search URL: " + url);

	// if a pagination id was given, add it to the request
	if (paginationId !== 0) {
		url += "&max_id=" + paginationId;
	}

	req.open("GET", url, true);
	req.send();
}
