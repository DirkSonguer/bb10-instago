// *************************************************** //
// Networkhandler Class
//
// This class handles most of the work needed to
// convert the http response into a usable object.
// This also includes the clean handling of errors
// or problems that can occur.
// *************************************************** //

// include other scripts used here
Qt.include("../structures/errordata.js");

// singleton instance of class
var network = new NetworkHandler();

// Class function that gets the prototype methods
// This also includes the standard objects available
function NetworkHandler() {
	// object to store error data in
	this.errorData = new ErrorData();

	// flag to indicate that loading is finished
	this.requestIsFinished = false;
}

// This method handles http responses for a XMLHttpRequest
// Note that it's meant to be called on every onreadystatechange()
// The responseText is analysed for errors and evaluated into a json object,
// which is returned
NetworkHandler.prototype.handleHttpResult = function(XMLHttpRequestObject) {
	// console.log("# Handling HTTP Result for ready state: " +
	// XMLHttpRequestObject.readyState);

	// check the server response for errors
	// this is done during loading as the XMLHttpRequest implementation in MeeGo
	// Harmattan deletes errors once it's DONE
	// see here for details:
	// https://bugreports.qt-project.org/browse/QTBUG-21706
	if (XMLHttpRequestObject.readyState === XMLHttpRequest.LOADING) {
		this.checkResponseForErrors(XMLHttpRequestObject.responseText);
		return false;
	}

	// check if the server response is actually finished
	if (XMLHttpRequestObject.readyState === XMLHttpRequest.DONE) {
		// console.debug("# Request is done (state " + XMLHttpRequestObject.status + ")");
		this.requestIsFinished = true;

		// check if the status is not 200 (= an error has occured)
		// this might either be already caught during loading or may be
		// something new
		if (XMLHttpRequestObject.status != 200) {
			// as noted on MeeGo / Harmattan the error has already been handled
			// if not, then do it again
			if (!this.errorData.errorCode) {
				// console.log("# The HTTP status is not 200. Check for errors
				// and return");
				this.checkResponseForErrors(XMLHttpRequestObject.responseText);
			}
			return false;
		}

		// try to convert the content to a json object
		// if this works return the object
		// note that on bb.cascades eval() will throw a syntax error and halt JS
		// execution, thus use try/catch to continue
		var jsonObject = "";
		try {
			jsonObject = eval('(' + XMLHttpRequestObject.responseText + ')');
		} catch (err) {
			// console.log("# Error: Response is not a JSON object");
			this.errorData.errorType = "JsonEvaluationError";
			this.errorData.errorCode = "0";
			this.errorData.errorMessage = "Response is not a valid JSON object";
			return false;
		}

		// check if there is a json object available
		if (jsonObject != "") {
			// console.log("# JSON object evaluated");
			return jsonObject;
		}

		// fill the error data object with a generic error description
		// console.log("# Error: Response could not be evaulated");
		this.errorData.errorType = "Generic Network Error";
		this.errorData.errorCode = "0";
		this.errorData.errorMessage = "A generic network error occured";
		return false;
	}
};

// This script analyses the traffic from Instagram for possible errors
// Note that this scripts does the analysing but does not act upon found errors
NetworkHandler.prototype.checkResponseForErrors = function(httpResponseText) {
	// console.log("Check HTTP response for errors");

	// check for general network error
	// in this case the httpResponseText would be empty
	// in that case fill the error data object with a generic error description
	if (httpResponseText === "") {
		// console.log("# Empty response, adding generic error");
		this.errorData.errorType = "Generic Network Error";
		this.errorData.errorCode = "0";
		this.errorData.errorMessage = "A generic network error occured";
		return;
	}

	// every response from the Instagram API server contains a "meta" node
	// every meta node containss a node "code" that has the http response code
	// as content
	// thus if the response does not contain the status code 200 it's an error
	// (may be a different error code or empty)
	if ((httpResponseText.indexOf('"code":200') === -1) && (httpResponseText.indexOf('"code":') > 1)) {
		// console.log("# Response does not have response 200 verification by
		// Instagram");

		// eval the response text to check the content
		var jsonObject = eval('(' + httpResponseText + ')');
		if (jsonObject.error == null) {
			// console.log("# JSON evaluation successful");

			// the error was handled and described by Instagram
			// fill the error data object with the Instagram error description
			this.errorData.errorType = jsonObject.meta.error_type;
			this.errorData.errorCode = jsonObject.meta.code;
			this.errorData.errorMessage = jsonObject.meta.error_message;

			if (this.errorData.errorType === "OAuthAccessTokenException") {
				// TODO: Add ForcedLogoutPage
				// pageStack.push(Qt.resolvedUrl("ForcedLogoutPage.qml"));
				return;
			}
		} else {
			// console.log("# JSON evaluation not successful, adding generic
			// error");

			// the error was not handled by Instagram
			// fill the error data object with a generic error description
			this.errorData.errorType = "Generic Network Error";
			this.errorData.errorCode = "0";
			errorDataError.errorMessage = "A generic network error occured";
		}
	}
};

// This method clears any error messages that are currently stored in the object
// It should be called after the error messages have been processed and shown
NetworkHandler.prototype.clearErrors = function() {
	this.errorData = new ErrorData();
};
