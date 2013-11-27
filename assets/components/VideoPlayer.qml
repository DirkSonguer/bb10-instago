// *************************************************** //
// Instagram Image View Component
//
// This component shows an image based on
// InstagramMediaData objects
// It also handles the grey backgrounds while loading
// as well as the video indicator and touch events
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
                            playButton.imageSource = "asset:///images/icons/icon_pause.png"
                            playButton.title = "Pause";
                        }
                        
                        // player paused
                        // changing controls accordingly
                        if (videoPlayer.mediaState == MediaState.Paused) {
                            playButton.imageSource = "asset:///images/icons/icon_play.png";
                            playButton.title = "Play";
                        }
                        
                        // player stopped
                        // changing controls accordingly
                        if (videoPlayer.mediaState == MediaState.Stopped) {
                            playButton.imageSource = "asset:///images/icons/icon_reload.png"
                            playButton.title = "Replay";
                        }
                    }
                    
                    // player buffer state has changed
                    // this is thrown when the video is buffering / loading
                    onBufferStatusChanged: {
                        if (videoPlayer.bufferStatus == BufferStatus.Buffering) {
                            // show the loading indicator when loading started
                            loadingIndicator.showLoader("");
                            console.log("# Video buffering status Buffering");
                        } else if (videoPlayer.bufferStatus == BufferStatus.Playing) {
                            // hide the loading indictor when loading is complete
                            loadingIndicator.hideLoader();
                            console.log("# Video buffering status Playing");
                        } else if (videoPlayer.bufferStatus == BufferStatus.Idle) {
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
        
        LoadingIndicator {
            id: loadingIndicator
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Center
        }
    }
    
    // play video
    onPlayVideo: {
        if ((videoPlayer.sourceUrl != "") && (videoIsPlaying == false)) {
            videoIsPlaying = true;
            videoPlayer.play();
        }

        // show initial loading indicator
        loadingIndicator.showLoader("");
    }
}