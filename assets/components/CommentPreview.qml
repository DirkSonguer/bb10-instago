// *************************************************** //
// Thumbnail Gallery Component
//
// This component shows a gallery of thumbnails with an
// optional text field
// This component accepts data of type InstagramMediaData
// *************************************************** //

// import blackberry components
import bb.cascades 1.2

// shared js files
import "../global/globals.js" as Globals
import "../global/copytext.js" as Copytext

// import image url loader component
import WebImageView 1.0

Container {
    id: commentPreviewComponent

    // property that holds the current index
    // this is incremented as new items are added
    // to the list a provides the order the items were
    // added to the data model
    property int currentItemIndex: 0

    // signal to show that component has been clicked
    signal commentPreviewClicked()

    // signal to clear the gallery contents
    signal clearGallery()
    onClearGallery: {
        commentPreviewDataModel.clear();
    }

    // signal to add a new item
    // item is given as type InstagramCommentData
    signal addToGallery(variant item)
    onAddToGallery: {
        console.log("# Adding comment items " + item.length);

        // iterate through data objects
        for (var index in item) {
            commentPreviewComponent.currentItemIndex += 1;
            commentPreviewDataModel.insert({
                    "commentData": item[index],
                    "currentIndex": commentPreviewComponent.currentItemIndex
                });
        }
    }

    // list view containing the individual comment items
    ListView {
        id: commentPreview

        // associate the data model for the list view
        dataModel: commentPreviewDataModel

        // define component which will represent the list items in the UI
        listItemComponents: [
            ListItemComponent {
                type: "item"

                // root container containing all the UI elements
                Container {
                    id: commentListItem

                    // layout definition
                    layout: StackLayout {
                        orientation: LayoutOrientation.LeftToRight
                    }

                    // layout definition
                    topPadding: 20
                    leftPadding: 30
                    rightPadding: 10

                    Container {
                        // layout definition
                        layout: DockLayout {
                        }

                        // profile image
                        // this is a web image view provided by WebViewImage
                        WebImageView {
                            id: imageDescriptionProfileImage

                            // align the image in the center
                            verticalAlignment: VerticalAlignment.Center
                            horizontalAlignment: HorizontalAlignment.Left

                            url: ListItemData.commentData.from["profile_picture"]

                            // set image size to maximum screen size
                            // this will be either 768x768 (Z10) or 720x720 (all others)
                            preferredHeight: 50
                            preferredWidth: 50
                            minHeight: 50
                            minWidth: 50
                        }

                        // mask the profile image to make it round
                        ImageView {
                            // position and layout properties
                            verticalAlignment: VerticalAlignment.Center
                            horizontalAlignment: HorizontalAlignment.Left

                            // set image size to maximum screen size
                            // this will be either 768x768 (Z10) or 720x720 (all others)
                            preferredHeight: 50
                            preferredWidth: 50
                            minHeight: 50
                            minWidth: 50

                            imageSource: "asset:///images/mask_profile_pictures_black.png"
                        }
                    }

                    // image caption
                    Label {
                        id: itemCaption
                        textStyle.base: SystemDefaults.TextStyles.BodyText
                        textStyle.fontWeight: FontWeight.W100
                        textStyle.textAlign: TextAlign.Left
                        text: ListItemData.commentData["text"]
                    }
                }
            }
        ]
    }

    // handle tap on comment preview component
    gestureHandlers: [
        TapHandler {
            onTapped: {
                commentPreviewComponent.commentPreviewClicked();
            }
        }
    ]

    // attached objects
    attachedObjects: [
        // this will be the data model for the popular media list view
        GroupDataModel {
            id: commentPreviewDataModel
            sortedAscending: false

            // items are grouped by the view and transformators
            // no need to set a behaviour by the data model
            grouping: ItemGrouping.None
        }
    ]
}
