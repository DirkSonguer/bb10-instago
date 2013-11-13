// *************************************************** //
// Image Description Component
//
// This component shows the user profile image name and
// the image caption text
// *************************************************** //

// import blackberry components
import bb.cascades 1.2

// shared js files
import "../global/globals.js" as Globals
import "../global/copytext.js" as Copytext

// import image url loader component
import WebImageView 1.0

Container {
    id: imageDescriptionComponent

    // signal that description has been clicked
    signal clicked()

    // property for the use rprofile image
    // given as url
    property alias userimage: imageDescriptionProfileImage.url

    // property for the user name
    property alias username: imageDescriptionUsername.text

    // property for the image caption
    property alias imagecaption: imageDescriptionCaption.text

    property alias captionMultiline: imageDescriptionCaption.multiline

    // layout definition
    layout: StackLayout {
        orientation: LayoutOrientation.LeftToRight
    }

    // layout definition
    topPadding: 20
    bottomPadding: 20
    leftPadding: 30
    rightPadding: 10

    // set background color
    background: Color.create(Globals.instagoDefaultBackgroundColor)

    // standard width is full display width
    preferredWidth: DisplayInfo.width

    // profile image container
    Container {
        // layout definition
        layout: DockLayout {
        }

        // profile image
        // this is a web image view provided by WebViewImage
        WebImageView {
            id: imageDescriptionProfileImage

            // align the image in the center
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Left

            // set image size to maximum profile picture size
            preferredHeight: 150
            preferredWidth: 150
            minHeight: 150
            minWidth: 150
        }

        // mask the profile image to make it round
        ImageView {
            id: imageDescriptionMask

            // position and layout properties
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Left

            // set image size to maximum profile picture size
            preferredHeight: 150
            preferredWidth: 150
            minHeight: 150
            minWidth: 150

            imageSource: "asset:///images/mask_profile_pictures_default.png"
        }
    }

    // username and caption container
    Container {
        // layout definition
        leftMargin: 40

        // layout definition
        layout: StackLayout {
            orientation: LayoutOrientation.TopToBottom
        }

        // user name label
        Label {
            id: imageDescriptionUsername

            // layout definition
            textStyle.base: SystemDefaults.TextStyles.TitleText
            textStyle.fontWeight: FontWeight.W500
            textStyle.textAlign: TextAlign.Left
        }

        // image caption label
        Label {
            id: imageDescriptionCaption

            // layout definition
            textStyle.base: SystemDefaults.TextStyles.BodyText
            textStyle.fontWeight: FontWeight.W100
            textStyle.textAlign: TextAlign.Left
            multiline: true
        }
    }

    // handle ui touch elements
    onTouch: {
        // user pressed description
        if (event.touchType == TouchType.Down) {
            imageDescriptionComponent.background = Color.create(Globals.instagoHighlightBackgroundColor);
            imageDescriptionMask.imageSource = "asset:///images/mask_profile_pictures_highlight.png"
        }

        // user release description or is moving
        if ((event.touchType == TouchType.Up) || (event.touchType == TouchType.Cancel)) {
            imageDescriptionComponent.background = Color.create(Globals.instagoDefaultBackgroundColor);
            imageDescriptionMask.imageSource = "asset:///images/mask_profile_pictures_default.png"
        }
    }

    // handle tap on custom button
    gestureHandlers: [
        TapHandler {
            onTapped: {
                imageDescriptionComponent.clicked();
            }
        }
    ]
}