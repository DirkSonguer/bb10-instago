// *************************************************** //
// Media Comments Page
//
// The media comments page shows a list of user comments
// for a given media item.
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
                
                // header text
                headerText: "Comments"

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
                
                onListIsScrolling: {
                    mediaCommentsInput.visible = false;
                }

                onItemClicked: {
                    // console.log("# Item clicked: " + userData.userId);
                    mediaCommentsInput.visible = true;
                    mediaCommentsInput.text = "@" + commentData.userData.username;
                }
                
                onProfileClicked: {
                    // console.log("# Item clicked: " + mediaData.userData.userId);
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
        
        // comment input container
        CommentInput {
            id: mediaCommentsInput
            
            // layout definition
            bottomMargin: 20
            topMargin: 1
            
            // set initial visibility to false
            // will be changed by logic
            visible: false
            
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
    }

    // media data has changed
    // load the user comment content as soon as a media data item is given
    onMediaDataChanged: {
        // console.log("# Media data item given with ID " + mediaData.mediaId);

        // show loader
        loadingIndicator.showLoader("Loading comments");
        
        // add image
        mediaCommentsList.headerImage = mediaData.mediaStandardImage;

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
