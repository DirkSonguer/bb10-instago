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
import "../classes/authenticationhandler.js" as Authentication

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
    property alias count: likeButton.boldText

    // layout definition
    layout: StackLayout {
        orientation: LayoutOrientation.LeftToRight
    }

    // actual like button component
    CustomButton {
        id: likeButton

        // button content
        iconSource: "asset:///images/icons/icon_like.png"
        narrowText: "likes"

        // position and layout properties
        alignText: HorizontalAlignment.Left

        // position and layout properties
        layoutProperties: StackLayoutProperties {
            spaceQuota: 1.0
        }

        // call logic on button press
        onClicked: {
            likeButtonComponent.pressButton();
        }
    }

    // user has liked flag changed
    // this can be because the user pressed the button
    // or the using page / component changed it
    onUserHasLikedChanged: {
        if (likeButtonComponent.userHasLiked) {
            // light green color
            likeButton.backgroundColor = Color.create(Globals.instagoConfirmedBackgroundColor);
        } else {
            // standard button color
            likeButton.backgroundColor = Color.create(Globals.instagoCoverBackgroundColor);
        }
    }

    // like has been added
    // check response state
    onLikeAdded: {
        // change button state if like could not be added
        if (requestFeedback != Copytext.instagoAddLikeSuccess) {
            likeButtonComponent.userHasLiked = false;

            // show the message toast
            // this will contain either the error message
            likeButtonToast.body = requestFeedback;
            likeButtonToast.show();
        }
    }

    // like has been removed
    // check response state
    onLikeRemoved: {
        // change button state if like could not be removed
        if (requestFeedback != Copytext.instagoRemoveLikeSuccess) {
            likeButtonComponent.userHasLiked = true;

            // show the message toast
            // this will contain either the error message
            likeButtonToast.body = requestFeedback;
            likeButtonToast.show();
        }
    }

    // this signal handles the actual logic of adding + removing the like
    onPressButton: {
        // on tap just reverse the state of the like flag
        // and call the respective like action if user is
        // authenticated
        if (Authentication.auth.isAuthenticated()) {
            if (! likeButtonComponent.userHasLiked) {
                likeButtonComponent.userHasLiked = true;
                MediaRepository.addLike(likeButtonComponent.mediaId, likeButtonComponent);
            } else {
                likeButtonComponent.userHasLiked = false;
                MediaRepository.removeLike(likeButtonComponent.mediaId, likeButtonComponent);
            }
        } else {
            // user not logged in
            // show message
            likeButtonToast.body = Copytext.instagoLikeNotLoggedIn;
            likeButtonToast.show();
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