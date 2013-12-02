// *************************************************** //
// User Favorites Page
//
// The page shows a list of images that the current user
// has liked. Not that Instagram does only return a list
// of the most recent liked images.
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
import "../instagramapi/users.js" as UserRepository

Page {
    id: userFavoritesPage

    // signal if user media data loading is complete
    signal userFavoritesDataLoaded(variant mediaDataArray, string paginationId)

    // signal if user media data loading encountered an error
    signal userFavoritesDataError(variant errorData)

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

            MediaThumbnailGallery {
                id: userFavoritesThumbnails

                // gallery sorted by index
                listSortingKey: "currentIndex"
                listSortAscending: true

                // gallery header
                headerText: "Favorites"

                onItemClicked: {
                    // console.log("# Item clicked: " + mediaData.mediaId);
                    var detailImagePage = detailImageComponent.createObject();
                    detailImagePage.mediaData = mediaData;
                    navigationPane.push(detailImagePage);
                }

                onListBottomReached: {
                    // check if there is another page available
                    // if so, load the data
                    if ((userFavoritesThumbnails.paginationNextMaxId != "") && (userFavoritesThumbnails.paginationNextMaxId != 0)) {
                        // console.log("# Appending favorites");
                        UserRepository.getUserFavorites(paginationNextMaxId, userFavoritesPage);

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
    }

    // load favorites data
    onCreationCompleted: {
        // show loader
        loadingIndicator.showLoader("Loading followers");

        // load favorite data
        UserRepository.getUserFavorites(0, userFavoritesPage);
    }

    // user favorite media data loaded and transformed
    // data is stored in "mediaDataArray" variant as array of type InstagramMediaData
    onUserFavoritesDataLoaded: {
        // set new pagination id
        if (userFavoritesThumbnails.paginationNextMaxId != paginationId) {
            // set new pagination id to component
            userFavoritesThumbnails.paginationNextMaxId = paginationId;

            // iterate through data objects
            for (var index in mediaDataArray) {
                // add each object to the gallery list data model
                // console.log("# Adding item to list with ID: " + mediaDataArray[index].mediaId);
                userFavoritesThumbnails.addToGallery(mediaDataArray[index]);

                // add image for header, use the first image
                if (index == 0) {
                    userFavoritesThumbnails.headerImage = mediaDataArray[index].mediaStandardImage;
                }
            }

            // hide loading indicator & show gallery
            loadingIndicator.hideLoader();
            instagoCenterToast.cancel();
        }
    }

    onUserFavoritesDataError: {

    }

    // attach components
    attachedObjects: [
        // image detail page
        // will be called if user clicks on a media item
        ComponentDefinition {
            id: detailImageComponent
            source: "MediaDetail.qml"
        }
    ]
}
