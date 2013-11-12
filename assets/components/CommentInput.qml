// *************************************************** //
// Comment Input Component
//
// This component provides an input field for the
// comments. It also handles the actual sending of the
// comment data to Instagram.
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
    id: commentInputComponent

    // signal if a comment has been added
    signal commentAdded(string requestFeedback)

    // the media id is needed to add / remove comments
    property string mediaId

    // layout definition
    layout: StackLayout {
        orientation: LayoutOrientation.LeftToRight
    }

    topPadding: 15
    rightPadding: 5
    leftPadding: 5
    bottomPadding: 5

    // set initial visibility to false
    visible: true

    // comment input field
    TextField {
        id: mediaCommentInput

        // configure text field
        hintText: "Add Comment"
        clearButtonVisible: true
        inputMode: TextFieldInputMode.Chat

        // input behaviour and handling
        input {
            submitKey: SubmitKey.Submit
            onSubmitted: {
                if (submitter.text.length > 0) {
                    console.log("# Adding comment: " + submitter.text);
                    // add comment to image
                    MediaRepository.addComment(mediaData.mediaId, submitter.text, commentInputComponent);

                    // clear and hide the comment list, hide the input field and show the loader
                    mediaCommentInput.text = "";
                    commentInputComponent.visible = false
                } else {
                    commentInputComponent.visible = false
                }
            }
        }
    }

    // comment submit button
    ImageButton {
        defaultImageSource: "asset:///images/icons/icon_comments_dimmed.png"
        pressedImageSource: "asset:///images/icons/icon_comments.png"
        onClicked: {
            // send the submit signal to the text input field
            mediaCommentInput.input.submitted(mediaCommentInput);
        }
    }

    // comment has been added
    onCommentAdded: {
        // console.log("# Comment added. Showing confirmation");
        commentInputToast.body = requestFeedback;
        commentInputToast.show();
    }

    // attach components
    attachedObjects: [
        // system toast
        // is used for messages
        SystemToast {
            id: commentInputToast
            position: SystemUiPosition.TopCenter
        }
    ]
}