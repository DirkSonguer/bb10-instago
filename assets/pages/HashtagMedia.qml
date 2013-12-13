// *************************************************** //
// Hashtag Media Page
//
// The hashtag page shows a grid of media items that
// match a given Instagram hashtag.
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
import "../instagramapi/search.js" as SearchRepository

Page {
    id: hashtagMediaPage

    // signal if popular media data loading is complete
    signal searchMediaDataLoaded(variant mediaDataArray, string paginationId)

    // signal if popular media data loading encountered an error
    signal searchDataError(variant errorData)

    // search term for images to be shown in gallery
    property string hashtagSearchTerm

    // main content container
    Container {
        // layout orientation
        layout: DockLayout {
        }

        MediaThumbnailGallery {
            id: hashtagMediaGallery

            // gallery sorted by index
            listSortingKey: "currentIndex"
            listSortAscending: true

            // gallery header
            headerText: "Search"

            onItemClicked: {
                // console.log("# Item clicked: " + mediaData.mediaId);
                var detailImagePage = detailImageComponent.createObject();
                detailImagePage.mediaData = mediaData;
                navigationPane.push(detailImagePage);
            }

            onListBottomReached: {
                if (currentItemIndex > 0) {
                    // console.log("# Loading additional images");
                    SearchRepository.getMediaSearchResults(hashtagSearchTerm, paginationNextMaxId, hashtagMediaPage);

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
    onHashtagSearchTermChanged: {
        // console.log("# Searching for hashtag " + hashtagMediaPage.hashtagSearchTerm);

        // show loader
        loadingIndicator.showLoader("Loading media items");
        
        // gallery header text
        hashtagMediaGallery.headerText = "#" + hashtagMediaPage.hashtagSearchTerm;

        // load media items for search term
        SearchRepository.getMediaSearchResults(hashtagSearchTerm, 0, hashtagMediaPage);
    }

    // hashtag media data loaded and transformed
    // data is stored in "mediaDataArray" variant as array of type InstagramMediaData
    onSearchMediaDataLoaded: {
        // console.log("# Popular media data loaded. Found " + mediaDataArray.length + " items");

        if (hashtagMediaGallery.paginationNextMaxId != paginationId) {
            // set new pagination id to component
            hashtagMediaGallery.paginationNextMaxId = paginationId;

            // iterate through data objects
            // note that the return array contains 16 items, but only 15 are needed for portrait gallery
            for (var index in mediaDataArray) {
                // console.log("# Adding item with ID " + data[index].mediaId + " to gallery list data model");
                hashtagMediaGallery.addToGallery(mediaDataArray[index]);

                // add image for header, use the first image
                if (index == 0) {
                    hashtagMediaGallery.headerImage = mediaDataArray[index].mediaStandardImage;
                }
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
}