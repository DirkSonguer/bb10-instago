// *************************************************** //
// This is just a test page
// *************************************************** //

// import blackberry components
import bb.cascades 1.2

// set import directory for components
import "../components"

// shared js files
import "../global/globals.js" as Globals
import "../global/copytext.js" as Copytext

Page {
    Container {

        Container {
            layout: StackLayout {
                orientation: LayoutOrientation.LeftToRight
            }

            LikeButton {
                // position and layout properties
                layoutProperties: StackLayoutProperties {
                    spaceQuota: 1.0
                }

                topMargin: 1
                rightMargin: 1
                
                count: "1024 likes"
            }

            CommentButton {
                // position and layout properties
                layoutProperties: StackLayoutProperties {
                    spaceQuota: 1.0
                }
                
                topMargin: 1
                
                count: "1024 comments"
            }
        }

    }
}
