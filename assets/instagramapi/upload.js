// *************************************************** //
// Search Script
//
// This script is used to load, format and show user
// or tag searches as well as provide user actions
// related to search.
// *************************************************** //

//include other scripts used here
Qt.include(dirPaths.assetPath + "shared/global/instagramkeys.js");
Qt.include(dirPaths.assetPath + "shared/classes/authenticationhandler.js");
Qt.include(dirPaths.assetPath + "shared/classes/networkhandler.js");
Qt.include(dirPaths.assetPath + "shared/classes/mediatransformator.js");
Qt.include(dirPaths.assetPath + "shared/classes/usertransformator.js");
Qt.include(dirPaths.assetPath + "shared/structures/userdata.js");
Qt.include(dirPaths.assetPath + "shared/structures/mediadata.js");

// Load the media items that match the given search terms
// First parameter is the search string to get the data for
// Second parameter is the id of the calling page, which will receive the
// searchMediaDataLoaded() signal
function uploadImage(fileName, callingPage) {
	// console.log("# Uploading image " + fileName);

	var req = new XMLHttpRequest();
	req.onreadystatechange = function() {
		// this handles the result for each ready state
		var jsonObject = network.handleHttpResult(req);
		// console.log("# Return: " + jsonObject);

		// jsonObject contains either false or the http result as object
		if (jsonObject) {
/*
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

			// console.log("# Done loading media data for search");
			callingPage.searchMediaDataLoaded(mediaDataArray);
*/
		} else {
			// either the request is not done yet or an error occured
			// check for both and act accordingly
			// found error will be handed over to the calling page
			if ((network.requestIsFinished) && (network.errorData.errorCode != "")) {
				// console.log("# Error found with code " + network.errorData.errorCode + " and message " + network.errorData.errorMessage);
				callingPage.updateError(network.errorData);
				network.clearErrors();
			}
		}
	};

	// only authenticated users can search
	var instagramUserdata = auth.getStoredInstagramData();
	var timestamp = new Date().getTime();
	var params = "device_timestamp=" + timestamp + "&lat=0&lng=0";

	var url = instagramkeys.instagramAPIUrl + "/v1/media/upload?access_token=" + instagramUserdata["access_token"];
	req.open("POST", url, true);
	req.send(params);
}
