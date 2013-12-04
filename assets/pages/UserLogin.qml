// *************************************************** //
// User Login Page
//
// This page is used when the user is not logged in.
// It shows the login notification as well as a button
// to start the login process (via the login sheet).
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
    id: userLoginPage

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

            Container {
                // layout orientation
                layout: StackLayout {
                    orientation: LayoutOrientation.TopToBottom
                }

                // layout definiton
                verticalAlignment: VerticalAlignment.Center
                horizontalAlignment: HorizontalAlignment.Center
                leftPadding: 10
                rightPadding: 10

                InfoMessage {
                    id: infoMessage

                    leftPadding: 0
                    rightPadding: 0
                }

                CustomButton {
                    narrowText: "Login"

                    // layout definition
                    preferredWidth: DisplayInfo.width
                    topMargin: 30

                    onClicked: {
                        // create login sheet
                        var loginPage = loginComponent.createObject();
                        loginSheet.setContent(loginPage);
                        loginSheet.open();
                    }
                }
            }
        }

        onCreationCompleted: {
            infoMessage.showMessage(Copytext.instagoLoginBody, Copytext.instagoLoginHeadline);
        }
    }
}