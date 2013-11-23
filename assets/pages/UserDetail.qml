// *************************************************** //
// User Detail Page
//
// The user detail page shows the detail user information
// about a given user.
// Note that is only the detail page, not the profile page
// of the currently logged in user
// *************************************************** //

// import blackberry components
import bb.cascades 1.2
import bb.system 1.2

// set import directory for components
import "../components"

// shared js files
import "../global/globals.js" as Globals
import "../global/copytext.js" as Copytext
import "../instagramapi/users.js" as UserRepository
import "../classes/authenticationhandler.js" as Authentication

// import image url loader component
import WebImageView 1.0

Page {
    id: userDetailPage

    // signal if user profile data loading is complete
    signal userDetailDataLoaded(variant userData)

    // signal if user profile data loading encountered an error
    signal userDetailDataError(variant errorData)

    // signal if user media data loading is complete
    signal userMediaDataLoaded(variant mediaDataArray, string paginationId)

    // signal if user media data loading encountered an error
    signal userMediaDataError(variant errorData)

    // property that holds the user data to load
    // this is filled by the calling page
    // contains only a limited object when filled
    // will be extended once the full data is loaded
    property variant userData

    // content container
    Container {
        // layout orientation
        layout: DockLayout {
        }

        // make the whole content container scrollables
        ScrollView {
            id: loginInstagramWebViewScrollContainer
            scrollViewProperties {
                scrollMode: ScrollMode.Vertical
                pinchToZoomEnabled: false
            }

            Container {
                id: userDetailContainer

                // layout orientation
                layout: StackLayout {
                    orientation: LayoutOrientation.TopToBottom
                }

                // set initial visibility to false
                visible: false

                UserHeader {
                    id: userDetailHeader
                }

                FollowButton {
                    id: userDetailFollowButton

                    // layout definition
                    topMargin: 1

                    // check relationship status
                    onUserRelationshipChanged: {
                        // console.log("# Relationship is " + userRelationship);

                        if ((userRelationship == "private") || (userRelationship == "requested")) {
                            // hide loader and show content
                            loadingIndicator.hideLoader();
                            userDetailContainer.visible = true;
                            userDetailUserPrivateIcon.visible = true;

                            // fill in blank data
                            userDetailHeader.userimage = userDetailPage.userData.profilePicture;
                            userDetailHeader.username = "@" + userDetailPage.userData.username;
                            userDetailHeader.userfullname = "User is private";
                        }
                    }
                }

                // the like and comment button
                Container {
                    id: userDetailFollowerAndFollowingCount

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
                        id: userDetailFollowersCount

                        // position and layout properties
                        layoutProperties: StackLayoutProperties {
                            spaceQuota: 1.0
                        }

                        // layout definition
                        rightMargin: 1

                        // set authentication rules
                        authenticationRequired: true
                        authenticationText: Copytext.instagoFollowersNotLoggedIn

                        // show followers list
                        onClicked: {
                            var userFollowersPage = userFollowersComponent.createObject();
                            userFollowersPage.userData = userData;
                            navigationPane.push(userFollowersPage);
                        }
                    }

                    CustomButton {
                        id: userDetailFollowingCount

                        // position and layout properties
                        layoutProperties: StackLayoutProperties {
                            spaceQuota: 1.0
                        }

                        // set authentication rules
                        authenticationRequired: true
                        authenticationText: Copytext.instagoFollowersNotLoggedIn

                        // show followers list
                        onClicked: {
                            var userFollowingPage = userFollowingComponent.createObject();
                            userFollowingPage.userData = userData;
                            navigationPane.push(userFollowingPage);
                        }
                    }
                }

                MediaThumbnailGallery {
                    id: userDetailMediaThumbnails

                    // gallery sorted by index
                    listSortingKey: "currentIndex"
                    listSortAscending: true

                    // set initial visibility to false
                    visible: false

                    // calculate the actual height of the thumbnail gallery
                    preferredHeight: Math.ceil(currentItemIndex / 2) * (Math.round(DisplayInfo.width / 2))

                    onItemClicked: {
                        // console.log("# Item clicked: " + mediaData.mediaId);
                        var detailImagePage = detailImageComponent.createObject();
                        detailImagePage.mediaData = mediaData;
                        navigationPane.push(detailImagePage);
                    }
                }

                // due to Q series size the info message has to be located below the header
                Container {
                    // layout orientation
                    layout: DockLayout {
                    }
                    
                    verticalAlignment: VerticalAlignment.Fill
                    
                    InfoMessage {
                        id: infoMessage
                        verticalAlignment: VerticalAlignment.Center
                        horizontalAlignment: HorizontalAlignment.Center
                    }
                }
            }

            // check if list scrolled to bottom and load more images if available
            // as the scolling is done by the page scrollview container
            // the listview scroll indicators can't be used
            onViewableAreaChanged: {
                // calculate current view port and component height
                var userMediaListHeight = Math.ceil(userDetailMediaThumbnails.currentItemIndex / 2) * (Math.round(DisplayInfo.width / 2));
                var currentVisibleArea = viewableArea.height + viewableArea.y;

                // check if view port is at the bottom of the component height
                if (currentVisibleArea > userMediaListHeight) {
                    // console.log("# List bottom reached");

                    // check if there is another page available
                    // if so, load the data
                    if ((userDetailMediaThumbnails.paginationNextMaxId != "") && (userDetailMediaThumbnails.paginationNextMaxId != 0)) {
                        // console.log("# List bottom reached. Next pagination id is " + userDetailMediaThumbnails.paginationNextMaxId);
                        UserRepository.getUserMedia(userDetailPage.userData.userId, userDetailMediaThumbnails.paginationNextMaxId, userDetailPage);
                        userDetailMediaThumbnails.paginationNextMaxId = 0;

                        // show toast that new images are loading
                        instagoTopToast.body = "Loading more images..";
                        instagoTopToast.show();
                    }
                }
            }
        }

        // icon if user is private
        ImageView {
            id: userDetailUserPrivateIcon

            // position and layout properties
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Center

            // set initial visibility to false
            // will be set true if user is private
            visible: false

            imageSource: "asset:///images/icons/icon_lock_dimmed.png"
        }

        LoadingIndicator {
            id: loadingIndicator
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Center
        }
    }

    onUserDataChanged: {
        // show loader
        loadingIndicator.showLoader("Loading user data");

        // console.log("# Loading current user data for user " + userDetailPage.userData.userId);
        UserRepository.getUserProfile(userDetailPage.userData.userId, userDetailPage);

        // only load media data if user is logged in
        if (Authentication.auth.isAuthenticated()) {
            UserRepository.getUserMedia(userDetailPage.userData.userId, 0, userDetailPage);
        } else {
            console.log("# Showing message");
            infoMessage.showMessage(Copytext.instagoUserDetailNotLoggedIn, "User Media");
        }

        // setting user id to buttons
        userDetailFollowButton.userId = userDetailPage.userData.userId;
    }

    // user profile data loaded and transformed
    // data is stored in "userData" variant of type InstagramUserData
    onUserDetailDataLoaded: {
        // console.log("# User detail data loaded for user " + userData.username);

        // update page userData object with full data
        userDetailPage.userData = userData;

        // hide loader and show content
        loadingIndicator.hideLoader();
        userDetailContainer.visible = true;

        // user metadata (profile picture, full and user name)
        userDetailHeader.userimage = userData.profilePicture;
        userDetailHeader.username = "@" + userData.username;
        userDetailHeader.userfullname = userData.fullName;
        userDetailHeader.userwebsite = userData.website;

        // followers and following count
        userDetailFollowerAndFollowingCount.visible = true;
        userDetailFollowersCount.boldText = userData.numberOfFollowers;
        userDetailFollowersCount.narrowText = "followers";
        userDetailFollowingCount.boldText = userData.numberOfFollows;
        userDetailFollowingCount.narrowText = "following";

        // add username to follow button
        userDetailFollowButton.username = userData.username;
    }

    // user profile data could not be loaded or transformed
    // show error message
    onUserDetailDataError: {
        // console.log("# User detail data could not be loaded. Error: " + errorData.errorMessage);

        // show error message
        loadingIndicator.showLoader(errorData.errorMessage, "Error " + errorData.errorCode);
    }

    // user media data loaded and transformed
    // data is stored in "mediaDataArray" variant as array of type InstagramMediaData
    onUserMediaDataLoaded: {
        // console.log("# User media data loaded. Found " + mediaDataArray.length + " items");

        // check if the result pagination id is another one than we already have
        if (userDetailMediaThumbnails.paginationNextMaxId != paginationId) {
            // set new pagination id to component
            userDetailMediaThumbnails.paginationNextMaxId = paginationId;

            // iterate through data objects
            for (var index in mediaDataArray) {
                // add each object to the gallery list data model
                // console.log("# Adding item to list with ID: " + mediaDataArray[index].mediaId);
                userDetailMediaThumbnails.addToGallery(mediaDataArray[index]);
            }

            // show gallery component
            userDetailMediaThumbnails.visible = true;
        }
    }

    // attach components
    attachedObjects: [
        // detail image page
        // will be called if user clicks on image gallery item
        ComponentDefinition {
            id: detailImageComponent
            source: "MediaDetail.qml"
        },
        // follower list page
        // will be called if user clicks on followers button
        ComponentDefinition {
            id: userFollowersComponent
            source: "UserFollowers.qml"
        },
        // following list page
        // will be called if user clicks on following button
        ComponentDefinition {
            id: userFollowingComponent
            source: "UserFollowing.qml"
        }
    ]
}