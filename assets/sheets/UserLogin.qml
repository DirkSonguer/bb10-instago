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
import "../global/instagramkeys.js" as InstagramKeys
import "../classes/authenticationhandler.js" as Authentication
import "../classes/loginuihandler.js" as LoginUIHandler

Page {
    id: userLoginSheet

    // property flag to check if authentication process has been done
    property bool authenticationDone: false

    Container {
        // layout orientation
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

                onLoadProgressChanged: {
                    if ((loadProgress < 100) && (! loadingIndicator.loaderActive)) {
                        // console.log("# Loading process started");
                        loginInstagramWebView.visible = false
                        loadingIndicator.showLoader("Loading login process");
                    }
                }

                // if loading state has changed, check for current state
                // if web view is loading, show activity indicator
                onLoadingChanged: {
                    if (loadRequest.status == WebLoadStatus.Succeeded) {
                        // console.log("# Loading process done");
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
                        // console.log("# Authentication failed: " + instagramResponse["status"]);

                        loginInstagramWebView.visible = false
                        var errorMessage = loginErrorText.text += "Instagram says: " + instagramResponse["error_description"] + "(" + instagramResponse["status"] + ")";
                        infoMessage.showMessage(errorMessage, Copytext.insagoLoginErrorTitle);
                        authenticationDone = false;
                    }

                    // show the success message if the Instagram authentication was ok
                    if (instagramResponse["status"] === "AUTH_SUCCESS") {
                        // console.log("# Authentication successful: " + instagramResponse["status"]);

                        // show confirmation
                        loginInstagramWebView.visible = false
                        loadingIndicator.hideLoader();
                        infoMessage.showMessage(Copytext.instagoLoginSuccessMessage, Copytext.instagoLoginSuccessTitle);
                        authenticationDone = true;

                        // activate tabs that are authenticated only
                        LoginUIHandler.loginUIHandler.setLoggedInState();
                    }
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

    onCreationCompleted: {
        loadingIndicator.showLoader("Loading login process");
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
                loginSheet.close();

                if (authenticationDone) {
                    // reload profile page to login notification
                    profileComponent.source = "../pages/UserProfile.qml"
                    var profilePage = profileComponent.createObject();
                    profileTab.setContent(profilePage);
                }
            }
        }
    ]
}
