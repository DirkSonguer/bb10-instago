// *************************************************** //
// Instagramkeys
//
// These are the keys for the Instagram client
// You can get your own here:
// http://instagram.com/developer/clients/manage/
// (you need to be logged into Instagram to create apps)
//
// Author: Dirk Songuer
// License: All rights reserved
// Do NOT use this API key :)
// *************************************************** //

//singleton instance of class
var instagramkeys = new InstagramKeys();

// class function that gets the prototype methods
function InstagramKeys()
{
	// Instagram client id
	this.instagramClientId = "3bbd61a332384e66a46026c3dbbfaadc";

	// Instagram API URL
	this.instagramAPIUrl = "https://api.instagram.com";
	// this.instagramAPIUrl = "http://192.168.248.1";
	
	// Instagram URL the user authenticates against
	this.instagramAuthorizeUrl = this.instagramAPIUrl + "/oauth/authorize";

	// Instagram URL to request a permanent token
	this.instagramTokenRequestUrl = this.instagramAPIUrl + "/oauth/authorize";

	// Instagram redirect URL
	this.instagramRedirectUrl = "http://www.instago.mobi";
}
