// *************************************************** //
// User Thumbnail Gallery Component
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

Container {
    id: userThumbnailGalleryComponent

    // signal if gallery is scrolled to start or end
    signal listBottomReached()
    signal listTopReached()
    signal listIsScrolling()

    // property that holds the id of the next image
    // this is given by Instagram for easy pagination
    property string paginationNextMaxId: ""

    // property that holds the current index
    // this is incremented as new items are added
    // to the list a provides the order the items were
    // added to the data model
    property int currentItemIndex: 0

    // properties to define how the list should be sorted
    property string listSortingKey: "timestamp"
    property alias listSortAscending: userThumbnailGalleryDataModel.sortedAscending

    // signal to clear the gallery contents
    signal clearGallery()
    onClearGallery: {
        userThumbnailGalleryDataModel.clear();
    }

    // signal to add a new item
    // item is given as type InstagramMediaData
    signal addToGallery(variant item)
    onAddToGallery: {
        // console.log("# Adding item with ID " + item.mediaId + " of type " + item.mediaType + " to thumbnail list data model");
        userThumbnailGalleryComponent.currentItemIndex += 1;
        userThumbnailGalleryDataModel.insert({
                "userData": item,
                "timestamp": item.timestamp,
                "currentIndex": userThumbnailGalleryComponent.currentItemIndex
            });
    }

    // signal if item was clicked
    signal itemClicked(variant userData)

    // this is a workaround to make the signals visible inside the listview item scope
    // see here for details: http://supportforums.blackberry.com/t5/Cascades-Development/QML-Accessing-variables-defined-outside-a-list-component-from/m-p/1786265#M641
    onCreationCompleted: {
        Qt.thumbnailSize = Math.round(DisplayInfo.width / 2);
    }

    // layout orientation
    layout: DockLayout {
    }

    // list of Instagram popular media
    ListView {
        id: userThumbnailGallery

        // associate the data model for the list view
        dataModel: userThumbnailGalleryDataModel

        // layout orientation
        layout: GridListLayout {
            orientation: LayoutOrientation.TopToBottom
            columnCount: 2
            verticalCellSpacing: 1
            horizontalCellSpacing: 1
        }

        // define component which will represent list item GUI appearence
        listItemComponents: [
            ListItemComponent {
                type: "item"

                // define gallery view component as view for each list item
                Container {
                    id: imageGalleryItem

                    // layout orientation
                    layout: DockLayout {
                    }

                    // item positioning
                    verticalAlignment: VerticalAlignment.Fill
                    horizontalAlignment: HorizontalAlignment.Fill
                    
                    // the actual thumbnail image
					InstagramImageView {
                        id: itemImage

                        // position and layout properties
                        verticalAlignment: VerticalAlignment.Center
                        horizontalAlignment: HorizontalAlignment.Center
                        
                        // set size, type and url
                        imageSize: Qt.thumbnailSize
                        mediaType: "image"
                        url: ListItemData.userData.profilePicture
					}
					
                    // mask the profile image to make it round
                    ImageView {
                        id: imageDescriptionMask
                        
                        // position and layout properties
                        verticalAlignment: VerticalAlignment.Center
                        horizontalAlignment: HorizontalAlignment.Center
                        
                        // set image size to maximum profile picture size
                        preferredHeight: Qt.thumbnailSize
                        preferredWidth: Qt.thumbnailSize
                        minHeight: Qt.thumbnailSize
                        minWidth: Qt.thumbnailSize
                        
                        imageSource: "asset:///images/mask_profile_pictures_default.png"
                    }					
					
                    // image description
                    // dark gray container containing the text
                    Container {
                        // layout definition
                        verticalAlignment: VerticalAlignment.Bottom
                        preferredWidth: Qt.thumbnailSize
                        minWidth: Qt.thumbnailSize
                        topPadding: 2
                        leftPadding: 5
                        bottomPadding: 2
                        rightPadding: 5

                        // color and transparency
                        background: Color.create(Globals.instagoDefaultBackgroundColor)
                        opacity: 0.8

                        // description text
                        Label {
                            text: "@" + ListItemData.userData.username

                            // layout definition
                            textStyle.base: SystemDefaults.TextStyles.BodyText
                            textStyle.fontWeight: FontWeight.W100
                            textStyle.textAlign: TextAlign.Left
                        }
                    }

                    // tap handling
                    // if item is tapped, change opacity
                    ListItem.onActivationChanged: {
                        if (active) {
                            // set opacity to transparent, image wil lfade into the background
                            itemImage.opacity = 0.75

                            // set size so that image gets smaller on press
                            itemImage.imageSize = Qt.thumbnailSize - 20
                            imageDescriptionMask.preferredHeight = Qt.thumbnailSize - 20
                            imageDescriptionMask.preferredWidth = Qt.thumbnailSize - 20
                            imageDescriptionMask.minHeight = Qt.thumbnailSize - 20
                            imageDescriptionMask.minWidth = Qt.thumbnailSize - 20
                        } else {
                            // reset opacity to normal
                            itemImage.opacity = 1.0

                            // set size so that image resets to normal on release
                            itemImage.imageSize = Qt.thumbnailSize
                            imageDescriptionMask.preferredHeight = Qt.thumbnailSize
                            imageDescriptionMask.preferredWidth = Qt.thumbnailSize
                            imageDescriptionMask.minHeight = Qt.thumbnailSize
                            imageDescriptionMask.minWidth = Qt.thumbnailSize
                        }
                    }
                }
            }
        ]

        // add action for tap on item
        onTriggered: {
            var currentItemData = userThumbnailGalleryDataModel.data(indexPath);

            // send item clicked event
            userThumbnailGalleryComponent.itemClicked(currentItemData.userData);
        }

        // add action for loading additional data after scrolling to bottom
        attachedObjects: [
            ListScrollStateHandler {
                id: scrollStateHandler
                onAtBeginningChanged: {
                    // console.log("# onAtBeginningChanged");
                    if (scrollStateHandler.atBeginning) {
                        userThumbnailGalleryComponent.listTopReached();
                    }
                }
                onAtEndChanged: {
                    // console.log("# onAtEndChanged");
                    if (scrollStateHandler.atEnd) {
                        userThumbnailGalleryComponent.listBottomReached();
                    }
                }
                onScrollingChanged: {
                    // console.log("# List is scrolling: " + scrollStateHandler.toDebugString());
                    if (! scrollStateHandler.atBeginning) {
                        userThumbnailGalleryComponent.listIsScrolling();
                    }
                }
            }
        ]
    }

    // attached objects
    attachedObjects: [
        // this will be the data model for the popular media list view
        GroupDataModel {
            id: userThumbnailGalleryDataModel
            sortedAscending: false
            sortingKeys: [ listSortingKey ]

            // items are grouped by the view and transformators
            // no need to set a behaviour by the data model
            grouping: ItemGrouping.None
        }
    ]
}
