// *************************************************** //
// Instagram Image View Component
//
// This component shows an image based on
// InstagramMediaData objects
// It also handles the grey backgrounds while loading
// as well as the video indicator and touch events
// *************************************************** //

// import blackberry components
import bb.cascades 1.2
import bb.system 1.2

// shared js files
import "../global/globals.js" as Globals
import "../global/copytext.js" as Copytext

// import image url loader component
import WebImageView 1.0

Container {
    id: instagramImageViewComponent

    // signal if a like has been added
    signal imageDoubleClicked()

    // property containing the image url
    property alias url: instagramImage.url
    
    property alias loadProgress: instagramImage.loading

    // property that defines the size of the image
    // this is the device screen width by default
    // so either 768x768 (Z10) or 720x720 (all others)
    property int imageSize: DisplayInfo.width

    // property that defines the type the media
    // item actually has, can be "image" or "video"
    property string mediaType

    // layout orientation
    layout: DockLayout {
    }

    // gallery image
    // this is a web image view provided by WebViewImage
    WebImageView {
        id: instagramImage

        // align the image in the center
        verticalAlignment: VerticalAlignment.Center
        horizontalAlignment: HorizontalAlignment.Center

        // set the image size according to imageSize property
        preferredHeight: instagramImageViewComponent.imageSize
        preferredWidth: instagramImageViewComponent.imageSize
        minHeight: instagramImageViewComponent.imageSize
        minWidth: instagramImageViewComponent.imageSize

        // set initial visibility to false
        visible: false

        // change loader with image if loading is complete
        onLoadingChanged: {
            if (loading == 1.0) {
                instagramImageBackground.visible = false;
                instagramImage.visible = true;

                // show play button if video
                if (instagramImageViewComponent.mediaType == "video") {
                    videoPlayButton.visible = true;
                } else {
                    videoPlayButton.visible = false;
                }
            }
        }

        // handle tap on image
        gestureHandlers: [
            // Add a handler for tap gestures
            DoubleTapHandler {
                onDoubleTapped: {
                    instagramImageViewComponent.imageDoubleClicked();
                }
            }
        ]
    }

    // play button
    // this is set visible if the gallery item is a video
    ImageView {
        id: videoPlayButton

        // position and layout properties
        verticalAlignment: VerticalAlignment.Center
        horizontalAlignment: HorizontalAlignment.Center
        imageSource: "asset:///images/icons/icon_play_white_background.png"
        opacity: 0.5

        // set initial visibility to false
        visible: false
    }

    // standard grey image substitute
    // the component will be set invisible when loading is finished
    Container {
        id: instagramImageBackground

        // position and layout properties
        verticalAlignment: VerticalAlignment.Center
        horizontalAlignment: HorizontalAlignment.Center

        // set the image size according to imageSize property
        preferredHeight: instagramImageViewComponent.imageSize
        preferredWidth: instagramImageViewComponent.imageSize
        minHeight: instagramImageViewComponent.imageSize
        minWidth: instagramImageViewComponent.imageSize

        // background color as defined in shared globals
        background: Color.create(Globals.instagoListItemBackgroundColor)
    }

    // attach components
    attachedObjects: [
        // system toast
        // is used for messages
        SystemToast {
            id: instagramImageViewToast
            position: SystemUiPosition.TopCenter
        }
    ]
}