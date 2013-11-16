// *************************************************** //
// News Sheet
//
// The news sheet shows a webview with the Instago news
// blog.
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

        ScrollView {
            id: newsWebViewScrollContainer
            scrollViewProperties {
                scrollMode: ScrollMode.Vertical
                pinchToZoomEnabled: false
            }

            // web view
            // browser window showing the Instago news blog
            WebView {
                id: newsWebView
                url: Globals.instagoNewsURL
                horizontalAlignment: HorizontalAlignment.Center
                verticalAlignment: VerticalAlignment.Center
                visible: false

                onLoadProgressChanged: {
                    if (loadProgress < 100) {
                        newsWebView.visible = false;
                        loadingIndicator.showLoader("Loading Instago news");
                    } else {
                        loadingIndicator.hideLoader();
                        newsWebView.visible = true;
                    }
                }
            }
        }

        LoadingIndicator {
            id: loadingIndicator
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Center
        }
    }

    onCreationCompleted: {
        loadingIndicator.showLoader("Loading Instago news");
    }

    // close action for the sheet
    actions: [
        ActionItem {
            title: "Refresh"
            ActionBar.placement: ActionBarPlacement.OnBar
            imageSource: "asset:///images/icons/icon_reload.png"
            
            // reload sheet content when pressed
            onTriggered: {
                newsWebView.url = Globals.instagoNewsURL;
            }
        },
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
