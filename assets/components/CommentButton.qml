// *************************************************** //
// Comment Button Component
//
// This component acts as the comment button. It shows the
// current number of comments as well as provides the
// functionality to comment a media item.
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
    id: commentButtonComponent

    // signal for external sources to press the button
    // programatically
    signal pressButton()

    // signal that button has been clicked
    signal clicked()
    
    // number of comments the media item has
    property alias count: commentButton.boldText
    
    // flag that holds activity status
    property bool active: false

    // layout definition
    layout: StackLayout {
        orientation: LayoutOrientation.LeftToRight
    }
    
    // actual comment button component
    CustomButton {
        id: commentButton

        // button content
        iconSource: "asset:///images/icons/icon_comments.png"
        narrowText: "comments"

        // position and layout properties
        alignText: HorizontalAlignment.Left

        // position and layout properties
        layoutProperties: StackLayoutProperties {
            spaceQuota: 1.0
        }

        // call logic on button press
        onClicked: {
            commentButtonComponent.pressButton();
        }
    }

    // this signal opens the comment logic
    onPressButton: {
        if (Authentication.auth.isAuthenticated()) {
            commentButtonComponent.clicked();            
        } else {
            // show login message toast
            commentButtonToast.body = Copytext.instagoCommentNotLoggedIn;
            commentButtonToast.show();
        }
    }
    
    onActiveChanged: {
        if (commentButtonComponent.active) {
            // light green color
            commentButton.backgroundColor = Color.create(Globals.instagoConfirmedBackgroundColor);
        } else {
            // standard button color
            commentButton.backgroundColor = Color.create(Globals.instagoCoverBackgroundColor);
        }                        
        
    }

    // attach components
    attachedObjects: [
        // system toast
        // is used for messages
        SystemToast {
            id: commentButtonToast
            position: SystemUiPosition.TopCenter
        }
    ]
}