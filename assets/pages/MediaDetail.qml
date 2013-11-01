// *************************************************** //
// Image Detail Page
//
// The image detail page is shown when a specific
// Instagram image is displayed.
// The page has a number of features that can be
// applied to the image as well as the user that
// uploaded it.
// *************************************************** //

// import blackberry components
import bb.cascades 1.2

// set import directory for components
import "../components"

// shared js files
import "../global/globals.js" as Globals
import "../global/copytext.js" as Copytext
import "../classes/authenticationhandler.js" as Authentication
import "../instagramapi/media.js" as MediaRepository
import "../instagramapi/users.js" as UserRepository
import "../structures/userdata.js" as InstagramUserData

// import image url loader component
import WebImageView 1.0

Page {
    id: imageDetailPage

    // property containing the image data
    // this is filled by the calling page
    // image data is of type InstagramMediaData()
    property variant mediaData

    // main content container
    Container {
        // layout definition
        layout: DockLayout {
        }

        Container {
            id: mediaDetailContainer

            // set initial visibility to false
            visible: false

            // layout definition
            layout: StackLayout {
                orientation: LayoutOrientation.TopToBottom
            }

            // the actual thumbnail image
            InstagramImageView {
                id: mediaDetailImage

                // position and layout properties
                verticalAlignment: VerticalAlignment.Center
                horizontalAlignment: HorizontalAlignment.Center
            }

            Container {
                layout: StackLayout {
                    orientation: LayoutOrientation.LeftToRight
                }

                background: Color.create(Globals.instagoCoverBackgroundColor)
                preferredWidth: DisplayInfo.width
                topPadding: 20
                bottomPadding: 20
                leftPadding: 30
                rightPadding: 10
                topMargin: 1

                Container {
                    layout: DockLayout {

                    }
                    // gallery image
                    // this is a web image view provided by WebViewImage
                    WebImageView {
                        id: userProfileImage

                        // align the image in the center
                        verticalAlignment: VerticalAlignment.Center
                        horizontalAlignment: HorizontalAlignment.Left

                        // set image size to maximum screen size
                        // this will be either 768x768 (Z10) or 720x720 (all others)
                        preferredHeight: 150
                        preferredWidth: 150
                        minHeight: 150
                        minWidth: 150
                    }

                    // this is set visible if the gallery item is a video
                    ImageView {
                        id: userProfileImageMask

                        // position and layout properties
                        verticalAlignment: VerticalAlignment.Center
                        horizontalAlignment: HorizontalAlignment.Left

                        // set image size to maximum screen size
                        // this will be either 768x768 (Z10) or 720x720 (all others)
                        preferredHeight: 150
                        preferredWidth: 150
                        minHeight: 150
                        minWidth: 150

                        imageSource: "asset:///images/mask_profile_pictures_black.png"
                    }
                }

                Container {
                    leftMargin: 40
                    
                    layout: StackLayout {
                        orientation: LayoutOrientation.TopToBottom
                    }

                    Label {
                        id: userName

                        // layout definition
                        textStyle.base: SystemDefaults.TextStyles.TitleText
                        textStyle.fontWeight: FontWeight.W500
                        textStyle.textAlign: TextAlign.Left
                    }
                    
                    Label {
                        id: imageCaption
                        
                        // layout definition
                        textStyle.base: SystemDefaults.TextStyles.BodyText
                        textStyle.fontWeight: FontWeight.W100
                        textStyle.textAlign: TextAlign.Left
                        multiline: true
                    }
                }
            }
        }

        LoadingIndicator {
            id: loadingIndicator
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Center
        }

        ErrorMessage {
            id: errorMessage
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Center
        }
    }

    // page creation is finished
    // this prepares the general state of the page
    // the page waits for an external page to fill the mediaData property
    onCreationCompleted: {
        // console.log("# Creation of media detail page finished");

        // show loader
        loadingIndicator.showLoader("Loading media data");
    }

    // mediaData property was changed y an external page
    // fill the detail component with the given content
    onMediaDataChanged: {
        // hide loader
        loadingIndicator.hideLoader();

        mediaDetailContainer.visible = true;
        mediaDetailImage.url = mediaData.mediaStandardImage;
        
        userProfileImage.url = mediaData.userData.profilePicture;
        userName.text = mediaData.userData.username;
        imageCaption.text = mediaData.caption;
    }
}
