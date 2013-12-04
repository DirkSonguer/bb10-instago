// *************************************************** //
// Search Page
//
// This page shows the search input field as well as
// the respective search results.
//
// Author: Dirk Songuer
// License: GPL v2
// See: http://choosealicense.com/licenses/gpl-v2/
// *************************************************** //

// import blackberry components
import bb.cascades 1.2
import bb.system 1.2

// set import directory for components
import "../components"

// shared js files
import "../global/globals.js" as Globals
import "../global/copytext.js" as Copytext

// this is a page that is available from the main tab, thus it has to be a navigation pane
// note that the id is always "navigationPane"
NavigationPane {
    id: navigationPane

    Page {
        id: searchPage

        // the title bar contains the options for the two search types
        titleBar: TitleBar {
            id: searchOptions

            // set kind to segmented title bar, containing 2 options
            kind: TitleBarKind.Segmented
            scrollBehavior: TitleBarScrollBehavior.Sticky
            options: [
                Option {
                    id: imageSearchOption
                    text: "Image Search"
                    value: "imageSearchOption"
                },
                Option {
                    id: userSearchOption
                    text: "User Search"
                    value: "userSearchOption"
                }
            ]

            // user actively selected a different search type
            onSelectedIndexChanged: {
                var value = searchOptions.selectedValue
                if (value == "imageSearchOption") {
                    // search for media items
                    searchInput.searchType = "media"
                    searchInput.hintText = "Search media"
                } else {
                    // search for users
                    searchInput.searchType = "users"
                    searchInput.hintText = "Search users"
                }
            }
        }

        // main content container
        Container {
            // layout orientation
            layout: DockLayout {
            }

            Container {
                layout: StackLayout {
                    orientation: LayoutOrientation.TopToBottom
                }

                verticalAlignment: VerticalAlignment.Top

                SearchInput {
                    id: searchInput

                    // layout definition
                    rightPadding: 5
                    leftPadding: 23
                    topPadding: 5
                    bottomPadding: 15

                    // search process has been triggered
                    onTriggered: {
                        // hide gallery components
                        searchMediaGallery.visible = false;
                        searchMediaGallery.clearGallery();
                        searchUserGallery.visible = false;
                        searchUserGallery.clearGallery();

                        // hide possible messages
                        infoMessage.hideMessage();

                        // show loader
                        loadingIndicator.showLoader("Searching " + searchType + " data");
                    }

                    // media search items loaded
                    // show the media gallery accordingly
                    onSearchMediaDataLoaded: {
                        // check if search results are available
                        // if not, show default message
                        if (mediaDataArray.length == 0) {
                            // hide gallery components
                            searchMediaGallery.visible = false;
                            searchUserGallery.visible = false;

                            // hide loader
                            loadingIndicator.hideLoader();

                            // show message
                            infoMessage.showMessage(Copytext.instagoSearchNoItemsFound, "Sorry");
                        } else {
                            if (searchMediaGallery.paginationNextMaxId != paginationId) {
                                // set new pagination id to component
                                searchMediaGallery.paginationNextMaxId = paginationId;

                                // iterate through data objects
                                for (var index in mediaDataArray) {
                                    // console.log("# Adding item with ID " + data[index].mediaId + " to gallery list data model");
                                    searchMediaGallery.addToGallery(mediaDataArray[index]);
                                }
                            }

                            // hide loading indicator & show gallery
                            loadingIndicator.hideLoader();
                            searchMediaGallery.visible = true;
                            instagoCenterToast.cancel();
                        }
                    }

                    // media search items error
                    // show error output
                    onSearchDataError: {
                        infoMessage.showMessage(Copytext.instagoSearchNoItemsFound + " Reason: " + errorData.errorMessage, "Sorry");

                        // hide loading indicator & show gallery
                        loadingIndicator.hideLoader();
                        searchMediaGallery.visible = false;
                        instagoCenterToast.cancel();
                    }

                    // user search items loaded
                    // show the user gallery accordingly
                    onSearchUserDataLoaded: {
                        // check if search results are available
                        // if not, show default message
                        if (userDataArray.length == 0) {
                            // hide gallery components
                            searchMediaGallery.visible = false;
                            searchUserGallery.visible = false;

                            // hide loader
                            loadingIndicator.hideLoader();

                            // show message
                            infoMessage.showMessage(Copytext.instagoSearchNoItemsFound, "Sorry");
                        } else {
                            // iterate through data objects
                            for (var index in userDataArray) {
                                // console.log("# Adding item with ID " + data[index].mediaId + " to gallery list data model");
                                searchUserGallery.addToGallery(userDataArray[index]);
                            }

                            // hide loading indicator & show gallery
                            loadingIndicator.hideLoader();
                            searchUserGallery.visible = true;
                            instagoCenterToast.cancel();
                        }
                    }
                }

                // media item result gallery
                MediaThumbnailGallery {
                    id: searchMediaGallery

                    // set initial visibility to false
                    // will be set visible once data is loaded
                    visible: false

                    // load detail media item page
                    onItemClicked: {
                        // console.log("# Item clicked: " + mediaData.mediaId);
                        var detailImagePage = detailImageComponent.createObject();
                        detailImagePage.mediaData = mediaData;
                        navigationPane.push(detailImagePage);
                    }

                    // load next set of data
                    onListBottomReached: {
                        if ((paginationNextMaxId != "") && (paginationNextMaxId != 0)) {
                            // console.log("# List bottom reached. Next pagination id is " + paginationNextMaxId);
                            searchInput.nextMediaPage(paginationNextMaxId);

                            // show toast that new images are loading
                            instagoCenterToast.body = "Loading more images..";
                            instagoCenterToast.show();
                        }
                    }
                }

                // user item result gallery
                UserThumbnailGallery {
                    id: searchUserGallery

                    // set initial visibility to false
                    // will be set visible once data is loaded
                    visible: false

                    // load detail user page
                    onItemClicked: {
                        // console.log("# Item clicked: " + mediaData.userData.userId);
                        var userDetailPage = userDetailComponent.createObject();
                        userDetailPage.userData = userData;
                        navigationPane.push(userDetailPage);
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

    // attach components
    attachedObjects: [
        // detail image page
        // will be called if user clicks on image gallery item
        ComponentDefinition {
            id: detailImageComponent
            source: "MediaDetail.qml"
        },
        // user detail page
        // will be called if user clicks on user description
        ComponentDefinition {
            id: userDetailComponent
            source: "UserDetail.qml"
        }
    ]

    // destroy pages after use
    onPopTransitionEnded: {
        page.destroy();
    }
}