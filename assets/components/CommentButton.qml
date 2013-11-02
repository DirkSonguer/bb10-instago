// *************************************************** //
// Comment Button Component
//
// This component acts as the comment button. It shows the
// current number of comments as well as provides the
// functionality to comment a media item.
// *************************************************** //

// import blackberry components
import bb.cascades 1.2

// shared js files
import "../global/globals.js" as Globals
import "../global/copytext.js" as Copytext
import "../instagramapi/media.js" as MediaRepository

Container {
    id: likeButtonComponent

    // signal if a comment has been added
    signal commentAdded(string requestFeedback)

    // the media id is needed to add / remove comments
    property string mediaId

    // number of comments the media item has
    property alias count: commentButtonCount.text

    // layout definition
    layout: StackLayout {
        orientation: LayoutOrientation.LeftToRight
    }

    // layout definition
    topPadding: 30
    bottomPadding: 25
    leftPadding: 30
    rightPadding: 10

    // set initial background color
    background: Color.create(Globals.instagoCoverBackgroundColor)

    // comment icon
    ImageView {
        id: commentButtonIcon

        // position and layout properties
        verticalAlignment: VerticalAlignment.Center
        horizontalAlignment: HorizontalAlignment.Left

        // set size as it will be shown smaller as the original size
        preferredHeight: 55
        preferredWidth: 55
        minHeight: 55
        minWidth: 55

        // icon file
        imageSource: "asset:///images/icons/icon_comments.png"
    }

    // number of comments
    Label {
        id: commentButtonCount

        // layout definition
        leftMargin: 0
        rightMargin: 0
        textStyle.base: SystemDefaults.TextStyles.BodyText
        textStyle.fontWeight: FontWeight.W500
        textStyle.textAlign: TextAlign.Left
    }
    
    // number of comments
    Label {
        id: commentButtonLabel
        
        // button label
        text: "comments"

        // layout definition
        leftMargin: 5
        textStyle.base: SystemDefaults.TextStyles.BodyText
        textStyle.fontWeight: FontWeight.W100
        textStyle.textAlign: TextAlign.Left
    }
    // handle tap on comment component
    gestureHandlers: [
        // Add a handler for tap gestures
        TapHandler {
            onTapped: {
                // on tap just reverse the state of the comment flag
            }
        }
    ]
}