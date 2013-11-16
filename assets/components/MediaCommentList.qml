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
    id: mediaCommentListComponent

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
    property alias listSortAscending: mediaCommentListDataModel.sortedAscending

    // signal to clear the gallery contents
    signal clearList()
    onClearList: {
        mediaCommentListDataModel.clear();
    }

    // signal to add a new item
    // item is given as type InstagramCommentData
    signal addToList(variant item)
    onAddToList: {
        // console.log("# Adding item with ID " + item.commentId + " to comment list data model");
        mediaCommentListComponent.currentItemIndex += 1;
        mediaCommentListDataModel.insert({
                "commentData": item,
                "timestamp": item.createdTime,
                "currentIndex": mediaCommentListComponent.currentItemIndex
            });
    }

    // signal if item was clicked
    signal itemClicked(variant userData)

    // this is a workaround to make the signals visible inside the listview item scope
    // see here for details: http://supportforums.blackberry.com/t5/Cascades-Development/QML-Accessing-variables-defined-outside-a-list-component-from/m-p/1786265#M641
    onCreationCompleted: {
        Qt.thumbnailSize = DisplayInfo.width;
    }

    // layout definition
    layout: DockLayout {
    }

    // list of Instagram popular media
    ListView {
        id: mediaCommentList

        // associate the data model for the list view
        dataModel: mediaCommentListDataModel

        // define list layout as grid
        layout: StackListLayout {
            orientation: LayoutOrientation.TopToBottom
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
                    
                    // layout definition
                    topMargin: 1

                    MediaDescription {
                        // layout definition
                        preferredWidth: Qt.thumbnailSize
                        minWidth: Qt.thumbnailSize

                        // image description (profile picture, name and image description)
                        userimage: ListItemData.commentData.userData.profilePicture
                        username: ListItemData.commentData.userData.username
                        imagecaption: ListItemData.commentData.text

                        // show only one line of the caption
                        captionMultiline: true
                    }
                }

                // tap handling
                // if item is tapped, change opacity
                ListItem.onActivationChanged: {
                    if (active) {
                    } else {
                    }
                }
            }
        ]

        // add action for tap on item
        onTriggered: {
        }

        // add action for loading additional data after scrolling to bottom
        attachedObjects: [
            ListScrollStateHandler {
                id: scrollStateHandler
                onAtBeginningChanged: {
                    // console.log("# onAtBeginningChanged");
                    if (scrollStateHandler.atBeginning) {
                        mediaCommentListComponent.listTopReached();
                    }
                }
                onAtEndChanged: {
                    // console.log("# onAtEndChanged");
                    if (scrollStateHandler.atEnd) {
                        mediaCommentListComponent.listBottomReached();
                    }
                }
                onScrollingChanged: {
                    // console.log("# List is scrolling: " + scrollStateHandler.toDebugString());
                    if (! scrollStateHandler.atBeginning) {
                        mediaCommentListComponent.listIsScrolling();
                    }
                }
            }
        ]
    }

    // attached objects
    attachedObjects: [
        // this will be the data model for the popular media list view
        GroupDataModel {
            id: mediaCommentListDataModel
            sortedAscending: false
            sortingKeys: [ listSortingKey ]

            // items are grouped by the view and transformators
            // no need to set a behaviour by the data model
            grouping: ItemGrouping.None
        }
    ]
}
