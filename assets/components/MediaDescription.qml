// *************************************************** //
// Media Description Component
//
// This component shows the user profile image name and
// the media caption text
//
// Author: Dirk Songuer
// License: GPL v2
// See: http://choosealicense.com/licenses/gpl-v2/
// *************************************************** //

// import blackberry components
import bb.cascades 1.2

// shared js files
import "../global/globals.js" as Globals
import "../global/copytext.js" as Copytext

// import image url loader component
import WebImageView 1.0

Container {
    id: mediaDescriptionComponent

    // signal that profile has been clicked
    signal profileClicked()

    // signal that description has been clicked
    signal descriptionClicked()

    // signal that a link inside the description has been clicked
    // this can either be a username or a hashtag
    signal descriptionUsernameClicked(string username)
    signal descriptionHashtagClicked(string hashtag)
    
    // property for the user profile image given as url
    property alias userimage: mediaDescriptionProfileImage.url

    // property for the user name
    property alias username: mediaDescriptionUsername.text

    // property for the image caption
    property alias imagecaption: mediaDescriptionCaption.text

    // flag if caption should be shown completely (multiline) or
    // just as one line (false)
    property alias captionMultiline: mediaDescriptionCaption.multiline

    // flag if description should be in confirmed mode
    // this will set a confirmed background color and mask
    property bool confirmed: false

    // layout orientation
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
        // layout orientation
        layout: DockLayout {
        }

        // profile image
        // this is a web image view provided by WebViewImage
        WebImageView {
            id: mediaDescriptionProfileImage

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
            id: mediaDescriptionMask

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

        // handle tap on profile picture
        gestureHandlers: [
            TapHandler {
                onTapped: {
                    // console.log("# User profile clicked");
                    mediaDescriptionComponent.profileClicked();
                }
            }
        ]
    }

    // username and caption container
    Container {
        // layout definition
        leftMargin: 40

        // layout orientation
        layout: StackLayout {
            orientation: LayoutOrientation.TopToBottom
        }

        // user name label
        Label {
            id: mediaDescriptionUsername

            // layout definition
            textStyle.base: SystemDefaults.TextStyles.TitleText
            textStyle.fontWeight: FontWeight.W500
            textStyle.textAlign: TextAlign.Left
        }

        // image caption label
        Label {
            id: mediaDescriptionCaption

            // layout definition
            textStyle.base: SystemDefaults.TextStyles.BodyText
            textStyle.fontWeight: FontWeight.W100
            textStyle.textAlign: TextAlign.Left
            multiline: true

            // this is a handler that tracks active interaction with the label
            // basically this acts as a touch handler for special label content
            activeTextHandler: ActiveTextHandler {
                onTriggered: {
                    // console.log("# Link inside caption was clicked: " + String(event.href));
                    var linkString = new String(event.href);
                    
                    // identify if link was a username or a hashtag
                    // send signal accordingly
                    if (linkString.indexOf("ser:") == 1) {
                        descriptionUsernameClicked(linkString.substring(5));
                    } else {
                        descriptionHashtagClicked(linkString.substring(8));
                    }
                }
            }
        }

        // handle tap on custom button
        gestureHandlers: [
            TapHandler {
                onTapped: {
                    // console.log("# Container clicked");
                    mediaDescriptionComponent.descriptionClicked();
                }
            }
        ]
    }

    // handle ui touch elements
    onTouch: {
        // user pressed description
        if (event.touchType == TouchType.Down) {
            mediaDescriptionComponent.background = Color.create(Globals.instagoHighlightBackgroundColor);
            mediaDescriptionMask.imageSource = "asset:///images/mask_profile_pictures_highlight.png"
        }

        // user release description or is moving
        if ((event.touchType == TouchType.Up) || (event.touchType == TouchType.Cancel)) {
            if (mediaDescriptionComponent.confirmed) {
                mediaDescriptionComponent.background = Color.create(Globals.instagoConfirmedBackgroundColor);
                mediaDescriptionMask.imageSource = "asset:///images/mask_profile_pictures_confirmed.png"
            } else {
                mediaDescriptionComponent.background = Color.create(Globals.instagoDefaultBackgroundColor);
                mediaDescriptionMask.imageSource = "asset:///images/mask_profile_pictures_default.png"
            }
        }
    }

    // change background and mask color according to confirmed state
    onConfirmedChanged: {
        if (mediaDescriptionComponent.confirmed) {
            mediaDescriptionComponent.background = Color.create(Globals.instagoConfirmedBackgroundColor);
            mediaDescriptionMask.imageSource = "asset:///images/mask_profile_pictures_confirmed.png"
        } else {
            mediaDescriptionComponent.background = Color.create(Globals.instagoDefaultBackgroundColor);
            mediaDescriptionMask.imageSource = "asset:///images/mask_profile_pictures_default.png"
        }
    }
}