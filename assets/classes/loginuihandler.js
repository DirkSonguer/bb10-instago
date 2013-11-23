// *************************************************** //
// Login UI Handler Script
//
// This script handles the UI changes when a login or
// logout process (sucessfully) happened.
// *************************************************** //

// include other scripts used here
if (typeof dirPaths !== "undefined") {
	// Qt.include(dirPaths.assetPath + "global/instagramkeys.js");
}

// singleton instance of class
var loginUIHandler = new LoginUIHandler();

// class function that gets the prototype methods
function LoginUIHandler() {
}

// Set the UI to logged in state
LoginUIHandler.prototype.setLoggedInState = function() {
	console.log("# Changing UI to logged in state");

	// changing available menu items
	// first we remove all available items
	// afterwards we add them again in the right order
	mainMenu.removeAction(mainMenuLogout);
	mainMenu.removeAction(mainMenuAbout);
	mainMenu.removeAction(mainMenuRate);
	mainMenu.removeAction(mainMenuNews);
	mainMenu.addAction(mainMenuLogout);
	mainMenu.addAction(mainMenuAbout);
	mainMenu.addAction(mainMenuRate);
	mainMenu.addAction(mainMenuNews);

	// changing available tabs
	// first we remove all available items
	// afterwards we add them again in the right order
	mainTabbedPane.remove(personalFeedTab);
	mainTabbedPane.remove(popularMediaTab);
	mainTabbedPane.remove(searchTab);
	mainTabbedPane.remove(profileTab);
	mainTabbedPane.add(personalFeedTab);
	mainTabbedPane.add(popularMediaTab);
	mainTabbedPane.add(searchTab);
	mainTabbedPane.add(profileTab);
	mainTabbedPane.activeTab = popularMediaTab;
};

// Set the UI to logged out state
LoginUIHandler.prototype.setLoggedOutState = function() {
	console.log("# Changing UI to logged out state");

	// changing available menu items
	// first we remove all available items
	// afterwards we add them again in the right order
	mainMenu.removeAction(mainMenuLogout);
	mainMenu.removeAction(mainMenuAbout);
	mainMenu.removeAction(mainMenuRate);
	mainMenu.removeAction(mainMenuNews);
	mainMenu.addAction(mainMenuAbout);
	mainMenu.addAction(mainMenuRate);
	mainMenu.addAction(mainMenuNews);

	// changing available tabs
	// first we remove all available items
	// afterwards we add them again in the right order
	mainTabbedPane.remove(personalFeedTab);
	mainTabbedPane.remove(popularMediaTab);
	mainTabbedPane.remove(searchTab);
	mainTabbedPane.remove(profileTab);
	mainTabbedPane.add(popularMediaTab);
	mainTabbedPane.add(profileTab);
	mainTabbedPane.activeTab = popularMediaTab;
};
