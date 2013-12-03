// *************************************************** //
// Configurationhandler Script
//
// This script handles the configuration management for
// the application.
// The general configuration data will be stored in the
// local app database (table: configurationdata).
// Note that it's a class that needs to be defined first:
// auth = new ConfigurationHandler();
//
// Author: Dirk Songuer
// License: GPL v2
// See: http://choosealicense.com/licenses/gpl-v2/
// *************************************************** //

// include other scripts used here
if (typeof dirPaths !== "undefined") {
	Qt.include(dirPaths.assetPath + "global/instagramkeys.js");
}

// singleton instance of class
var conf = new ConfigurationHandler();

// class function that gets the prototype methods
function ConfigurationHandler() {
}

// This reads out the current configuration
// It can either be the configuration array if successful
// or it can contain an error with respective message
ConfigurationHandler.prototype.getConfiguration = function(configurationKey) {
	// console.log("# Getting configuration);

	var configurationData = new Array();
	var db = openDatabaseSync("Instago", "1.0", "Instago persistent data storage", 1);

	db.transaction(function(tx) {
		tx.executeSql('CREATE TABLE IF NOT EXISTS configurationdata(key TEXT, value TEXT)');
	});

	var dataStr = "SELECT * FROM configurationdata WHERE key = ?";
	var data = [ configurationKey ];
	db.transaction(function(tx) {
		var rs = tx.executeSql(dataStr, data);
		if (rs.rows.length > 0) {
			configurationData = rs.rows.item(0);
		}
	});

	return configurationData;
};

// This stores the given configuration
// It can either be the configuration array if successful
// or it can contain an error with respective message
ConfigurationHandler.prototype.setConfiguration = function(configurationKey, configurationValue) {
	// console.log("# Storing configuration);

	var db = openDatabaseSync("Instago", "1.0", "Instago persistent data storage", 1);
	db.transaction(function(tx) {
		tx.executeSql('CREATE TABLE IF NOT EXISTS configurationdata(key TEXT, value TEXT)');
	});

	var dataStr = "INSERT INTO configurationdata VALUES(?, ?)";
	var data = [ configurationKey, configurationValue ];
	db.transaction(function(tx) {
		tx.executeSql(dataStr, data);
	});

	return true;
};

// Resets the current configuration to empty values
ConfigurationHandler.prototype.resetConfiguration = function() {
	var db = openDatabaseSync("Instago", "1.0", "Instago persistent data storage", 1);

	db.transaction(function(tx) {
		tx.executeSql('DROP TABLE configurationdata');
	});

	return true;
};
