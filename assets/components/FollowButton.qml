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

    // layout definition
    layout: StackLayout {
        orientation: LayoutOrientation.LeftToRight
    }

    // actual like button component
    CustomButton {
        id: followButton

        // button content
        // iconSource: "asset:///images/icons/icon_like.png"
        narrowText: "Follow"

        // position and layout properties
        alignText: HorizontalAlignment.Center

        // position and layout properties
        layoutProperties: StackLayoutProperties {
            spaceQuota: 1.0
        }

        // call logic on button press
        onClicked: {
            followButtonComponent.pressButton();
        }

        // set initial visibility to false
        // this will be changed if the relationship data is loaded
        visible: false
    }

    // user id is set
    // get the relationship with the given user
    onUserIdChanged: {
        if (Authentication.auth.isAuthenticated()) {
            RelationshipRepository.getRelationship(followButtonComponent.userId, followButtonComponent);
        }
    }

    onUserRelationshipLoaded: {
        // console.log("# User relationship loaded for user " + followButtonComponent.userId);

        // check if user is not followed and not private
        if ((relationshipData.outgoing_status === "none") && (relationshipData.target_user_is_private === false)) {
            // console.log("# User does not follow ID " + userData.userId + " (public user)");
            followButton.narrowText = Copytext.instagoFollowUser + followButtonComponent.username;
            followButton.backgroundColor = Color.create(Globals.instagoCoverBackgroundColor);
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
            followButton.backgroundColor = Color.create(Globals.instagoCoverBackgroundColor);
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
            // TODO: Show follow request confirmation option
            followButton.narrowText = followButtonComponent.username + Copytext.instagoFollowRequestedBy;
            followButtonComponent.userRelationship = "requested_by";
        }

        followButton.visible = true;
    }

    onUserRelationshipSet: {
        // approve successfull
        //        if (relationship == "approve") {

        // ignore successfull
        //        if (relationship == "ignore") {

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
            followButton.backgroundColor = Color.create(Globals.instagoCoverBackgroundColor);
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