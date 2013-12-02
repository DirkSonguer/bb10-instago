// *************************************************** //
// User Profile Page
//
// The user profile page shows the personal information
// about the current user.
// Note that is only the profile page of the currently
// logged in user, not users in general.
//
// Author: Dirk Songuer
// License: GPL v2
// See: http://choosealicense.com/licenses/gpl-v2/
// *************************************************** //

// import blackberry components
import bb.cascades 1.2

// set import directory for components
import "../components"

// shared js files
import "../global/globals.js" as Globals
import "../global/copytext.js" as Copytext
import "../instagramapi/users.js" as UserRepository

// import image url loader component
import WebImageView 1.0

// this is a page that is available from the main tab, thus it has to be a navigation pane
// note that the id is always "navigationPane"
NavigationPane {
    id: navigationPane

    Page {
        id: userProfilePage

        // signal if user profile data loading is complete
        signal userDetailDataLoaded(variant userData)

        // signal if user profile data loading encountered an error
        signal userDetailDataError(variant errorData)

        // signal if user media data loading is complete
        signal userMediaDataLoaded(variant mediaDataArray, string paginationId)

        // signal if user media data loading encountered an error
        signal userMediaDataError(variant errorData)

        // property that holds the loaded user data
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
                    id: userProfileContainer

                    // layout orientation
                    layout: StackLayout {
                        orientation: LayoutOrientation.TopToBottom
                    }

                    // set initial visibility to false
                    visible: false

                    UserHeader {
                        id: userProfileHeader
                    }

                    // the like and comment button
                    Container {
                        id: userProfileFollowerAndFollowingCount

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
                            id: userProfileFollowersCount

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
                                userFollowersPage.userData = userProfilePage.userData;
                                navigationPane.push(userFollowersPage);
                            }
                        }

                        CustomButton {
                            id: userProfileFollowingCount

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
                                userFollowingPage.userData = userProfilePage.userData;
                                navigationPane.push(userFollowingPage);
                            }
                        }
                    }

                    // media items the user liked
                    CustomButton {
                        id: userProfileFavourites

                        // layout definition
                        preferredWidth: DisplayInfo.width
                        topMargin: 1

                        // button label
                        narrowText: "Your favourites"

                        onClicked: {
                        }
                    }

                    // link to edit profile sheet
                    CustomButton {
                        id: userProfileEditProfile

                        // layout definition
                        preferredWidth: DisplayInfo.width
                        topMargin: 1

                        // button label
                        narrowText: "Edit profile"

                        onClicked: {
                            // create edit profile sheet
                            // note that the components are defined in /main.qml
                            var editProfilePage = editProfileComponent.createObject();
                            editProfileSheet.setContent(editProfilePage);
                            
                            editProfileSheet.open();
                        }
                    }

                    MediaThumbnailGallery {
                        id: userProfileMediaThumbnails

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
                    var userMediaListHeight = Math.ceil(userProfileMediaThumbnails.currentItemIndex / 2) * (Math.round(DisplayInfo.width / 2));
                    var currentVisibleArea = viewableArea.height + viewableArea.y;

                    // check if view port is at the bottom of the component height
                    if (currentVisibleArea > userMediaListHeight) {
                        // console.log("# List bottom reached");

                        // check if there is another page available
                        // if so, load the data
                        if ((userProfileMediaThumbnails.paginationNextMaxId != "") && (userProfileMediaThumbnails.paginationNextMaxId != 0)) {
                            // console.log("# List bottom reached. Next pagination id is " + userProfileMediaThumbnails.paginationNextMaxId);
                            UserRepository.getUserMedia(userProfilePage.userData.userId, userProfileMediaThumbnails.paginationNextMaxId, userProfilePage);
                            userProfileMediaThumbnails.paginationNextMaxId = 0;

                            // show toast that new images are loading
                            instagoCenterToast.body = "Loading more images..";
                            instagoCenterToast.show();
                        }
                    }
                }
            }

            LoadingIndicator {
                id: loadingIndicator
                verticalAlignment: VerticalAlignment.Center
                horizontalAlignment: HorizontalAlignment.Center
            }
        }

        onCreationCompleted: {
            // show loader
            loadingIndicator.showLoader("Loading user profile");

            // console.log("# Loading current user data for current user");
            UserRepository.getUserProfile("self", userProfilePage);
        }

        // user profile data loaded and transformed
        // data is stored in "userData" variant of type InstagramUserData
        onUserDetailDataLoaded: {
            // console.log("# User detail data loaded for user " + userData.username);

            // update page userData object with full data
            userProfilePage.userData = userData;

            // hide loader and show content
            loadingIndicator.hideLoader();
            userProfileContainer.visible = true;

            // user metadata (profile picture, full and user name)
            userProfileHeader.userimage = userData.profilePicture;
            userProfileHeader.username = "@" + userData.username;
            userProfileHeader.userfullname = userData.fullName;
            userProfileHeader.userwebsite = userData.website;

            // followers and following count
            userProfileFollowerAndFollowingCount.visible = true;
            userProfileFollowersCount.boldText = userData.numberOfFollowers;
            userProfileFollowersCount.narrowText = "followers";
            userProfileFollowingCount.boldText = userData.numberOfFollows;
            userProfileFollowingCount.narrowText = "following";

            // load user media items
            UserRepository.getUserMedia(userData.userId, 0, userProfilePage);
        }

        // user profile data could not be loaded or transformed
        // show error message
        onUserDetailDataError: {
            // console.log("# User detail data could not be loaded. Error: " + errorData.errorMessage);

            // show error message
            infoMessage.showMessage(errorData.errorMessage, "Error " + errorData.errorCode);
        }

        // user media data loaded and transformed
        // data is stored in "mediaDataArray" variant as array of type InstagramMediaData
        onUserMediaDataLoaded: {
            // console.log("# User media data loaded. Found " + mediaDataArray.length + " items");

            // check if the result pagination id is another one than we already have
            if (userProfileMediaThumbnails.paginationNextMaxId != paginationId) {
                // set new pagination id to component
                userProfileMediaThumbnails.paginationNextMaxId = paginationId;

                // iterate through data objects
                for (var index in mediaDataArray) {
                    // add each object to the gallery list data model
                    // console.log("# Adding item to list with ID: " + mediaDataArray[index].mediaId);
                    userProfileMediaThumbnails.addToGallery(mediaDataArray[index]);
                }

                // show gallery component
                userProfileMediaThumbnails.visible = true;
                instagoCenterToast.cancel();
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
}