// *************************************************** //
// Loader and Message Component
//
// This component shows the loader and / or a respective
// message
// *************************************************** //

// import blackberry components
import bb.cascades 1.2

// shared js files
import "../global/globals.js" as Globals
import "../global/copytext.js" as Copytext

Container {
    id: loadingIndicatorComponent

    // show the loader with the given message
    signal showLoader(string message)

    // hide the loader and message
    signal hideLoader()

    // flag to show if the loader is currently active
    property alias loaderActive: loadingActivityIndicator.visible

    // layout orientation
    layout: StackLayout {
        orientation: LayoutOrientation.TopToBottom
    }

    // loading indicator
    ActivityIndicator {
        id: loadingActivityIndicator

        // layout definition
        horizontalAlignment: HorizontalAlignment.Center
        minWidth: 200

        // hide loader components initially
        visible: false
    }

    // the actual message text
    Label {
        id: loadingMessage

        // text style definition
        textStyle.fontSize: FontSize.PointValue
        textStyle.fontSizeValue: 14
        textStyle.fontWeight: FontWeight.W100
        textStyle.textAlign: TextAlign.Center
        multiline: true

        // hide loader components initially
        visible: false
    }

    // show the loader with the given message
    onShowLoader: {
        // activity indicator active on page creation
        loadingActivityIndicator.running = true;
        loadingActivityIndicator.visible = true;

        // only show message component if a message was given
        if (message) {
            loadingMessage.text = message;
            loadingMessage.visible = true;
        }
    }

    // hide loader and message
    onHideLoader: {
        loadingActivityIndicator.running = false;
        loadingActivityIndicator.visible = false;
        loadingMessage.visible = false;
    }
}