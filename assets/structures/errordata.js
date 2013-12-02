// *************************************************** //
// Error Structure
//
// This structure holds possible network and API errors.
// This might either be triggered by the network stack,
// Instagram or by the application itself.
//
// Author: Dirk Songuer
// License: GPL v2
// See: http://choosealicense.com/licenses/gpl-v2/
// *************************************************** //

// data structure for errors
function ErrorData()
{
	// general image information and links
	this.errorType = "";
	this.errorCode = "";
	this.errorMessage = "";
}