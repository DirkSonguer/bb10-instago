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

// import timer type
import QtTimer 1.0

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

        // comment input container
        CommentInput {
            id: mediaCommentsInput

            // layout definition
            bottomMargin: 10
            topMargin: 1

            // add comment count
            onCommentAdded: {
                // show loader
                loadingIndicator.showLoader("Loading comments");

                // clear list
                mediaCommentsList.clearList()

                // start the timer
                // this basically waits a second and then reloads the comment list
                mediaCommentsTimer.start();
            }
        }

        // content container
        Container {
            // layout orientation
            layout: DockLayout {
            }

            // layout definition
            topMargin: 1

            // user gallery
            MediaCommentList {
                id: mediaCommentsList

                // gallery sorted by index
                // newest comments on top
                listSortingKey: "currentIndex"
                listSortAscending: false

                onListIsScrolling: {
                    mediaCommentsInput.visible = false;
                }

                onListTopReached: {
                    mediaCommentsInput.visible = true;
                }

                onItemClicked: {
                    // console.log("# Item clicked: " + userData.userId);
                    mediaCommentsInput.visible = true;
                    mediaCommentsInput.text = "@" + commentData.userData.username;
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
        // console.log("# Media data item given with ID " + mediaData.mediaId);

        // show loader
        loadingIndicator.showLoader("Loading comments");

        // load comments for given media item
        MediaRepository.getComments(mediaData.mediaId, mediaCommentsPage);
    }

    // comment data was loaded successfully
    // data is stored in "commentDataArray" variant as array of type InstagramCommentData
    onMediaCommentsLoaded: {
        // console.log("# List of comments for media item. Found " + commentDataArray.length + " items");

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
        },
        // timer component
        // used to delay reload after commenting
        Timer {
            id: mediaCommentsTimer
            interval: 1000
            singleShot: true

            // when triggered, reload the comment data
            onTimeout: {
                // load comments for given media item
                MediaRepository.getComments(mediaData.mediaId, mediaCommentsPage);
            }
        }
    ]
}
