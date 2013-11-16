// *************************************************** //
// User Followers Page
//
// The user folloers page shows a gallery of users that
// follow the current user.
// *************************************************** //

// import blackberry components
import bb.cascades 1.2
import bb.system 1.2

// set import directory for components
import "../components"

// shared js files
import "../global/globals.js" as Globals
import "../global/copytext.js" as Copytext
import "../instagramapi/relationships.js" as RelationshipRepository

Page {
    id: userFollowersPage

    // signal if user follower data loading is complete
    signal userFollowerDataLoaded(variant userDataArray, string cursorId)

    // signal if user follower data loading encountered an error
    signal userFollowerDataError(variant errorData)

    // property containing the user data
    // this is filled by the calling page
    // image data is of type InstagramUserData()
    property variant userData

    // main content container
    Container {
        layout: StackLayout {
            orientation: LayoutOrientation.TopToBottom
        }

        // likes header
        PageHeader {
            headline: "Followers"
            image: userData.profilePicture
        }

        // content container
        Container {
            // layout orientation
            layout: DockLayout {
            }

            // user gallery
            UserThumbnailGallery {
                id: userFollowersGallery

                // gallery sorted by index
                // newest likes on top
                listSortingKey: "currentIndex"
                listSortAscending: true

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
                        RelationshipRepository.getUserFollowers(userData.userId, cursorId, userFollowersPage);
                        userFollowersToast.body = "Loading more users..";
                        userFollowersToast.show();
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
        loadingIndicator.showLoader("Loading followers");

        // load likes for given media item
        RelationshipRepository.getUserFollowers(userData.userId, 0, userFollowersPage);
    }

    // media likes loaded and transformed
    // data is stored in "userDataArray" variant as array of type InstagramUserData
    onUserFollowerDataLoaded: {
        console.log("# List of users that the current user follows loaded. Found " + userDataArray.length + " items with cursor id " + cursorId);

        // set new cursor id
        userFollowersGallery.cursorId = cursorId;

        // iterate through data objects
        for (var index in userDataArray) {
            userFollowersGallery.addToGallery(userDataArray[index]);
        }

        // hide loader
        loadingIndicator.hideLoader();
    }

    // attach components
    attachedObjects: [
        // user detail page
        // will be called if user clicks on user item
        ComponentDefinition {
            id: userDetailComponent
            source: "UserDetail.qml"
        },
        // system toast
        // is used for messages
        SystemToast {
            id: userFollowersToast
            position: SystemUiPosition.MiddleCenter
        }
    ]
}
