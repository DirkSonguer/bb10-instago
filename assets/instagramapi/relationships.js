// *************************************************** //
// Relationships Script
//
// This script is used to load, format and show user
// relationship data as well as provide user actions
// related to relationships.
//
// Author: Dirk Songuer
// License: GPL v2
// See: http://choosealicense.com/licenses/gpl-v2/
// *************************************************** //

//include other scripts used here
Qt.include(dirPaths.assetPath + "global/instagramkeys.js");
Qt.include(dirPaths.assetPath + "classes/authenticationhandler.js");
Qt.include(dirPaths.assetPath + "classes/usertransformator.js");
Qt.include(dirPaths.assetPath + "classes/networkhandler.js");
Qt.include(dirPaths.assetPath + "structures/userdata.js");

// Load the users that are following the given Instagram user id
// First parameter is the user id to get the data for
// Second parameter is the id of the calling page, which will receive the
// userFollowerDataLoaded() signal
function getUserFollowers(userId, cursorId, callingPage) {
	// console.log("# Loading user followers for user " + userId);

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

			// get cursor id
			var cursorId = 0;
			if (jsonObject.pagination.next_cursor != null) {
				cursorId = jsonObject.pagination.next_cursor;
			}

			// console.log("# Done loading user followers");
			callingPage.userFollowerDataLoaded(userArray, cursorId);
		} else {
			// either the request is not done yet or an error occured
			// check for both and act accordingly
			// found error will be handed over to the calling page
			if ((network.requestIsFinished) && (network.errorData.errorCode != "")) {
				// console.log("# Error found with code " + network.errorData.errorCode + " and message " + network.errorData.errorMessage);
				callingPage.userFollowerDataError(network.errorData);
				network.clearErrors();
			}
		}
	};

	// only authenticated users can request follower data
	var instagramUserdata = auth.getStoredInstagramData();
	var url = instagramkeys.instagramAPIUrl + "/v1/users/" + userId + "/followed-by?access_token=" + instagramUserdata["access_token"];

	// if a cursor id was given, add it to the request
	if (cursorId !== 0) {
		url += "&cursor=" + cursorId;
	}

	req.open("GET", url, true);
	req.send();
}

// Load the user follower data for a given Instagram user id
// First parameter is the user id to get the data for
// Second parameter is the id of the calling page, which will receive the
// userFollowingDataLoaded() signal
function getUserFollowing(userId, cursorId, callingPage) {
	// console.log("# Loading user following for user " + userId);

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

			// get cursor id
			var cursorId = 0;
			if (jsonObject.pagination.next_cursor != null) {
				cursorId = jsonObject.pagination.next_cursor;
			}

			// console.log("# Done loading user following");
			callingPage.userFollowingDataLoaded(userArray, cursorId);
		} else {
			// either the request is not done yet or an error occured
			// check for both and act accordingly
			// found error will be handed over to the calling page
			if ((network.requestIsFinished) && (network.errorData.errorCode != "")) {
				// console.log("# Error found with code " + network.errorData.errorCode + " and message " + network.errorData.errorMessage);
				callingPage.userFollowingDataError(network.errorData);
				network.clearErrors();
			}
		}
	};

	// only authenticated users can request follower data
	var instagramUserdata = auth.getStoredInstagramData();
	var url = instagramkeys.instagramAPIUrl + "/v1/users/" + userId + "/follows?access_token=" + instagramUserdata["access_token"];

	// if a cursor id was given, add it to the request
	if (cursorId !== 0) {
		url += "&cursor=" + cursorId;
	}

	req.open("GET", url, true);
	req.send();
}

// Get the relationship status of a given user
// First parameter is the user id to get the relationship for
// Second parameter is the id of the calling page, which will receive the
// userRelationshipLoaded() signal
function getRelationship(userId, callingPage) {
	// console.log("# Getting relationship for user " + userId);

	// check if the given user id is the currently logged in user or "self"
	var instagramUserdata = auth.getStoredInstagramData();
	if (((auth.isAuthenticated()) && (instagramUserdata["id"] == userId)) || (userId == "self")) {
		// console.log("# This is the current user");
		return;
	}

	var req = new XMLHttpRequest();
	req.onreadystatechange = function() {
		// this handles the result for each ready state
		var jsonObject = network.handleHttpResult(req);

		// jsonObject contains either false or the http result as object
		if (jsonObject) {
			callingPage.userRelationshipLoaded(jsonObject.data);
			// console.log("# Done getting relationship");
		} else {
			// either the request is not done yet or an error occured
			// check for both and act accordingly
			if ((network.requestIsFinished) && (network.errorData['code'] != null)) {
				// console.log("# Error found with code " + network.errorData.errorCode + " and message " + network.errorData.errorMessage);
				callingPage.userRelationshipError(network.errorData);
				network.clearErrors();
			}
		}
	};

	var url = instagramkeys.instagramAPIUrl + "/v1/users/" + userId + "/relationship?access_token=" + instagramUserdata["access_token"];

	req.open("GET", url, true);
	req.send();
}

// Set the relationship with a given user
// First parameter is the user id to set the relationship with
// Second parameter is the relationship for the given user:
// follow/unfollow/block/unblock/approve/ignore
// Third parameter is the id of the calling page, which will receive the
// userRelationshipLoaded() signal
function setRelationship(userId, relationship, callingPage) {
	// console.log("# Setting relationship for user " + userId + " to " + relationship);

	var req = new XMLHttpRequest();
	req.onreadystatechange = function() {

		// this handles the result for each ready state
		var jsonObject = network.handleHttpResult(req);

		// jsonObject contains either false or the http result as object
		if (jsonObject) {
			// console.log("# Done changing relationship");
			callingPage.userRelationshipSet(relationship);
		} else {
			// either the request is not done yet or an error occured
			// check for both and act accordingly
			if ((network.requestIsFinished) && (network.errorData['code'] != null)) {
				// console.log("# Error found with code " + network.errorData.errorCode + " and message " + network.errorData.errorMessage);
				callingPage.userRelationshipError(network.errorData);
				network.clearErrors();
			}
		}
	};

	var instagramUserdata = auth.getStoredInstagramData();
	var params = "access_token=" + instagramUserdata["access_token"] + "&action=" + relationship;

	var url = instagramkeys.instagramAPIUrl + "/v1/users/" + userId + "/relationship";

	req.open("POST", url, true);
	req.send(params);
}
