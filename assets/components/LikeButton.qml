// *************************************************** //
// Like Button Component
//
// This component acts as the like button. It shows the
// current number of likes as well as provides the
// functionality to like / unlike a media item.
// *************************************************** //

// import blackberry components
import bb.cascades 1.2
import bb.system 1.2

// shared js files
import "../global/globals.js" as Globals
import "../global/copytext.js" as Copytext
import "../instagramapi/media.js" as MediaRepository

Container {
    id: likeButtonComponent

    // signal if a like has been added
    signal likeAdded(string requestFeedback)

    // signal if a like has been removed
    signal likeRemoved(string requestFeedback)

    // signal for external sources to press the button
    // programatically
    signal pressButton()

    // flag to indicate if user has liked the media item
    // this can be set from either inside this component
    // or from outside pages / components
    property bool userHasLiked: false

    // the media id is needed to add / remove likes
    property string mediaId

    // number of likes the media item has
    property alias count: likeButtonCount.text

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

    // like icon
    ImageView {
        id: likeButtonIcon

        // position and layout properties
        verticalAlignment: VerticalAlignment.Center
        horizontalAlignment: HorizontalAlignment.Left

        // set size as it will be shown smaller as the original size
        preferredHeight: 55
        preferredWidth: 55
        minHeight: 55
        minWidth: 55

        // icon file
        imageSource: "asset:///images/icons/icon_like.png"
    }

    // number of likes
    Label {
        id: likeButtonCount

        // layout definition
        leftMargin: 0
        rightMargin: 0
        textStyle.base: SystemDefaults.TextStyles.BodyText
        textStyle.fontWeight: FontWeight.W500
        textStyle.textAlign: TextAlign.Left
    }

    // number of likes
    Label {
        id: likeButtonLabel

        // button label
        text: "likes"

        // layout definition
        leftMargin: 5
        textStyle.base: SystemDefaults.TextStyles.BodyText
        textStyle.fontWeight: FontWeight.W100
        textStyle.textAlign: TextAlign.Left
    }

    // handle tap on like component
    gestureHandlers: [
        TapHandler {
            id: likeButtonTapHandler

            onTapped: {
                likeButtonComponent.pressButton();
            }
        }
    ]

    // user has liked flag changed
    // this can be because the user pressed the button
    // or the using page / component changed it
    onUserHasLikedChanged: {
        if (likeButtonComponent.userHasLiked) {
            // light green color
            likeButtonComponent.background = Color.create(Globals.instagoConfirmedBackgroundColor);
        } else {
            // standard button color
            likeButtonComponent.background = Color.create(Globals.instagoCoverBackgroundColor);
        }
    }

    // like has been added
    // check response state and show toast
    onLikeAdded: {
        // change button state if like has been sucessfully added
        if (requestFeedback != Copytext.instagoAddLikeSuccess) {
            likeButtonComponent.userHasLiked = false;
        }

        // show the message toast
        // this will contain either the success or error message
        likeButtonToast.body = requestFeedback;
        likeButtonToast.show();
    }

    // like has been removed
    // check response state and show toast
    onLikeRemoved: {
        if (requestFeedback != Copytext.instagoRemoveLikeSuccess) {
            likeButtonComponent.userHasLiked = true;
        }

        // show the message toast
        // this will contain either the success or error message
        likeButtonToast.body = requestFeedback;
        likeButtonToast.show();
    }

    // this signal handles the actual logic of adding + removing the like
    onPressButton: {
        // on tap just reverse the state of the like flag
        // and call the respective like action
        if (! likeButtonComponent.userHasLiked) {
            likeButtonComponent.userHasLiked = true;
            MediaRepository.addLike(likeButtonComponent.mediaId, likeButtonComponent);
        } else {
            likeButtonComponent.userHasLiked = false;
            MediaRepository.removeLike(likeButtonComponent.mediaId, likeButtonComponent);
        }
    }

    // attach components
    attachedObjects: [
        // system toast
        // is used for messages
        SystemToast {
            id: likeButtonToast
            position: SystemUiPosition.TopCenter
        }
    ]
}