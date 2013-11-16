// *************************************************** //
// User Login Page
//
// This page is used when the user is not logged in.
// It shows the login notification as well as a button
// to start the login process (via the login sheet).
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

    // content container
    Container {
        // layout orientation
        layout: DockLayout {
        }

        // actual content
        // note shown when the user is not logged in
        // this contains the button to open the login sheet
        Container {
            // layout definition
            horizontalAlignment: HorizontalAlignment.Left
            verticalAlignment: VerticalAlignment.Center

            // login headline
            Container {
                leftPadding: 10
                Label {
                    text: qsTr("Login required")
                    textStyle.base: SystemDefaults.TextStyles.BigText
                    textStyle.fontWeight: FontWeight.W500
                    textStyle.textAlign: TextAlign.Left
                }
            }

            // login detail text
            Container {
                leftPadding: 15
                rightPadding: 15
                Label {
                    text: qsTr(Copytext.instagoLoginBody)
                    textStyle.base: SystemDefaults.TextStyles.BodyText
                    textStyle.fontWeight: FontWeight.W100
                    textStyle.textAlign: TextAlign.Left
                    multiline: true
                }
            }

            // login button
            Button {
                id: userProfileLoginButton
                text: "Login"
                topMargin: 25
                horizontalAlignment: HorizontalAlignment.Center
                verticalAlignment: VerticalAlignment.Center
                onClicked: {
                    // create login sheet
                    var loginPage = loginComponent.createObject();
                    loginSheet.setContent(loginPage);
                    loginSheet.open();
                }
            }
        }
    }
}