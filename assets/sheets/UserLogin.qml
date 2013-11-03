// *************************************************** //
// User Login Sheet
//
// The user login sheet uses a webview to show the login
// process of Instagram.
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
    id: userLoginSheet

    // property flag to check if authentication process has been done
    property bool authenticationDone: false

    Container {
        // layout definition
        layout: DockLayout {
        }

        // scroll view as the Instagram login pages
        // do not fit on the Q10 / Q5 screen
        ScrollView {
            // only vertical scrolling is needed
            scrollViewProperties {
                scrollMode: ScrollMode.Vertical
                pinchToZoomEnabled: false
            }

            // web view
            // browser window showing the Instagram authentication process
            WebView {
                id: loginInstagramWebView

                // url is the entry point for the Instagram login process
                // has to be called with the public Instagram app key and a valid callback URL
                // requested rights are likes, comments, relationships
                url: InstagramKeys.instagramkeys.instagramTokenRequestUrl + "/?client_id=" + InstagramKeys.instagramkeys.instagramClientId + "&redirect_uri=" + InstagramKeys.instagramkeys.instagramRedirectUrl + "&response_type=token&scope=likes+comments+relationships"

                // layout definition
                horizontalAlignment: HorizontalAlignment.Center
                verticalAlignment: VerticalAlignment.Center

                // set initial visibility to false
                visible: false

                // if loading state has changed, check for current state
                // if web view is loading, show activity indicator
                onLoadingChanged: {
                    if (loadRequest.status == WebLoadStatus.Started) {
                        loginInstagramWebView.visible = false
                        loadingIndicator.showLoader("Loading Instagram login process");
                    } else {
                        loadingIndicator.hideLoader();
                        if (! authenticationDone) {
                            loginInstagramWebView.visible = true
                        }
                    }
                }

                // check on every page load if the oauth token is in it
                onUrlChanged: {
                    // console.log("# Authentication URL changed: " + url);
                    var instagramResponse = new Array();
                    instagramResponse = Authentication.auth.checkInstagramAuthenticationUrl(url);

                    // show the error message if the Instagram authentication was not successfull
                    if (instagramResponse["status"] === "AUTH_ERROR") {
                        // console.log("# Authentication went wrong: " + instagramResponse["status"]);
                        // loginErrorContainer.visible = true;
                        // loginErrorText.text += "Instagram says: " + instagramResponse["error_description"];
                        authenticationDone = false;
                    }

                    // show the success message if the Instagram authentication was ok
                    if (instagramResponse["status"] === "AUTH_SUCCESS") {
                        // console.log("# Authentication successful: " + instagramResponse["status"]);

                        // changing views to login notification
                        // loginInstagramWebView.visible = false
                        // loginSuccessContainer.visible = true;
                        authenticationDone = true;
                        /*
                         * // changing available menu items
                         * mainMenu.removeAction(mainMenuAbout);
                         * mainMenu.removeAction(mainMenuRate);
                         * mainMenu.removeAction(mainMenuNews);
                         * mainMenu.addAction(mainMenuLogout);
                         * mainMenu.addAction(mainMenuAbout);
                         * mainMenu.addAction(mainMenuRate);
                         * mainMenu.addAction(mainMenuNews);
                         * 
                         * // changing available tabs
                         * mainTabbedPane.remove(popularMediaTab);
                         * mainTabbedPane.remove(profileTab);
                         * mainTabbedPane.add(personalFeedTab);
                         * mainTabbedPane.add(popularMediaTab);
                         * // mainTabbedPane.add(newsFeedTab);
                         * mainTabbedPane.add(searchTab);
                         * mainTabbedPane.add(nearbyLocationTab);
                         * mainTabbedPane.add(profileTab);
                         * mainTabbedPane.activeTab = popularMediaTab;
                         */
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
}
