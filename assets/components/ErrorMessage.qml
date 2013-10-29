// *************************************************** //
// Error Message Component
//
// The error message component contains a simple message
// with several control mechanism
// *************************************************** //

// import blackberry components
import bb.cascades 1.2

// shared js files
import "../global/globals.js" as Globals
import "../global/copytext.js" as Copytext

Container {
    id: errorMessageComponent

    // shows an error message based on the given data
    // errorData is an object of type ErrorData
    signal showErrorMessage(variant errorData);

    // hide the error message
    signal hideErrorMessage();

    // signal to indicate a tap on the error message
    // this can be used by the using page
    signal errorMessageClicked();

    // layout definition
    layout: StackLayout {
        orientation: LayoutOrientation.TopToBottom
    }

    // error message headline
    Container {
        // layout definition
        leftPadding: 15
        rightPadding: 10

        Label {
            id: errorMessageHeadline

            // layout definition
            textStyle.base: SystemDefaults.TextStyles.BigText

            // add standard headline
            text: Copytext.instagoErrorHeadline

            // hide loader components initially
            visible: false
        }

        // error message text
        Label {
            id: errorMessageText

            // text style definition
            textStyle.fontSize: FontSize.PointValue
            textStyle.fontSizeValue: 10
            textStyle.fontWeight: FontWeight.W100
            textStyle.textAlign: TextAlign.Left
            multiline: true

            // hide loader components initially
            visible: false
        }
    }

    // handle tap on error message
    gestureHandlers: [
        // Add a handler for tap gestures
        TapHandler {
            onTapped: {
                errorMessageComponent.errorMessageClicked();
            }
        }
    ]

    // logic for the showErrorMessage signal
    // this extracts the error data and adds it to the error message fields
    onShowErrorMessage: {
        // make sure only one error message is shown
        // if one is already active, don't show another one
        if (! errorMessageText.visible) {
            // prefix for error message
            errorMessageText.text = Copytext.instagoErrorMessagePrefix;

            // check if there is an error message available
            // if so, show it
            if ((errorData.errorMessage !== undefined) && (errorData.errorMessage.length > 0)) {
                errorMessageText.text += "<br /><br /><i>" + errorData.errorMessage + "</i>";
            }
            
            // postfix for error message
            errorMessageText.text += Copytext.instagoErrorMessagePostfix;

			// set visibility
            errorMessageHeadline.visible = true;
            errorMessageText.visible = true;
        }
    }

    // logic for hiding the error message
    onHideErrorMessage: {
        // hide components
        errorMessageHeadline.visible = false;
        errorMessageText.visible = false1;
    }
}
