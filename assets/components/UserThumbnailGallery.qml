// *************************************************** //
// User Thumbnail Gallery Component
//
// This component shows a gallery of thumbnails with an
// optional text field
// This component accepts data of type InstagramMediaData
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
    id: userThumbnailGalleryComponent

    // signal if gallery is scrolled to start or end
    signal listBottomReached()
    signal listTopReached()
    signal listIsScrolling()

    // property that holds the id of the next image
    // this is given by Instagram for easy pagination
    property string cursorId: ""

    // property that holds the current index
    // this is incremented as new items are added
    // to the list a provides the order the items were
    // added to the data model
    property int currentItemIndex: 0

    // properties to define how the list should be sorted
    property string listSortingKey: "timestamp"
    property alias listSortAscending: userThumbnailGalleryDataModel.sortedAscending

    // properties for the headline
    property alias headerText: userThumbnailHeader.headline
    property alias headerImage: userThumbnailHeader.image

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
        Qt.thirdDisplaySize = Math.round(DisplayInfo.width / 3);

        if (userThumbnailGalleryComponent.headerText != "") {
            userThumbnailGallery.scrollToPosition(0, ScrollAnimation.None);
            userThumbnailGallery.scroll(-105, ScrollAnimation.Smooth);
        }
    }

    // layout orientation
    layout: DockLayout {
    }

    // list of Instagram popular media
    ListView {
        id: userThumbnailGallery

        // associate the data model for the list view
        dataModel: userThumbnailGalleryDataModel

        leadingVisual: Container {
            id: userThumbnailHeaderContainer

            // set initial visibility to false
            // will be set true when the headline is added
            visible: false

            // likes header
            PageHeader {
                id: userThumbnailHeader

                // layout definition
                bottomPadding: 5

                // set initial visibility to false
                // will be set true when the headline is added
                visible: false

                // make header component visible when content is added
                onHeadlineChanged: {
                    userThumbnailHeader.visible = true;
                    userThumbnailHeaderContainer.visible = true;
                }
            }
        }

        // layout orientation
        layout: GridListLayout {
            orientation: LayoutOrientation.TopToBottom
            columnCount: 3
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
                        imageSize: Qt.thirdDisplaySize
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
                        preferredHeight: Qt.thirdDisplaySize
                        preferredWidth: Qt.thirdDisplaySize
                        minHeight: Qt.thirdDisplaySize
                        minWidth: Qt.thirdDisplaySize

                        imageSource: "asset:///images/mask_profile_pictures_default.png"
                    }

                    // image description
                    // dark gray container containing the text
                    Container {
                        // layout definition
                        verticalAlignment: VerticalAlignment.Bottom
                        preferredWidth: Qt.thirdDisplaySize
                        minWidth: Qt.thirdDisplaySize
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
                            textStyle.base: SystemDefaults.TextStyles.SmallText
                            textStyle.fontWeight: FontWeight.W100
                            textStyle.textAlign: TextAlign.Left
                        }
                    }

                    // tap handling
                    // if item is tapped, change opacity
                    ListItem.onActivationChanged: {
                        if (active) {
                            // set opacity to transparent, image wil lfade into the background
                            itemImage.opacity = 0.5;

                            // set size so that image gets smaller on press
                            itemImage.imageSize = Qt.thirdDisplaySize - 5;
                            imageDescriptionMask.preferredHeight = Qt.thirdDisplaySize - 5;
                            imageDescriptionMask.preferredWidth = Qt.thirdDisplaySize - 5;
                            imageDescriptionMask.minHeight = Qt.thirdDisplaySize - 5;
                            imageDescriptionMask.minWidth = Qt.thirdDisplaySize - 5;
                        } else {
                            // reset opacity to normal
                            itemImage.opacity = 1.0;

                            // set size so that image resets to normal on release
                            itemImage.imageSize = Qt.thirdDisplaySize;
                            imageDescriptionMask.preferredHeight = Qt.thirdDisplaySize;
                            imageDescriptionMask.preferredWidth = Qt.thirdDisplaySize;
                            imageDescriptionMask.minHeight = Qt.thirdDisplaySize;
                            imageDescriptionMask.minWidth = Qt.thirdDisplaySize;
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
