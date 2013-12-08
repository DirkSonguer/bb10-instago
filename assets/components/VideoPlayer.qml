// *************************************************** //
// Instagram Image View Component
//
// This component shows an image based on
// InstagramMediaData objects
// It also handles the grey backgrounds while loading
// as well as the video indicator and touch events
//
// Author: Dirk Songuer
// License: GPL v2
// See: http://choosealicense.com/licenses/gpl-v2/
// *************************************************** //

// import blackberry components
import bb.cascades 1.2
import bb.multimedia 1.0

// shared js files
import "../global/globals.js" as Globals
import "../global/copytext.js" as Copytext

// import image url loader component
import WebImageView 1.0

Container {
    id: videoPlayerComponent

    // signal if video was tapped
    signal imageClicked()

    // signal that video should be played
    signal playVideo()

    // property containing the video URL
    property alias videoSource: videoPlayer.sourceUrl

    // flag if the video is currently playing
    // will be set and used by the video player
    property bool videoIsPlaying

    // flag if the video is currently paused
    // will be set and used by the video player
    property bool videoIsPaused

    // property to hold the loading progress
    property alias bufferStatus: videoPlayer.bufferStatus

    // property that defines the size of the video
    // this is the device screen width by default
    // so either 768x768 (Z10) or 720x720 (all others)
    property int videoSize: DisplayInfo.width

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
                    id: videoPlayer

                    // binding outut windows to player
                    videoOutput: VideoOutput.PrimaryDisplay
                    windowId: videoPlayerForeignWindow.windowId

                    // player media state has changed
                    // this is thrown when the player itself changed the playing state
                    onMediaStateChanged: {
                        // player is started and playing
                        // changing controls accordingly
                        if (videoPlayer.mediaState == MediaState.Started) {
                            // console.log("# Video player started");
                            videoPlayerComponent.videoIsPaused = false;
                            videoPlayerComponent.videoIsPlaying = true;
                            videoPlayButton.visible = false;
                        }

                        // player paused
                        // changing controls accordingly
                        if (videoPlayer.mediaState == MediaState.Paused) {
                            videoPlayerComponent.videoIsPaused = true;
                            videoPlayerComponent.videoIsPlaying = false;
                            videoPlayButton.visible = true;
                        }

                        // player stopped
                        // changing controls accordingly
                        if (videoPlayer.mediaState == MediaState.Stopped) {
                            videoPlayerComponent.videoIsPaused = false;
                            videoPlayerComponent.videoIsPlaying = false;
                            videoPlayButton.visible = true;
                        }
                    }

                    // player buffer state has changed
                    // this is thrown when the video is buffering / loading
                    onBufferStatusChanged: {
                        if (videoPlayer.bufferStatus == BufferStatus.Buffering) {
                            // show the loading indicator when loading started
                            // console.log("# Video buffering status Buffering");
                            loadingIndicator.showLoader("");
                        } else if (videoPlayer.bufferStatus == BufferStatus.Playing) {
                            // hide the loading indictor when loading is complete
                            // console.log("# Video buffering status Playing");
                            loadingIndicator.hideLoader();
                        } else if (videoPlayer.bufferStatus == BufferStatus.Idle) {
                            // hide the loader when video player is idle
                            // console.log("# Video buffering status Idle");
                            loadingIndicator.hideLoader();
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

                // set the image size according to imageSize property
                preferredHeight: videoPlayerComponent.videoSize
                preferredWidth: videoPlayerComponent.videoSize
                minHeight: videoPlayerComponent.videoSize
                minWidth: videoPlayerComponent.videoSize
                visible: true
                opacity: 1.0

                layoutProperties: StackLayoutProperties {
                }
            }
        }

        // play button
        // this is set visible if the video is stopped
        ImageView {
            id: videoPlayButton

            // position and layout properties
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Center
            imageSource: "asset:///images/icons/icon_play_white_background.png"
            opacity: 0.5

            // set initial visibility to false
            visible: false
        }

        LoadingIndicator {
            id: loadingIndicator
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Center
        }

        // handle tap on player
        gestureHandlers: [
            // Add a handler for single tap gesture
            TapHandler {
                onTapped: {
                    if (videoPlayerComponent.videoIsPlaying) {
                        videoPlayer.stop();
                    } else {
                        // console.log("# Sending play() signal to video player");
                        loadingIndicator.showLoader("");
                        videoPlayer.play();
                    }
                }
            }
        ]
    }
    
    // start loader on creation
    onCreationCompleted: {
        loadingIndicator.showLoader("Loading video");
    }

    // play video
    onPlayVideo: {
        if ((videoPlayer.sourceUrl != "") && (videoIsPlaying == false)) {
            // console.log("# Sending play() signal to video player");

            // show initial loading indicator
            // will be changed by video player according to buffer state
            loadingIndicator.showLoader("");

            // play video
            videoPlayer.play();
        }
    }
}