// *************************************************** //
// Personal Feed Page
//
// The personal feed page shows the media feed for the
// currently logged in user.
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

// this is a page that is available from the main tab, thus it has to be a navigation pane
// note that the id is always "navigationPane"
NavigationPane {
    id: navigationPane

    Page {
        id: personalFeedPage

        // actionBarAutoHideBehavior: ActionBarAutoHideBehavior.HideOnScroll
        // actionBarVisibility: actionBarVisibility.Hidden

        // signal if personal feed data loading is complete
        signal personalFeedLoaded(variant mediaDataArray, string paginationId)

        // signal if personal feed data loading went wrong
        signal personalFeedError(variant errorData)

        // main content container
        Container {
            // layout definition
            layout: DockLayout {
            }

            FullsizeGallery {
                id: personalFeedThumbnails

                // gallery sorted by index
                listSortingKey: "currentIndex"
                listSortAscending: true

                onItemClicked: {
                    // console.log("# Item clicked: " + mediaData.mediaId);
                    var detailImagePage = detailImageComponent.createObject();
                    detailImagePage.mediaData = mediaData;
                    navigationPane.push(detailImagePage);
                }

                // list scrolled to bottom
                // load more images if available
                onListBottomReached: {
                    if ((paginationNextMaxId != "") && (paginationNextMaxId != 0)) {
                        // console.log("# List bottom reached. Next pagination id is " + paginationNextMaxId);
                        UserRepository.getPersonalFeed(paginationNextMaxId, personalFeedPage);
                        paginationNextMaxId = 0;

                        // show toast that new images are loading
                        personalFeedToast.body = "Loading more images..";
                        personalFeedToast.show();
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

        // page creation is finished
        // load the gallery content as soon as the page is ready
        onCreationCompleted: {
            // console.log("# Creation of personal feed page finished");

            // show loader
            loadingIndicator.showLoader("Loading your feed");

            // load popular media stream
            // will call onPersonalFeedLoaded signal when finished
            UserRepository.getPersonalFeed(0, personalFeedPage);
        }

        // popular media data loaded and transformed
        // data is stored in "mediaDataArray" variant as array of type InstagramMediaData
        onPersonalFeedLoaded: {
            // console.log("# Personal feed loaded. Found " + mediaDataArray.length + " items");

            if (personalFeedThumbnails.paginationNextMaxId != paginationId) {
                // set new pagination id to component
                personalFeedThumbnails.paginationNextMaxId = paginationId;

                if (mediaDataArray.length == 0) {
                    infoMessage.showMessage("You have no items in your feed yet", "Feed empty");
                }

                // iterate through data objects
                for (var index in mediaDataArray) {
                    personalFeedThumbnails.addToGallery(mediaDataArray[index]);
                }
            }

            // hide loader
            loadingIndicator.hideLoader();
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
        // system toast
        // is used for messages
        SystemToast {
            id: personalFeedToast
            body: ""
        }
    ]

    // destroy pages after use
    onPopTransitionEnded: {
        page.destroy();
    }
}
