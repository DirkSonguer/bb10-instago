//*************************************************** //
// Media Endpoint Script

// This script is used to handle all calls to the media
// endpoints of Instagram.
//*************************************************** //

//include other scripts used here
Qt.include(dirPaths.assetPath + "global/instagramkeys.js");
Qt.include(dirPaths.assetPath + "global/copytext.js");
Qt.include(dirPaths.assetPath + "classes/authenticationhandler.js");
Qt.include(dirPaths.assetPath + "classes/networkhandler.js");
Qt.include(dirPaths.assetPath + "classes/mediatransformator.js");
Qt.include(dirPaths.assetPath + "classes/usertransformator.js");
Qt.include(dirPaths.assetPath + "classes/commenttransformator.js");
Qt.include(dirPaths.assetPath + "structures/mediadata.js");

// Load the popular media stream from Instagram
// The resulting media data is in the standard media format provided by the
// helper methods
// Parameter is the id of the calling page, which will receive the
// popularMediaDataLoaded() signal
function getPopularMedia(callingPage) {
	// console.log("# Loading popular media data from Instagram");

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

			// console.log("# Done loading popular media");
			callingPage.popularMediaDataLoaded(mediaDataArray);
		} else {
			// either the request is not done yet or an error occured
			// check for both and act accordingly
			// found error will be handed over to the calling page
			if ((network.requestIsFinished) && (network.errorData.errorCode != "")) {
				// console.log("# Error found with code " +
				// network.errorData.errorCode + " and message " +
				// network.errorData.errorMessage);
				callingPage.popularMediaDataError(network.errorData);
				network.clearErrors();
			}
		}
	};

	var url = instagramkeys.instagramAPIUrl + "/v1/media/popular?client_id=" + instagramkeys.instagramClientId;

	req.open("GET", url, true);
	req.send();
}

// Load the media data for a given media id
// The media data is the standard media format provided by the helper methods
// First parameter is the media id to get the data for
// Second parameter is the id of the calling page, which will receive the
// mediaDataLoaded() signal
function getMediaData(mediaId, callingPage) {
	// console.log("# Loading media data for media id " + mediaId);

	var req = new XMLHttpRequest();
	req.onreadystatechange = function() {
		// this handles the result for each ready state
		var jsonObject = network.handleHttpResult(req);

		// jsonObject contains either false or the http result as object
		if (jsonObject) {
			// prepare transformator and return object
			var mediaTransformator = new MediaTransformator();
			var mediaItem = new InstagramMediaData();

			// get image object and store it into return object
			mediaItem = mediaTransformator.getMediaDataFromObject(jsonObject.data);

			// console.log("# Done loading media data");
			callingPage.mediaDataLoaded(mediaItem);
		} else {
			// either the request is not done yet or an error occured
			// check for both and act accordingly
			// found error will be handed over to the calling page
			if ((network.requestIsFinished) && (network.errorData.errorCode != "")) {
				// console.log("# Error found with code " +
				// network.errorData.errorCode + " and message " +
				// network.errorData.errorMessage);
				callingPage.mediaDataError(network.errorData);
				network.clearErrors();
			}
		}
	};

	// only authenticated users can request media item data
	var instagramUserdata = auth.getStoredInstagramData();
	var url = instagramkeys.instagramAPIUrl + "/v1/media/" + mediaId + "?access_token=" + instagramUserdata["access_token"];

	req.open("GET", url, true);
	req.send();
}

// Load the users that are liking the given media id
// First parameter is the media id to get the data for
// Second parameter is the id of the calling page, which will receive the
// mediaLikesLoaded() signal
function getLikes(mediaId, callingPage) {
	// console.log("# Getting likes for media " + mediaId);

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

			// console.log("# Done loading media likes");
			callingPage.mediaLikesLoaded(userArray);
		} else {
			// either the request is not done yet or an error occured
			// check for both and act accordingly
			// found error will be handed over to the calling page
			if ((network.requestIsFinished) && (network.errorData.errorCode != "")) {
				// console.log("# Error found with code " +
				// network.errorData.errorCode + " and message " +
				// network.errorData.errorMessage);
				callingPage.mediaLikesError(network.errorData);
				network.clearErrors();
			}
		}
	};

	// only authenticated users can request follower data
	var instagramUserdata = auth.getStoredInstagramData();
	var url = instagramkeys.instagramAPIUrl + "/v1/media/" + mediaId + "/likes?access_token=" + instagramUserdata["access_token"];

	req.open("GET", url, true);
	req.send();
}

// Add a like for a given media item
// First parameter is the media id to add the like to
// Second parameter is the id of the calling page, which will receive the
// likeAdded() signal
function addLike(mediaId, callingPage) {
	// console.log("# Adding like to media with id " + mediaId);

	var req = new XMLHttpRequest();
	req.onreadystatechange = function() {
		// this handles the result for each ready state
		var jsonObject = network.handleHttpResult(req);

		// jsonObject contains either false or the http result as object
		if (jsonObject) {
			// console.log("# Done adding like to media item");
			callingPage.likeAdded(instagoAddLikeSuccess);
		} else {
			// either the request is not done yet or an error occured
			// check for both and act accordingly
			if ((network.requestIsFinished) && (network.errorData.errorCode != "")) {
				callingPage.likeAdded(instagoAddLikeError + network.errorData.errorMessage);
				network.clearErrors();
			}
		}
	};

	// only authenticated users can like a media item
	var instagramUserdata = auth.getStoredInstagramData();
	var params = "access_token=" + instagramUserdata["access_token"];
	var url = instagramkeys.instagramAPIUrl + "/v1/media/" + mediaId + "/likes";

	req.open("POST", url, true);
	req.send(params);
}

