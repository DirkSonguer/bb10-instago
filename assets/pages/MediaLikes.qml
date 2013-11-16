// *************************************************** //
// Media Likes Page
//
// The media likes page shows a grid of users that have
// liked the given media item.
// *************************************************** //

// import blackberry components
import bb.cascades 1.2

// set import directory for components
import "../components"

// shared js files
import "../global/globals.js" as Globals
import "../global/copytext.js" as Copytext
import "../instagramapi/media.js" as MediaRepository

Page {
    id: mediaLikesPage

    // signal if like data loading is complete
    signal mediaLikesLoaded(variant userDataArray)

    // signal if user profile data loading encountered an error (likes)
    signal mediaLikesError(variant errorData)

    // property containing the image data
    // this is filled by the calling page
    // image data is of type InstagramMediaData()
    property variant mediaData

    // main content container
    Container {
        // layout orientation
        layout: DockLayout {
        }

        // user gallery
        UserThumbnailGallery {
            id: userGalleryThumbnails

            // gallery sorted by index
            listSortingKey: "currentIndex"
            listSortAscending: true

            onItemClicked: {
                // console.log("# Item clicked: " + userData.userId);
                var userDetailPage = userDetailComponent.createObject();
                userDetailPage.userData = userData;
                navigationPane.push(userDetailPage);
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

    // media data has changed
    // load the user gallery content as soon as a media data item is given
    onMediaDataChanged: {
        // console.log("# Media data item given with ID " + mediaData.mediaId);

        // show loader
        loadingIndicator.showLoader("Loading likes");

        // load likes for given media item
        MediaRepository.getLikes(mediaData.mediaId, mediaLikesPage);
    }

    // media likes loaded and transformed
    // data is stored in "userDataArray" variant as array of type InstagramUserData
    onMediaLikesLoaded: {
        // console.log("# List of users that liked image loaded. Found " + userDataArray.length + " items");

        // iterate through data objects
        for (var index in userDataArray) {
            userGalleryThumbnails.addToGallery(userDataArray[index]);
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
        }
    ]
}
