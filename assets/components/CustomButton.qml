// *************************************************** //
// Custom Button Component
//
// This component is a custom button with background,
// bold and narrow text. It also provides tap
// functionality. It's used as base component by other
// specialized buttons (eg. like and comment).
//
// Author: Dirk Songuer
// License: GPL v2
// See: http://choosealicense.com/licenses/gpl-v2/
// *************************************************** //

// import blackberry components
import bb.cascades 1.2
import bb.system 1.2

// shared js files
import "../global/globals.js" as Globals
import "../global/copytext.js" as Copytext
import "../instagramapi/media.js" as MediaRepository
import "../classes/authenticationhandler.js" as Authentication

Container {
    id: customButtonComponent

    // signal that button has been clicked
    signal clicked()

    // appearance properties
    property alias backgroundColor: customButtonComponent.background
    property variant componentBackground

    // content properties
    property alias alignText: customButtonContainer.horizontalAlignment
    property alias iconSource: customButtonIcon.imageSource
    property alias boldText: customButtonBoldLabel.text
    property alias narrowText: customButtonNarrowLabel.text

    // access properties
    property bool authenticationRequired: false
    property string authenticationText: ""

    // layout definition
    topPadding: 30
    bottomPadding: 25
    leftPadding: 10
    rightPadding: 10

    // set initial background color
    // can be changed via the componentBackground property
    background: Color.create(Globals.instagoDefaultBackgroundColor)

    Container {
        id: customButtonContainer

        // layout orientation
        layout: StackLayout {
            orientation: LayoutOrientation.LeftToRight
        }

        // layout definition
        horizontalAlignment: HorizontalAlignment.Center

        // icon for button
        ImageView {
            id: customButtonIcon

            // position and layout properties
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Left

            // set size as it will be shown smaller as the original size
            preferredHeight: 55
            preferredWidth: 55
            minHeight: 55
            minWidth: 55

            // set initial visibility to false
            // make image visible if image source is added
            visible: false
            onImageSourceChanged: {
                visible = true;
            }
        }

        // bold label for button
        Label {
            id: customButtonBoldLabel

            // layout definition
            leftMargin: 0
            rightMargin: 0
            textStyle.base: SystemDefaults.TextStyles.BodyText
            textStyle.fontWeight: FontWeight.W500
            textStyle.textAlign: TextAlign.Left

            // set initial visibility to false
            // make label visible if text is added
            visible: false
            onTextChanged: {
                visible = true;
            }
        }

        // narrow label for button
        Label {
            id: customButtonNarrowLabel

            // layout definition
            leftMargin: 5
            textStyle.base: SystemDefaults.TextStyles.BodyText
            textStyle.fontWeight: FontWeight.W100
            textStyle.textAlign: TextAlign.Left

            // set initial visibility to false
            // make label visible if text is added
            visible: false
            onTextChanged: {
                visible = true;
            }
        }
    }
    
    onCreationCompleted: {
        // set initial background
        componentBackground = customButtonComponent.background;
    }

    // handle ui touch behaviour
    onTouch: {
        // user pressed
        if (event.touchType == TouchType.Down) {
            // cache current color and set highlight
            componentBackground = customButtonComponent.background;
            customButtonComponent.background = Color.create(Globals.instagoHighlightBackgroundColor);
        }

        // user released or is moving
        if ((event.touchType == TouchType.Up) || (event.touchType == TouchType.Cancel)) {
            // set background to cached color
            customButtonComponent.background = componentBackground;
        }
    }

    // handle tap on custom button
    gestureHandlers: [
        TapHandler {
            onTapped: {
                if (customButtonComponent.authenticationRequired) {
                    if (! Authentication.auth.isAuthenticated()) {
                        customButtonToast.body = customButtonComponent.authenticationText;
                        customButtonToast.show();
                    } else {
                        customButtonComponent.clicked();
                    }
                } else {
                    customButtonComponent.clicked();
                }
            }
        }
    ]

    // attach components
    attachedObjects: [
        // system toast
        // is used for messages
        SystemToast {
            id: customButtonToast
            position: SystemUiPosition.TopCenter
        }
    ]
}