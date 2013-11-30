// *************************************************** //
// Edit Profile Sheet
//
// The user profile page shows the personal information
// of the currently logged in user.
// If the user is not logged in, then a link to the
// login process is shown.
// *************************************************** //

// import blackberry components
import bb.cascades 1.2

// set import directory for components
import "../components"

// shared js files
import "../global/globals.js" as Globals
import "../global/copytext.js" as Copytext
import "../classes/authenticationhandler.js" as Authentication
import "../classes/loginuihandler.js" as LoginUIHandler

Page {

    Container {
        // layout orientation
        layout: DockLayout {
        }

        ScrollView {
            id: editProfileWebViewScrollContainer
            scrollViewProperties {
                scrollMode: ScrollMode.Vertical
                pinchToZoomEnabled: false
            }

            // web view
            // browser window showing the Instagram authentication process
            WebView {
                id: editProfileWebView
                url: "https://instagram.com/accounts/edit/"
                horizontalAlignment: HorizontalAlignment.Center
                verticalAlignment: VerticalAlignment.Center
                visible: false

                // if loading state has changed, check for current state
                // if web view is loading, show activity indicator
                onLoadingChanged: {
                    if (loadRequest.status == WebLoadStatus.Started) {
                        editProfileWebView.visible = false
                        loadingIndicator.showLoader("");
                    } else {
                        loadingIndicator.hideLoader();
                        editProfileWebView.visible = true;
                    }
                }

                // check on every page load if the oauth token is in it
                onNavigationRequested: {
                    // console.log("# New URL requested: " + request.url);
                    if ((request.url != "https://instagram.com/accounts/edit/") && (request.url != "https://instagram.com/accounts/password/change/") && (request.url != "https://instagram.com/accounts/manage_access")) {
                        // user navigated away from the edit user profile page
                        mainTabbedPane.activeTab = personalFeedTab;
                        editProfileSheet.close();
                    }

                    // check if user clicked logout
                    // if so, do the ususal logout routine
                    if (request.url == "https://instagram.com/accounts/logout/") {
                        // delete the stored user data of the user from the database
                        Authentication.auth.deleteStoredInstagramData();

                        // remove tabs and menu items that are authenticated only
                        LoginUIHandler.loginUIHandler.setLoggedOutState();

                        // change current tab to profile tab
                        popularMediaTab.triggered();

                        // close current sheet
                        editProfileSheet.close();

                        // create logout sheet
                        var logoutPage = logoutComponent.createObject();
                        logoutSheet.setContent(logoutPage);
                        logoutSheet.open();
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
        loadingIndicator.showLoader("Loading profile");
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
                editProfileSheet.close();
            }
        }
    ]
}
