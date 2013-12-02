// *************************************************** //
// Comment Preview Component
//
// This component shows a list of comment previews with
// user and comment message
// This component accepts an array of data of type
// InstagramCommentData
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
import "../instagramapi/media.js" as MediaRepository

// import timer type
import QtTimer 1.0

// import image url loader component
import WebImageView 1.0

Container {
    id: commentPreviewComponent

    // property that holds the current index
    // this is incremented as new items are added
    // to the list a provides the order the items were
    // added to the data model
    property int currentItemIndex: 0

    // the media id is needed to update the comment data
    property string mediaId

    // signal to show that component has been clicked
    signal clicked()

    // signal if comment data loading is complete
    signal mediaCommentsLoaded(variant commentDataArray)

    // signal if comment data loading encountered an error
    signal mediaCommentsError(variant errorData)

    // update data
    signal update()
    onUpdate: {
        // clear the list in case the list was reloaded
        commentPreviewDataModel.clear();

        // start the timer
        // this basically waits a second and then reloads the comment list
        commentPreviewTimer.start();
    }

    // signal to clear the gallery contents
    signal clearList()
    onClearList: {
        commentPreviewDataModel.clear();
    }

    // signal to add a new item
    // item is given as type InstagramCommentData
    signal addToList(variant item)
    onAddToList: {
        // console.log("# Adding new comment items " + item.length);

        // iterate through data objects
        for (var index in item) {
            if (index > (item.length - 9)) {
                commentPreviewComponent.currentItemIndex += 1;
                commentPreviewDataModel.insert({
                        "commentData": item[index],
                        "currentIndex": commentPreviewComponent.currentItemIndex
                    });
            }
        }
    }

    // background color definition
    background: Color.create(Globals.instagoDefaultBackgroundColor)

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

                    // layout orientation
                    layout: StackLayout {
                        orientation: LayoutOrientation.LeftToRight
                    }

                    // layout definition
                    topPadding: 20
                    leftPadding: 30
                    rightPadding: 10

                    Container {
                        // layout orientation
                        layout: DockLayout {
                        }

                        // profile image
                        // this is a web image view provided by WebViewImage
                        WebImageView {
                            id: commentPreviewProfileImage

                            // align the image in the center
                            verticalAlignment: VerticalAlignment.Center
                            horizontalAlignment: HorizontalAlignment.Left

                            url: ListItemData.commentData.userData.profilePicture

                            // set image size to small profile icons
                            preferredHeight: 50
                            preferredWidth: 50
                            minHeight: 50
                            minWidth: 50
                        }

                        // mask the profile image to make it round
                        ImageView {
                            id: commentPreviewProfileMask

                            // position and layout properties
                            verticalAlignment: VerticalAlignment.Center
                            horizontalAlignment: HorizontalAlignment.Left

                            // set image size to maximum screen size
                            // this will be either 768x768 (Z10) or 720x720 (all others)
                            preferredHeight: 50
                            preferredWidth: 50
                            minHeight: 50
                            minWidth: 50

                            imageSource: "asset:///images/mask_profile_pictures_default.png"
                        }
                    }

                    // image caption
                    Label {
                        id: itemCaption
                        textStyle.base: SystemDefaults.TextStyles.BodyText
                        textStyle.fontWeight: FontWeight.W100
                        textStyle.textAlign: TextAlign.Left
                        text: ListItemData.commentData.text
                    }
                }
            }
        ]
    }

    // comment data was loaded successfully
    // data is stored in "commentDataArray" variant as array of type InstagramCommentData
    onMediaCommentsLoaded: {
        commentPreviewComponent.addToList(commentDataArray);
    }

    // handle ui touch elements
    onTouch: {
        // user pressed description
        if (event.touchType == TouchType.Down) {
            // commentPreviewComponent.background = Color.create(Globals.instagoHighlightBackgroundColor);
        }

        // user released description or is moving
        if ((event.touchType == TouchType.Up) || (event.touchType == TouchType.Cancel)) {
            // commentPreviewComponent.background = Color.create(Globals.instagoDefaultBackgroundColor);
        }
    }
    
    // TODO: This does not work for some reason
    // handle tap on comment preview component
    gestureHandlers: [
        TapHandler {
            onTapped: {
                commentPreviewComponent.clicked();
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
        },
        // timer component
        // used to delay reload after commenting
        Timer {
            id: commentPreviewTimer
            interval: 1000
            singleShot: true

            // when triggered, reload the comment data
            onTimeout: {
                // load comments for given media item
                MediaRepository.getComments(commentPreviewComponent.mediaId, commentPreviewComponent);
            }
        }
    ]
}
