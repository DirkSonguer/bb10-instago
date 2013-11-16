// *************************************************** //
// Media Comments Page
//
// The media comments page shows a list of user comments
// for a given media item.
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
    id: mediaCommentsPage

    // signal if comment data loading is complete
    signal mediaCommentsLoaded(variant commentDataArray)

    // signal if comment data loading encountered an error
    signal mediaCommentsError(variant errorData)

    // property containing the image data
    // this is filled by the calling page
    // image data is of type InstagramMediaData()
    property variant mediaData

    // main content container
    Container {
        layout: StackLayout {
            orientation: LayoutOrientation.TopToBottom
        }

        // comments header
        PageHeader {
            headline: "Comments"
            image: mediaData.mediaStandardImage
        }

        // content container
        Container {
            // layout orientation
            layout: DockLayout {
            }

            topMargin: 1

            // user gallery
            MediaCommentList {
                id: mediaCommentsList

                // gallery sorted by index
                listSortingKey: "currentIndex"
                listSortAscending: true

                onItemClicked: {
                    // console.log("# Item clicked: " + userData.userId);
                    // var userDetailPage = userDetailComponent.createObject();
                    // userDetailPage.userData = userData;
                    // navigationPane.push(userDetailPage);
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
    // load the user comment content as soon as a media data item is given
    onMediaDataChanged: {
        console.log("# Media data item given with ID " + mediaData.mediaId);

        // show loader
        loadingIndicator.showLoader("Loading comments");

        // load comments for given media item
        MediaRepository.getComments(mediaData.mediaId, mediaCommentsPage);
    }

    // comment data was loaded successfully
    // data is stored in "commentDataArray" variant as array of type InstagramCommentData
    onMediaCommentsLoaded: {
        console.log("# List of comments for media item. Found " + commentDataArray.length + " items");

        // iterate through data objects
        for (var index in commentDataArray) {
            mediaCommentsList.addToList(commentDataArray[index]);
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
