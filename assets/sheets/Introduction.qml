// *************************************************** //
// Introduction Sheet
//
// The introduction sheet shows an intro image on first
// start of the application.
//
// Author: Dirk Songuer
// License: GPL v2
// See: http://choosealicense.com/licenses/gpl-v2/
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
        // layout orientation
        layout: DockLayout {
        }

        ScrollView {
            // only vertical scrolling is needed
            scrollViewProperties {
                scrollMode: ScrollMode.Vertical
                pinchToZoomEnabled: false
            }

            ImageView {
                id: introductionImage

                // set width to full screen width
                preferredWidth: DisplayInfo.width

                // introduction is just an image
                imageSource: "asset:///images/instago_introduction.jpg"
            }
        }
    }

    // close action for the sheet
    actions: [
        ActionItem {
            title: "Close"
            ActionBar.placement: ActionBarPlacement.OnBar
            imageSource: "asset:///images/icons/icon_close.png"

            // close sheet when pressed
            // note that the sheet is defined in the main.qml
            onTriggered: {
                introductionSheet.close();
            }
        }
    ]
}
