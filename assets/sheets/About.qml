// *************************************************** //
// About Sheet
//
// The about sheet hows a description text for Instago
// defined in the copytext file.
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
    // id: aboutSheet
    
    Container {
        // layout orientation
        layout: DockLayout {
        }
        
        InfoMessage {
            id: infoMessage
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Center
        }
    }
    
    onCreationCompleted: {
        infoMessage.showMessage(Copytext.instagoAboutBody, Copytext.instagoAboutHeadline);
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
                aboutSheet.close();
            }
        }
    ]    
}
