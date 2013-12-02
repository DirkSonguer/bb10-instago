// *************************************************** //
// User Header Component
//
// This component shows user metadata in a header
// component. It's used for the user detai pages.
// It also handles opening the browser if clicked on
// the user website information.
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
    id: userHeaderComponent

    // property for the use rprofile image
    // given as url
    property alias userimage: userHeaderProfileImage.url

    // property for the user name
    property alias username: userHeaderUsername.text

    // property for the user full name
    property alias userfullname: userHeaderFullName.text

    // property for the user website
    property alias userwebsite: userHeaderWebsite.text

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
        
        // position and layout properties
        verticalAlignment: VerticalAlignment.Center

        // profile image
        // this is a web image view provided by WebViewImage
        WebImageView {
            id: userHeaderProfileImage

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

        // layout orientation
        layout: StackLayout {
            orientation: LayoutOrientation.TopToBottom
        }

        // user name label
        Label {
            id: userHeaderUsername

            // layout definition
            textStyle.base: SystemDefaults.TextStyles.TitleText
            textStyle.fontWeight: FontWeight.W500
            textStyle.textAlign: TextAlign.Left
        }

        // user full name label
        Label {
            id: userHeaderFullName

            // layout definition
            bottomMargin: 0
            textStyle.base: SystemDefaults.TextStyles.BodyText
            textStyle.fontWeight: FontWeight.W100
            textStyle.textAlign: TextAlign.Left
        }

        // user website label
        Label {
            id: userHeaderWebsite

            // layout definition
            topMargin: 0
            textStyle.base: SystemDefaults.TextStyles.BodyText
            textStyle.fontWeight: FontWeight.W100
            textStyle.textAlign: TextAlign.Left

            // set text color as this is a link
            textStyle.color: Color.create(Globals.instagoLinkTextColor)

            // set initial visibility to false
            // make label visible if text is added and change url to link
            visible: false
            onTextChanged: {
                linkInvocation.query.uri = text;
                visible = true;
            }

            // handle tap on url component
            gestureHandlers: [
                TapHandler {
                    onTapped: {
                        linkInvocation.trigger("bb.action.OPEN");
                    }
                }
            ]
        }
    }

    attachedObjects: [
        Invocation {
            id: linkInvocation
            property bool auto_trigger: false
            query {
                onUriChanged: {
                    linkInvocation.query.updateQuery();
                }
            }

            onArmed: {
                // don't auto-trigger on initial setup
                if (auto_trigger) {
                    trigger("bb.action.OPEN");
                }
                
                // allow re-arming to auto-trigger
                auto_trigger = true;
            }
        }
    ]
}