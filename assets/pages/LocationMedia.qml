// *************************************************** //
// Location Media Page
//
// The location page shows a grid of media items that
// match a given Instagram location.
//
// Author: Dirk Songuer
// License: GPL v2
// See: http://choosealicense.com/licenses/gpl-v2/
// *************************************************** //

// import blackberry components
import bb.cascades 1.2
import bb.platform 1.2

// set import directory for components
import "../components"

// shared js files
import "../global/globals.js" as Globals
import "../global/copytext.js" as Copytext
import "../instagramapi/location.js" as LocationRepository

Page {
    id: locationMediaPage
    
    // signal if location data loading is complete
    signal locationDataLoaded(variant mediaDataArray, string paginationId)
    
    // signal if location data loading encountered an error
    signal locationDataError(variant errorData)

    // property containing the image data
    // this is filled by the calling page
    // image data is of type InstagramMediaData()
    property variant mediaData

    // main content container
    Container {
        // layout orientation
        layout: DockLayout {
        }

        MediaThumbnailGallery {
            id: locationMediaGallery

            // gallery sorted by index
            listSortingKey: "currentIndex"
            listSortAscending: true

            // gallery header
            headerText: "Location"

            onItemClicked: {
                // console.log("# Item clicked: " + mediaData.mediaId);
                var detailImagePage = detailImageComponent.createObject();
                detailImagePage.mediaData = mediaData;
                navigationPane.push(detailImagePage);
            }

            onListBottomReached: {
                if (currentItemIndex > 0) {
                    // console.log("# Loading additional images");
                    LocationRepository.getRecentMediaForLocation(mediaData.locationId, paginationNextMaxId, locationMediaPage);

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

    // new media data array is given
    onMediaDataChanged: {
        // console.log("# Loading data for location with name " + mediaData.locationName + " and ID: " + mediaData.locationId)

        // show loader
        loadingIndicator.showLoader("Loading media items");
        
        // gallery header text
        locationMediaGallery.headerText = "#" + mediaData.locationName;

        // load recent media data for given location
        LocationRepository.getRecentMediaForLocation(mediaData.locationId, 0, locationMediaPage);
    }

    // location media data loaded and transformed
    // data is stored in "mediaDataArray" variant as array of type InstagramMediaData
    onLocationDataLoaded: {
        // console.log("# Popular media data loaded. Found " + mediaDataArray.length + " items");

        if (locationMediaGallery.paginationNextMaxId != paginationId) {
            // set new pagination id to component
            locationMediaGallery.paginationNextMaxId = paginationId;

            // iterate through data objects
            // note that the return array contains 16 items, but only 15 are needed for portrait gallery
            for (var index in mediaDataArray) {
                // console.log("# Adding item with ID " + data[index].mediaId + " to gallery list data model");
                locationMediaGallery.addToGallery(mediaDataArray[index]);

                // add image for header, use the first image
                if (index == 0) {
                    locationMediaGallery.headerImage = mediaDataArray[index].mediaStandardImage;
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