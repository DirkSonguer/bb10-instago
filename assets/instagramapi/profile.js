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
function getProfileData(callingPage) {
	// console.log("# Uploading image " + fileName);

	var req = new XMLHttpRequest();
	req.onreadystatechange = function() {
		// this handles the result for each ready state
		console.log("# Loading state: " + req.readyState);
		
		if (req.readyState === req.DONE) {
			var formString = req.responseText;
			var tempIndexPosition = 0;
			
			tempIndexPosition= formString.indexOf("<form");
			formString = formString.substr(tempIndexPosition);
			
			tempIndexPosition = formString.indexOf("name=\"csrfmiddlewaretoken\" value=");
			var csrfmiddlewaretoken = formString.substr(tempIndexPosition + 34);
			tempIndexPosition = csrfmiddlewaretoken.indexOf("\"");
			csrfmiddlewaretoken = csrfmiddlewaretoken.substr(0, tempIndexPosition);
			console.log("# Found csrfmiddlewaretoken: " + csrfmiddlewaretoken);

			tempIndexPosition = formString.indexOf("input name=\"first_name\" autocorrect=\"off\" value=");
			var username = formString.substr(tempIndexPosition + 49);
			console.log(username);
			tempIndexPosition = username.indexOf("\"");
			console.log("Position: " + tempIndexPosition);
			username = username.substr(0, tempIndexPosition);
			console.log("# Found username: " + username);
		}		
	};

	// only authenticated users can search
	var url = "https://instagram.com/accounts/edit/";
	req.open("GET", url, true);
	req.send();
}
