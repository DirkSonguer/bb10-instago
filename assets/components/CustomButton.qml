// *************************************************** //
// Custom Button Component
//
// This component is a custom button with background,
// bold and narrow text. It also provides tap
// functionality. It's used as base component by other
// specialized buttons (eg. like and comment).
// *************************************************** //

// import blackberry components
import bb.cascades 1.2
import bb.system 1.2

// shared js files
import "../global/globals.js" as Globals
import "../global/copytext.js" as Copytext
import "../instagramapi/media.js" as MediaRepository

Container {
    id: customButtonComponent

    // signal that button has been clicked
    signal clicked()

    // external properties
    property alias backgroundColor: customButtonComponent.background
    property alias alignText: customButtonContainer.horizontalAlignment
    property alias iconSource: customButtonIcon.imageSource
    property alias boldText: customButtonBoldLabel.text
    property alias narrowText: customButtonNarrowLabel.text
    property variant componentBackground

    // layout definition
    topPadding: 30
    bottomPadding: 25
    leftPadding: 30
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
                customButtonComponent.clicked();
            }
        }
    ]
}