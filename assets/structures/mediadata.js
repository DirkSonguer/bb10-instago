// *************************************************** //
// Media Data Structure
//
// This structure holds media data for a single
// Instagram media.
// *************************************************** //

// data structure for Instagram media
function InstagramMediaData() {
	// general image information and links
	this.mediaId = "";
	this.mediaType = ""; // can be either image or video

	this.mediaThumbnailUrl = ""; // 150x150
	this.mediaStandardImage = ""; // 612x612
	this.mediaStandardVideo = ""; // 640x640

	// general user information
	this.userData = "";
	this.userHasLiked = "";

	// image caption
	this.caption = "";
	this.richCaption = "";

	// number of likes and comments
	this.numberOfLikes = "";
	this.numberOfComments = "";
	this.commentData = "";

	// creation time
	this.timestamp = "";
	this.createdTime = "";
	this.elapsedTime = "";

	// location info
	this.locationId = "";
	this.locationName = "";
	this.locationLatitude = "";
	this.locationLongitude = "";

	// general Instagram data
	this.linkToInstagram = "";
}