// Remove a like for a given media item
// First parameter is the media id to remove the like from
// Second parameter is the id of the calling page, which will receive the
// likeRemoved() signal
function removeLike(mediaId, callingPage) {
	// console.log("# Removing like from media with id " + mediaId);

	var req = new XMLHttpRequest();
	req.onreadystatechange = function() {
		// this handles the result for each ready state
		var jsonObject = network.handleHttpResult(req);

		// jsonObject contains either false or the http result as object
		if (jsonObject) {
			// console.log("# Done removing like from item");
			callingPage.likeRemoved(instagoRemoveLikeSuccess);
		} else {
			// either the request is not done yet or an error occured
			// check for both and act accordingly
			if ((network.requestIsFinished) && (network.errorData.errorCode != "")) {
				callingPage.likeRemoved(instagoRemoveLikeError + network.errorData.errorMessage);
				network.clearErrors();
			}
		}
	};

	// only authenticated users can remove likes from media items
	var instagramUserdata = auth.getStoredInstagramData();
	var url = instagramkeys.instagramAPIUrl + "/v1/media/" + mediaId + "/likes?access_token=" + instagramUserdata["access_token"];

	req.open("DELETE", url, true);
	req.send();
}

// Load the comments for the given media id
// First parameter is the media id to get the data for
// Second parameter is the id of the calling page, which will receive the
// mediaLikesLoaded() signal
function getComments(mediaId, callingPage) {
	// console.log("# Getting comments for media " + mediaId);

	var req = new XMLHttpRequest();
	req.onreadystatechange = function() {
		// this handles the result for each ready state
		var jsonObject = network.handleHttpResult(req);

		// jsonObject contains either false or the http result as object
		if (jsonObject) {
			// prepare transformator and return object
			var commentTransformator = new CommentTransformator();
			var commentArray = new Array();

			// iterate through all user items
			for ( var index in jsonObject.data) {
				// get user object and store it into return object
				var commentItem = new InstagramUserData();
				commentItem = commentTransformator.getCommentDataFromObject(jsonObject.data[index]);
				commentArray[index] = commentItem;
			}

			// console.log("# Done loading media comments");
			callingPage.mediaCommentsLoaded(commentArray);
		} else {
			// either the request is not done yet or an error occured
			// check for both and act accordingly
			// found error will be handed over to the calling page
			if ((network.requestIsFinished) && (network.errorData.errorCode != "")) {
				// console.log("# Error found with code " +
				// network.errorData.errorCode + " and message " +
				// network.errorData.errorMessage);
				callingPage.mediaCommentsError(network.errorData);
				network.clearErrors();
			}
		}
	};

	// only authenticated users can request follower data
	var instagramUserdata = auth.getStoredInstagramData();
	var url = instagramkeys.instagramAPIUrl + "/v1/media/" + mediaId + "/comments?access_token=" + instagramUserdata["access_token"];

	req.open("GET", url, true);
	req.send();
}

// Add a comment to a given image
// First parameter is the media id to add the comment to
// Second parameter is the actual comment text to add
// Third parameter is the id of the calling page, which will receive the
// commentAdded() signal
function addComment(mediaId, commentText, callingPage) {
	// console.log("Adding comment for " + mediaId);

	var req = new XMLHttpRequest();
	req.onreadystatechange = function() {
		// this handles the result for each ready state
		var jsonObject = network.handleHttpResult(req);

		// jsonObject contains either false or the http result as object
		if (jsonObject) {
			// console.log("# Done adding comment to media item");
			callingPage.commentAdded(instagoAddCommentSuccess);
		} else {
			// either the request is not done yet or an error occured
			// check for both and act accordingly
			if ((network.requestIsFinished) && (network.errorData.errorCode != "")) {
				callingPage.commentAdded(instagoAddCommentError + network.errorData.errorMessage);
				network.clearErrors();
			}
		}
	};

	// only authenticated users can like a media item
	var instagramUserdata = auth.getStoredInstagramData();
	var params = "access_token=" + instagramUserdata["access_token"] + "&text=" + commentText;
	var url = instagramkeys.instagramAPIUrl + "/v1/media/" + mediaId + "/comments";

	req.open("POST", url, true);
	req.send(params);
}

// Delete a comment with a given id
// First parameter is the media id to add the comment to
// Second parameter is the comment id to delete
// Third parameter is the id of the calling page, which will receive the
// commentDeleted() signal
function deleteComment(mediaId, commentId, callingPage) {
	console.log("Deleting comment with id " + commentId);

	var req = new XMLHttpRequest();
	req.onreadystatechange = function() {
		// this handles the result for each ready state
		var jsonObject = network.handleHttpResult(req);

		// jsonObject contains either false or the http result as object
		if (jsonObject) {
			// console.log("# Done adding comment to media item");
			callingPage.commentDeleted(instagoDeleteCommentSuccess);
		} else {
			// either the request is not done yet or an error occured
			// check for both and act accordingly
			if ((network.requestIsFinished) && (network.errorData.errorCode != "")) {
				callingPage.commentDeleted(instagoDeleteCommentError + network.errorData.errorMessage);
				network.clearErrors();
			}
		}
	};

	// only authenticated users can like a media item
	var instagramUserdata = auth.getStoredInstagramData();
	var url = instagramkeys.instagramAPIUrl + "/v1/media/" + mediaId + "/comments/" + commentId + "?access_token=" + instagramUserdata["access_token"];

	req.open("DELETE", url, true);
	req.send();
}
