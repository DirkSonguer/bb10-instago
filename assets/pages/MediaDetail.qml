// *************************************************** //
// Image Detail Page
//
// The image detail page is shown when a specific
// Instagram image is displayed.
// The page has a number of features that can be
// applied to the image as well as the user that
// uploaded it.
// *************************************************** //

// import blackberry components
import bb.cascades 1.2

// set import directory for components
import "../components"

// shared js files
import "../global/globals.js" as Globals
import "../global/copytext.js" as Copytext
import "../classes/authenticationhandler.js" as Authentication

Page {
    id: mediaDetailPage

    // property containing the image data
    // this is filled by the calling page
    // image data is of type InstagramMediaData()
    property variant mediaData

    // main content container
    Container {
        // layout definition
        layout: DockLayout {
        }

        // make the whole content container scrollables
        ScrollView {
            id: loginInstagramWebViewScrollContainer
            scrollViewProperties {
                scrollMode: ScrollMode.Vertical
                pinchToZoomEnabled: false
            }

            // image content
            Container {
                id: mediaDetailContainer

                // set initial visibility to false
                visible: false

                // layout definition
                layout: StackLayout {
                    orientation: LayoutOrientation.TopToBottom
                }

                // the actual thumbnail image
                InstagramImageView {
                    id: mediaDetailImage

                    // position and layout properties
                    verticalAlignment: VerticalAlignment.Center
                    horizontalAlignment: HorizontalAlignment.Center

                    onImageDoubleClicked: {
                        mediaDetailLikeButton.pressButton();
                    }
                }

                // the like and comment button
                Container {
                    // layout definition
                    layout: StackLayout {
                        orientation: LayoutOrientation.LeftToRight
                    }

                    // layout definition
                    topMargin: 1

                    // like button
                    // this also contains the full like functionalites
                    LikeButton {
                        id: mediaDetailLikeButton

                        // position and layout properties
                        layoutProperties: StackLayoutProperties {
                            spaceQuota: 1.0
                        }

                        // layout definition
                        rightMargin: 1
                    }

                    // comment button
                    // this also contains the full comment functionalites
                    CommentButton {
                        id: mediaDetailCommentButton

                        // position and layout properties
                        layoutProperties: StackLayoutProperties {
                            spaceQuota: 1.0
                        }
                    }
                }

                // the image description
                // this contains user profile image, name and image caption
                ImageDescription {
                    id: mediaDetailImageDescription

                    // layout definition
                    topMargin: 1

                    onClicked: {
                        // console.log("# Item clicked: " + mediaData.mediaId);
                        var userDetailPage = userDetailComponent.createObject();
                        userDetailPage.userId = mediaData.userData.userId;
                        navigationPane.push(userDetailPage);
                    }
                }

                // image location
                LocationMap {
                    id: mediaDetailLocation

                    // layout definition
                    topMargin: 1

                    // set initial visibility to false
                    // will be set true if the image has location data
                    visible: false
                }

                // comment preview container
                Container {
                    background: Color.create(Globals.instagoCoverBackgroundColor)

                    // layout definition
                    topMargin: 1

                    // comment previews
                    CommentPreview {
                        id: mediaDetailCommentPreview

                        // set specific height for component
                        // otherwise the height will be too great for some reason
                        preferredHeight: 620

                        // set initial visibility to false
                        visible: false

                        onCommentPreviewClicked: {
                            if (Authentication.auth.isAuthenticated()) {
                            }
                        }
                    }
                }
            }

            // check if Q series device and item is scrolled at all
            // if so, then hide / show the action bar
            onViewableAreaChanged: {
                if (DisplayInfo.height < 900)
                    if (viewableArea.y > 20) {
                    mediaDetailPage.actionBarVisibility = ChromeVisibility.Default;
                } else {
                    mediaDetailPage.actionBarVisibility = ChromeVisibility.Hidden;
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
    // this prepares the general state of the page
    // the page waits for an external page to fill the mediaData property
    onCreationCompleted: {
        // console.log("# Creation of media detail page finished");

        // hide action bar if Q series device
        if (DisplayInfo.height < 900) {
            console.log("# Display height is < 900, hiding action bar")
            actionBarVisibility:
            ChromeVisibility.Hidden;
        }

        // show loader
        loadingIndicator.showLoader("Loading media data");
    }

    // mediaData property was changed y an external page
    // fill the detail component with the given content
    onMediaDataChanged: {
        // hide loader
        loadingIndicator.hideLoader();

        // main image
        mediaDetailContainer.visible = true;
        mediaDetailImage.url = mediaData.mediaStandardImage;

        // image description (profile picture, name and image description)
        mediaDetailImageDescription.userimage = mediaData.userData.profilePicture;
        mediaDetailImageDescription.username = mediaData.userData.username;
        mediaDetailImageDescription.imagecaption = mediaData.caption;

        // likes + comments
        mediaDetailLikeButton.count = mediaData.numberOfLikes;
        mediaDetailCommentButton.count = mediaData.numberOfComments;
        mediaDetailLikeButton.mediaId = mediaData.mediaId;
        if (mediaData.userHasLiked !== undefined) {
            mediaDetailLikeButton.userHasLiked = mediaData.userHasLiked;
        }

        // if the image has comments, show them in the preview component
        if (mediaData.commentPreviews.length > 0) {
            mediaDetailCommentPreview.addToGallery(mediaData.commentPreviews);
            mediaDetailCommentPreview.visible = true;
        }

        if (mediaData.locationName !== undefined) {
            mediaDetailLocation.latitude = mediaData.locationLatitude;
            mediaDetailLocation.longitude = mediaData.locationLongitude;
            mediaDetailLocation.altitude = 1500;
            mediaDetailLocation.pinText = mediaData.locationName;
            mediaDetailLocation.visible = true;
        }
    }

    // attach components
    attachedObjects: [
        // detail image page
        // will be called if user clicks on image gallery item
        ComponentDefinition {
            id: userDetailComponent
            source: "UserDetail.qml"
        }
    ]
}
