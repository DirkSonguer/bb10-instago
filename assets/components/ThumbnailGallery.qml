// *************************************************** //
// Thumbnail List Component
//
// This component shows a list of thumbnails with an
// optional text field
// This component accepts data of type InstagramMediaData
// *************************************************** //

// import blackberry components
import bb.cascades 1.2

// shared js files
import "../global/globals.js" as Globals
import "../global/copytext.js" as Copytext

// import image url loader workaround
import WebImageView 1.0

Container {
    id: thumbnailGalleryComponent

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
    property alias listSortAscending: thumbnailGalleryDataModel.sortedAscending

    // signal to clear the gallery contents
    signal clearGallery()
    onClearGallery: {
        thumbnailGalleryDataModel.clear();
    }

    // signal to add a new item
    // item is given as type InstagramMediaData
    signal addToGallery(variant item)
    onAddToGallery: {
        console.log("# Adding item with ID " + item.mediaId + " to thumbnail list data model");
        thumbnailGalleryComponent.currentItemIndex += 1;
        thumbnailGalleryDataModel.insert({
                "mediaData": item,
                "timestamp": item.timestamp,
                "currentIndex": thumbnailGalleryComponent.currentItemIndex
            });
    }

    // signal if item was clicked
    signal itemClicked(variant mediaData)
    
    // this is a workaround to make the signals visible inside the listview item scope
    // see here for details: http://supportforums.blackberry.com/t5/Cascades-Development/QML-Accessing-variables-defined-outside-a-list-component-from/m-p/1786265#M641
    onCreationCompleted: {
        Qt.thumbnailSize = Math.round(DisplayInfo.width / 2);
    }

    // layout definition
    layout: DockLayout {
    }

    // list of Instagram popular media
    ListView {
        id: thumbnailGallery

        // associate the data model for the list view
        dataModel: thumbnailGalleryDataModel

        // define list layout as grid
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

                    // layout definition
                    layout: DockLayout {
                    }

                    // item positioning
                    verticalAlignment: VerticalAlignment.Fill
                    horizontalAlignment: HorizontalAlignment.Fill
                    property string itemCreatedTime: ListItemData.mediaData.createdTime

                    // gallery image
                    // this is a web image view provided by org.labsquare 1.0
                    WebImageView {
                        id: itemImage

                        // position and layout properties
                        layoutProperties: StackLayoutProperties {
                            spaceQuota: 1.0
                        }

                        // layout definition
                        preferredHeight: Qt.thumbnailSize
                        preferredWidth: Qt.thumbnailSize
                        minHeight: Qt.thumbnailSize
                        minWidth: Qt.thumbnailSize

                        // set initial visibility to false
                        visible: false

                        // prevent webview context menu
                        touchPropagationMode: TouchPropagationMode.None

                        // change loader with image if loading is complete
                        onLoadingChanged: {
                            if (loading == 1.0) {
                                itemImageBackground.visible = false;
                                itemImage.visible = true;

                                // show play button if video
                                if (ListItemData.mediaData.mediaType == "video") {
                                    itemVideoPlay.visible = true;
                                }
                            }
                        }

                        // url is given by the data model
                        url: ListItemData.mediaData.mediaThumbnailUrl
                    }

                    // play button
                    // this is set visible if the gallery item is a video
                    ImageView {
                        id: itemVideoPlay

                        // position and layout properties
                        verticalAlignment: VerticalAlignment.Center
                        horizontalAlignment: HorizontalAlignment.Center
                        imageSource: "asset:///images/icons/icon_play_white_background.png"
                        opacity: 0.5

                        // set initial visibility to false
                        visible: false
                    }

                    // standard grey image substitute
                    // the component will be set invisible when loading is finished
                    Container {
                        id: itemImageBackground

                        // position and layout properties
                        verticalAlignment: VerticalAlignment.Fill
                        horizontalAlignment: HorizontalAlignment.Fill
                        layoutProperties: StackLayoutProperties {
                            spaceQuota: 1.0
                        }

                        // background color as defined in shared globals
                        background: Color.create(Globals.instagoListItemBackgroundColor)
                    }

                    // tap handling
                    // if item is tapped, change opacity
                    ListItem.onActivationChanged: {
                        if (active) {
                            itemImage.opacity = 0.75
                        } else {
                            itemImage.opacity = 1.0
                        }
                    }
                }
            }
        ]

        // add action for tap on item
        onTriggered: {
            var currentItemData = thumbnailGalleryDataModel.data(indexPath);

            // send item clicked event
            thumbnailGalleryComponent.itemClicked(currentItemData.mediaData);
        }

        // add action for loading additional data after scrolling to bottom
        attachedObjects: [
            ListScrollStateHandler {
                id: scrollStateHandler
                onAtBeginningChanged: {
                    if (scrollStateHandler.atBeginning) {
                        thumbnailGalleryComponent.listTopReached();
                    }
                }
                onAtEndChanged: {
                    if (scrollStateHandler.atEnd) {
                        thumbnailGalleryComponent.listBottomReached();
                    }
                }
                onScrollingChanged: {
                    if (! scrollStateHandler.atBeginning) {
                        thumbnailGalleryComponent.listIsScrolling();
                    }
                }
            }
        ]
    }

    // attached objects
    attachedObjects: [
        // this will be the data model for the popular media list view
        GroupDataModel {
            id: thumbnailGalleryDataModel
            sortedAscending: false
            sortingKeys: [ listSortingKey ]

            // items are grouped by the view and transformators
            // no need to set a behaviour by the data model
            grouping: ItemGrouping.None
        }
    ]
}
