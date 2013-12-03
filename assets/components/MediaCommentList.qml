// *************************************************** //
// Media Comment List Component
//
// This component shows a list of comments for a given
// media item.
//
// Author: Dirk Songuer
// License: GPL v2
// See: http://choosealicense.com/licenses/gpl-v2/
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

    // signal that comment has been added
    // note that the actual logic is done by the component
    signal commentAdded()

    // signal if item was clicked
    signal itemClicked(variant commentData)
    
    // signal if user was clicked
    signal profileClicked(variant userData)

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

    // properties for the headline
    property alias headerText: mediaCommentHeader.headline
    property alias headerImage: mediaCommentHeader.image

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

    // this is a workaround to make the signals visible inside the listview item scope
    // see here for details: http://supportforums.blackberry.com/t5/Cascades-Development/QML-Accessing-variables-defined-outside-a-list-component-from/m-p/1786265#M641
    onCreationCompleted: {
        Qt.fullDisplaySize = DisplayInfo.width;
        Qt.itemClicked = mediaCommentListComponent.itemClicked;
        Qt.profileClicked = mediaCommentListComponent.profileClicked;

        if (mediaCommentListComponent.headerText != "") {
            mediaCommentList.scrollToPosition(0, ScrollAnimation.None);
            mediaCommentList.scroll(-205, ScrollAnimation.Smooth);
        }
    }

    // layout orientation
    layout: DockLayout {
    }

    // list of Instagram popular media
    ListView {
        id: mediaCommentList

        // associate the data model for the list view
        dataModel: mediaCommentListDataModel

        leadingVisual: Container {
            id: mediaCommentHeaderContainer

            // layout orientation
            layout: StackLayout {
                orientation: LayoutOrientation.TopToBottom
            }

            // layout definition
            bottomPadding: 5

            // set initial visibility to false
            // will be set true when the headline is added
            visible: false

            // likes header
            PageHeader {
                id: mediaCommentHeader

                // layout definition
                bottomPadding: 5

                // set initial visibility to false
                // will be set true when the headline is added
                visible: false

                // make header component visible when content is added
                onHeadlineChanged: {
                    mediaCommentHeader.visible = true;
                    mediaCommentHeaderContainer.visible = true;
                }
            }

            // comment input container
            CommentInput {
                id: mediaCommentsInput

                // add comment signal
                onCommentAdded: {
                    mediaCommentListComponent.commentAdded();
                    mediaCommentsInput.visible = true;
                }
            }
        }

        // layout orientation
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

                    // layout orientation
                    layout: DockLayout {
                    }

                    // item positioning
                    verticalAlignment: VerticalAlignment.Fill
                    horizontalAlignment: HorizontalAlignment.Fill

                    // layout definition
                    topMargin: 1

                    MediaDescription {
                        // layout definition
                        preferredWidth: Qt.fullDisplaySize
                        minWidth: Qt.fullDisplaySize

                        // image description (profile picture, name and image description)
                        userimage: ListItemData.commentData.userData.profilePicture
                        username: ListItemData.commentData.userData.username
                        imagecaption: ListItemData.commentData.text

                        // show only one line of the caption
                        captionMultiline: true
                        
                        onProfileClicked: {
                            // send user clicked event
                            Qt.profileClicked(ListItemData.commentData.userData);
                        }
                        
                        onDescriptionClicked: {
                            // send item clicked event
                            Qt.itemClicked(ListItemData.commentData);
                        }
                    }
                }
            }
        ]

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
