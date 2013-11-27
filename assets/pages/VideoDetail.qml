// *************************************************** //
// Video Detail Page
//
// The video detail page is shown when a specific
// Instagram video is displayed.
// The page has a number of video player related
// features.
// *************************************************** //

// import blackberry components
import bb.cascades 1.2
import bb.multimedia 1.0

// set import directory for components
import "../components"

// shared js files
import "../global/globals.js" as Globals
import "../global/copytext.js" as Copytext

Page {
    id: videoDetailPage
    // objectName: "videoDetailPage"

    // property containing the media data
    // this is filled by the calling page
    // image data is of type InstagramMediaData()
    property variant mediaData

    // flag if the video is currently playing
    // will be set and used by the video player
    property bool videoIsPlaying

    // content container
    Container {
        // layout orientation
        layout: DockLayout {
        }

        // video container
        Container {
            id: videoContainer

            // layout definition
            background: Color.Black
            horizontalAlignment: HorizontalAlignment.Center
            verticalAlignment: VerticalAlignment.Center

            attachedObjects: [
                // media player component
                // this is the master control element for the video player
                MediaPlayer {
                    id: videoDetailPlayer

                    // binding outut windows to player
                    videoOutput: VideoOutput.PrimaryDisplay
                    windowId: videoPlayerForeignWindow.windowId

                    // player media state has changed
                    // this is thrown when the player itself changed the playing state
                    onMediaStateChanged: {
                        // player is started and playing
                        // changing controls accordingly
                        if (videoDetailPlayer.mediaState == MediaState.Started) {
                            playButton.imageSource = "asset:///images/icons/icon_pause.png"
                            playButton.title = "Pause";
                        }

                        // player paused
                        // changing controls accordingly
                        if (videoDetailPlayer.mediaState == MediaState.Paused) {
                            playButton.imageSource = "asset:///images/icons/icon_play.png";
                            playButton.title = "Play";
                        }

                        // player stopped
                        // changing controls accordingly
                        if (videoDetailPlayer.mediaState == MediaState.Stopped) {
                            playButton.imageSource = "asset:///images/icons/icon_reload.png"
                            playButton.title = "Replay";
                        }
                    }

                    // player buffer state has changed
                    // this is thrown when the video is buffering / loading
                    onBufferStatusChanged: {
                        if (videoDetailPlayer.bufferStatus == BufferStatus.Buffering) {
                            // show the loading indicator when loading started
                            loadingIndicator.showLoader("");
                            console.log("# Video buffering status Buffering");
                        } else if (videoDetailPlayer.bufferStatus == BufferStatus.Playing) {
                            // hide the loading indictor when loading is complete
                            loadingIndicator.hideLoader();
                            videoDetailPreviewImage.visible = false;
                            console.log("# Video buffering status Playing");
                        } else if (videoDetailPlayer.bufferStatus == BufferStatus.Idle) {
                            loadingIndicator.hideLoader();
                            console.log("# Video buffering status Idle");
                        }
                    }
                }
            ]

            ForeignWindowControl {
                id: videoPlayerForeignWindow
                windowId: "videoPlayerForeignWindow"

                // position and layout properties
                updatedProperties: WindowProperty.Size | WindowProperty.Position | WindowProperty.Visible
                horizontalAlignment: HorizontalAlignment.Center

                // layout definition
                preferredHeight: DisplayInfo.width - 10
                preferredWidth: DisplayInfo.width - 10
                visible: true
                opacity: 1.0

                layoutProperties: StackLayoutProperties {
                }
            }
        }

        // the actual thumbnail image
        InstagramImageView {
            id: videoDetailPreviewImage

            // position and layout properties
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Center

            // set initial visibility to true
            // as this is the preview image it will be hidden when the player is started
            visible: true

            onLoadProgressChanged: {
                if ((loadProgress == 1) && (videoIsPlaying == false)) {
                    videoIsPlaying = true;
                    videoDetailPlayer.play();
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
    
    // new data was set by calling page
    // load data into preview image and player
    onMediaDataChanged: {
        videoIsPlaying = false;
        videoDetailPreviewImage.url = mediaData.mediaStandardImage;
        videoDetailPlayer.sourceUrl = mediaData.mediaStandardVideo;

        // show initial loading indicator
        loadingIndicator.showLoader("");
    }
    
    actions: [
        ActionItem {
            id: playButton
            
            imageSource: "asset:///images/icons/icon_reload.png"
            ActionBar.placement: ActionBarPlacement.OnBar
            title: "Loading"
            
            onTriggered: {
                videoPlayerForeignWindow.visible = true;
                videoDetailPreviewImage.visible = false;
                
                if (videoDetailPlayer.mediaState == MediaState.Started) {
                    videoDetailPlayer.pause();
                } else {
                    videoDetailPlayer.play();
                }
            }
        }
    ]    
}