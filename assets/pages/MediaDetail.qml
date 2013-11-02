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
import "../instagramapi/media.js" as MediaRepository
import "../instagramapi/users.js" as UserRepository
import "../structures/userdata.js" as InstagramUserData

Page {
    id: imageDetailPage

    // property containing the image data
    // this is filled by the calling page
    // image data is of type InstagramMediaData()
    property variant mediaData

    // main content container
    Container {
        // layout definition
        layout: DockLayout {
        }

        ScrollView {
            id: loginInstagramWebViewScrollContainer
            scrollViewProperties {
                scrollMode: ScrollMode.Vertical
                pinchToZoomEnabled: false
            }


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
                }

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
                
                ImageDescription {
                    id: mediaDetailImageDescription
                    topMargin: 1
                }
                
                                
            }
        }

        LoadingIndicator {
            id: loadingIndicator
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Center
        }

        ErrorMessage {
            id: errorMessage
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Center
        }
    }

    // page creation is finished
    // this prepares the general state of the page
    // the page waits for an external page to fill the mediaData property
    onCreationCompleted: {
        // console.log("# Creation of media detail page finished");

        // show loader
        loadingIndicator.showLoader("Loading media data");
    }

    // mediaData property was changed y an external page
    // fill the detail component with the given content
    onMediaDataChanged: {
        // hide loader
        loadingIndicator.hideLoader();

        mediaDetailContainer.visible = true;
        mediaDetailImage.url = mediaData.mediaStandardImage;

        mediaDetailImageDescription.userimage = mediaData.userData.profilePicture;
        mediaDetailImageDescription.username = mediaData.userData.username;
        mediaDetailImageDescription.imagecaption = mediaData.caption;

        mediaDetailLikeButton.count = mediaData.numberOfLikes;
        mediaDetailCommentButton.count = mediaData.numberOfComments;
        mediaDetailLikeButton.mediaId = mediaData.mediaId;
        if (mediaData.userHasLiked !== undefined) {
            mediaDetailLikeButton.userHasLiked = mediaData.userHasLiked;
        }

    }
}
