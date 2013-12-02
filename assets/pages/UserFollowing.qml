// *************************************************** //
// User Following Page
//
// The user folloers page shows a gallery of users that
// follow the current user.
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
import "../instagramapi/relationships.js" as RelationshipRepository

Page {
    id: userFollowingPage

    // signal if user following data loading is complete
    signal userFollowingDataLoaded(variant userDataArray, string cursorId)
    
    // signal if user following data loading encountered an error
    signal userFollowingDataError(variant errorData)

    // property containing the user data
    // this is filled by the calling page
    // image data is of type InstagramUserData()
    property variant userData

    // main content container
    Container {
        layout: StackLayout {
            orientation: LayoutOrientation.TopToBottom
        }

        // content container
        Container {
            // layout orientation
            layout: DockLayout {
            }

            // user gallery
            UserThumbnailGallery {
                id: userFollowingGallery

                // gallery sorted by index
                // newest likes on top
                listSortingKey: "currentIndex"
                listSortAscending: true
                
                // header text
                headerText: "Following"

                onItemClicked: {
                    // console.log("# Item clicked: " + userData.userId);
                    var userDetailPage = userDetailComponent.createObject();
                    userDetailPage.userData = userData;
                    navigationPane.push(userDetailPage);
                }

                // list scrolled to bottom
                // load more users if available
                onListBottomReached: {
                    if ((cursorId != "") && (cursorId != 0)) {
                        // console.log("# List bottom reached. Next cursor id is " + cursorId);
                        RelationshipRepository.getUserFollowing(userData.userId, cursorId, userFollowingPage);
                        
                        // show toast that new images are loading
                        instagoCenterToast.body = "Loading more users..";
                        instagoCenterToast.show();
                    }
                }
            }

            LoadingIndicator {
                id: loadingIndicator
                verticalAlignment: VerticalAlignment.Center
                horizontalAlignment: HorizontalAlignment.Center
            }

            InfoMessage {
                id: infoMessage
                verticalAlignment: VerticalAlignment.Center
                horizontalAlignment: HorizontalAlignment.Center
            }
        }
    }

    // media data has changed
    // load the user gallery content as soon as a media data item is given
    onUserDataChanged: {
        // console.log("# User data item given with ID " + userData.userId);

        // show loader
        loadingIndicator.showLoader("Loading Following");
        
        // fill header image
        userFollowingGallery.headerImage = userData.profilePicture;

        // load likes for given media item
        RelationshipRepository.getUserFollowing(userData.userId, 0, userFollowingPage);
    }

    // media likes loaded and transformed
    // data is stored in "userDataArray" variant as array of type InstagramUserData
    onUserFollowingDataLoaded: {
        // console.log("# List of users that follow the current user. Found " + userDataArray.length + " items with cursor id " + cursorId);

        // set new cursor id
        userFollowingGallery.cursorId = cursorId;

        // iterate through data objects
        for (var index in userDataArray) {
            userFollowingGallery.addToGallery(userDataArray[index]);
        }

        // hide loader
        loadingIndicator.hideLoader();
        instagoCenterToast.cancel();
    }

    // attach components
    attachedObjects: [
        // user detail page
        // will be called if user clicks on user item
        ComponentDefinition {
            id: userDetailComponent
            source: "UserDetail.qml"
        }
    ]
}
