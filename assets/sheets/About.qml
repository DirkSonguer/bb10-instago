// *************************************************** //
// About Sheet
//
// The user logout sheet uses a webview to trigger the
// logout functionality of Instagram. The platform will
// invalidate the session keys accordingly.
// *************************************************** //

// import blackberry components
import bb.cascades 1.2

// set import directory for components
import "../components"

// shared js files
import "../global/globals.js" as Globals
import "../global/copytext.js" as Copytext
import "../classes/authenticationhandler.js" as Authentication

Page {
    // id: aboutSheet
    
    Container {
        // layout definition
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
