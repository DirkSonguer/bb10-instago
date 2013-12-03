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
Qt.include(dirPaths.assetPath + "global/globals.js");
Qt.include(dirPaths.assetPath + "structures/mediadata.js");

// Class function that gets the prototype methods
function LocationTransformator() {
}

// Extract all image data from an image object
// The resulting media data is in the standard media format as
// InstagramMediaData()
LocationTransformator.prototype.getLocationDataFromObject = function(locationObject) {
	var mediaData = new InstagramMediaData();

	// note that if this is the case the whole location node is missing
	// however if the location has no name, the node is there but not the nodes
	// inside it
	mediaData.locationId = locationObject.id;
	mediaData.locationName = locationObject.name;
	mediaData.locationLatitude = locationObject.latitude;
	mediaData.locationLongitude = locationObject.longitude;

	return mediaData;
};
