// *************************************************** //
// Follow Button Component
//
// This component acts as the follow button. It shows the
// current relationship state of the active user and the
// given one. It also provides the state as external
// property.
//
// Author: Dirk Songuer
// License: GPL v2
// See: http://choosealicense.com/licenses/gpl-v2/
// *************************************************** //

// import blackberry components
import bb.cascades 1.2
import bb.system 1.2

// shared js files
import "../global/globals.js" as Globals
import "../global/copytext.js" as Copytext
import "../instagramapi/relationships.js" as RelationshipRepository
import "../classes/authenticationhandler.js" as Authentication

Container {
    id: followButtonComponent

    //signal if user relationship loading is complete
    signal userRelationshipLoaded(variant relationshipData)

    // signal if user relation has been set
    signal userRelationshipSet(string relationship)

    // signal for external sources to press the button
    // programatically
    signal pressButton()

    // the user id and name to handle the relationship with
    // this is set by the calling page
    property string userId
    property string username

    // storage for user relationship after it has been loaded
    property string userRelationship

    // layout orientation
    layout: StackLayout {
        orientation: LayoutOrientation.TopToBottom
    }

    // actual like button component
    CustomButton {
        id: followButton

        // button content
        // iconSource: "asset:///images/icons/icon_like.png"
        narrowText: "Follow"

        // position and layout properties
        alignText: HorizontalAlignment.Center

        // layout definition
        preferredWidth: DisplayInfo.width

        // call logic on button press
        onClicked: {
            followButtonComponent.pressButton();
        }

        // set initial visibility to false
        // this will be changed if the relationship data is loaded
        visible: false
    }

    // the like and comment button
    Container {
        id: allowFollowButtons

        // layout orientation
        layout: StackLayout {
            orientation: LayoutOrientation.LeftToRight
        }

        // set initial visibiity to false
        // will be set once data is loaded
        visible: false

        // layout definition
        topMargin: 1

        CustomButton {
            id: allowFollowConfirm

            // position and layout properties
            layoutProperties: StackLayoutProperties {
                spaceQuota: 1.0
            }

            // layout definition
            rightMargin: 1

            // allow
            narrowText: "Yes"

            // show followers list
            onClicked: {
                RelationshipRepository.setRelationship(followButtonComponent.userId, "approve", followButtonComponent);
                allowFollowButtons.visible = false;
            }
        }

        CustomButton {
            id: allowFollowDeny

            // position and layout properties
            layoutProperties: StackLayoutProperties {
                spaceQuota: 1.0
            }

            // deny
            narrowText: "No"

            // show followers list
            onClicked: {
                RelationshipRepository.setRelationship(followButtonComponent.userId, "ignore", followButtonComponent);
                allowFollowButtons.visible = false;
            }
        }
    }

    // user id is set
    // get the relationship with the given user
    onUserIdChanged: {
        // console.log("# Getting relationship status for user " + followButtonComponent.userId);

        if (Authentication.auth.isAuthenticated()) {
            RelationshipRepository.getRelationship(followButtonComponent.userId, followButtonComponent);
        }
    }

    // relationship loaded
    // extract data and set relationship state accordingly
    onUserRelationshipLoaded: {
        // console.log("# User relationship loaded for user " + followButtonComponent.userId);

        // check if user is not followed and not private
        if ((relationshipData.outgoing_status === "none") && (relationshipData.target_user_is_private === false)) {
            // console.log("# User does not follow ID " + userData.userId + " (public user)");
            followButton.narrowText = Copytext.instagoFollowUser + followButtonComponent.username;
            followButton.backgroundColor = Color.create(Globals.instagoDefaultBackgroundColor);
            followButtonComponent.userRelationship = "none";
        }

        // check if user is already followed
        if (relationshipData.outgoing_status === "follows") {
            // console.log("# User already follows ID " + followButtonComponent.userId);
            followButton.narrowText = Copytext.instagoFollowingUser + followButtonComponent.username;
            followButton.backgroundColor = Color.create(Globals.instagoConfirmedBackgroundColor);
            followButtonComponent.userRelationship = "follows";
        }

        // check if user is not followed and private
        if ((relationshipData.outgoing_status === "none") && (relationshipData.target_user_is_private === true)) {
            // console.log("# User does not follow ID " + userData.userId + " (private user)");
            followButton.narrowText = Copytext.instagoFollowPrivateUser;
            followButton.backgroundColor = Color.create(Globals.instagoDefaultBackgroundColor);
            followButtonComponent.userRelationship = "private";
        }

        // check if user is not followed but requested (only relevant for private users)
        if ((relationshipData.outgoing_status === "requested") && (relationshipData.target_user_is_private === true)) {
            // console.log("# User relationship requested for ID " + userData.userId + " (private user)");
            followButton.narrowText = Copytext.instagoFollowRequested + followButtonComponent.username;
            followButton.backgroundColor = Color.create(Globals.instagoConfirmedBackgroundColor);
            followButtonComponent.userRelationship = "requested";
        }

        // check if user wants to follow the current user (only relevant if current user is private)
        if (relationshipData.incoming_status === "requested_by") {
            // console.log("# User " + userData.userId + " wants to follow current user");
            followButton.narrowText = followButtonComponent.username + Copytext.instagoFollowRequestedBy;
            followButtonComponent.userRelationship = "requested_by";
            allowFollowButtons.visible = true;
        }

        followButton.visible = true;
    }

    // username added
    // show name on button
    onUsernameChanged: {
        followButton.narrowText += followButtonComponent.username;
    }

    onUserRelationshipSet: {
        // approve successfull
        if (relationship == "approve") {
            followButtonToast.body = followButtonComponent.username + Copytext.instagoFollowRequestConfirm;
            followButtonToast.show();
        }

        // ignore successfull
        if (relationship == "ignore") {
            followButtonToast.body = Copytext.instagoFollowRequestIgnore + followButtonComponent.username;
            followButtonToast.show();
        }

        // reload relationship state after update
        RelationshipRepository.getRelationship(followButtonComponent.userId, followButtonComponent);
    }

    // this signal handles the actual logic of adding + removing the like
    onPressButton: {
        // local variable to set new relationship at the end
        // of the method, not in between
        var newRelationship = "";

        // user is not followed and not private, so follow user
        if ((followButtonComponent.userRelationship == "none") || (followButtonComponent.userRelationship == "private")) {
            followButton.narrowText = Copytext.instagoFollowingUser + followButtonComponent.username;
            followButton.backgroundColor = Color.create(Globals.instagoConfirmedBackgroundColor);
            newRelationship = "follows";
            RelationshipRepository.setRelationship(followButtonComponent.userId, "follow", followButtonComponent);
        }

        // user is followed and not private, so unfollow user
        if ((followButtonComponent.userRelationship == "follows") || (followButtonComponent.userRelationship == "requested")) {
            followButton.narrowText = Copytext.instagoFollowUser + followButtonComponent.username;
            followButton.backgroundColor = Color.create(Globals.instagoDefaultBackgroundColor);
            newRelationship = "none";
            RelationshipRepository.setRelationship(followButtonComponent.userId, "unfollow", followButtonComponent);
        }

        // set relationship to global storage
        followButtonComponent.userRelationship = newRelationship;
    }

    // attach components
    attachedObjects: [
        // system toast
        // is used for messages
        SystemToast {
            id: followButtonToast
            position: SystemUiPosition.TopCenter
        }
    ]
}