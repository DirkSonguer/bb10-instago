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

    signal showLoader(string message)
    signal hideLoader();

    // layout definition
    layout: StackLayout {
        orientation: LayoutOrientation.TopToBottom
    }

    // loading indicator
    ActivityIndicator {
        id: loaderActivityIndicator

        // layout definition
        horizontalAlignment: HorizontalAlignment.Center
        minWidth: 200

        // hide loader components initially
        visible: false
    }

    // the actual message text
    Label {
        id: loaderMessage

        // text style definition
        textStyle.fontSize: FontSize.PointValue
        textStyle.fontSizeValue: 14
        textStyle.fontWeight: FontWeight.W100
        textStyle.textAlign: TextAlign.Center
        multiline: true

        // hide loader components initially
        visible: false
    }

    onShowLoader: {
        // activity indicator active on page creation
        loaderActivityIndicator.running = true;
        loaderActivityIndicator.visible = true;

        if (message) {
            loaderMessage.text = message;
            loaderMessage.visible = true;
        }
    }

    onHideLoader: {
        loaderActivityIndicator.running = false;
        loaderActivityIndicator.visible = false;
        loaderMessage.visible = false;
    }
}
