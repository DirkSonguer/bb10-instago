// *************************************************** //
// Popular Photos Page
//
// The popular photos page shows a grid of the current
// popular photos that can be tapped.
// It is shown as default starting page if the user is
// not logged in.
// *************************************************** //

// import blackberry components
import bb.cascades 1.2

// set import directory for components
import "../components"

// shared js files
import "../global/globals.js" as Globals
import "../global/copytext.js" as Copytext
import "../instagramapi/media.js" as MediaRepository

// this is a page that is available from the main tab, thus it has to be a navigation pane
// note that the id is always "navigationPane"
NavigationPane {
    id: navigationPane

    Page {
        id: popularMediaPage

        // signal if popular media data loading is complete
        signal popularMediaDataLoaded(variant mediaDataArray)

        // signal if popular media data loading encountered an error
        signal popularMediaDataError(variant errorData)

        // main content container
        Container {
            // layout orientation
            layout: DockLayout {
            }

            MediaThumbnailGallery {
                id: popularMediaThumbnails

                // gallery sorted by index
                listSortingKey: "currentIndex"
                listSortAscending: true

                onItemClicked: {
                    // console.log("# Item clicked: " + mediaData.mediaId);
                    var detailImagePage = detailImageComponent.createObject();
                    detailImagePage.mediaData = mediaData;
                    navigationPane.push(detailImagePage);
                }

                onListBottomReached: {
                    if (currentItemIndex > 0) {
                        // console.log("# Appending popular stream");
                        MediaRepository.getPopularMedia(popularMediaPage);
                        
                        // show toast that new images are loading
                        instagoCenterToast.body = "Loading more images..";
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

        // page creation is finished
        // load the gallery content as soon as the page is ready
        onCreationCompleted: {
            // console.log("# Creation of popular media page finished");

            // show loader
            loadingIndicator.showLoader("Loading popular items");

            // load popular media stream
            MediaRepository.getPopularMedia(popularMediaPage);
        }

        // popular media data loaded and transformed
        // data is stored in "mediaDataArray" variant as array of type InstagramMediaData
        onPopularMediaDataLoaded: {
            // console.log("# Popular media data loaded. Found " + mediaDataArray.length + " items");

            // iterate through data objects
            for (var index in mediaDataArray) {
                popularMediaThumbnails.addToGallery(mediaDataArray[index]);
            }

            // hide loader
            loadingIndicator.hideLoader();
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
        }
    ]

    // destroy pages after use
    onPopTransitionEnded: {
        page.destroy();
    }
}
