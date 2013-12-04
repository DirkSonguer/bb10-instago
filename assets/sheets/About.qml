// *************************************************** //
// About Sheet
//
// The about sheet shows a description text for Instago
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

        ScrollView {
            // only vertical scrolling is needed
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

                // contact invocation trigger
                CustomButton {
                    narrowText: "Contact me"

                    // layout definition
                    preferredWidth: DisplayInfo.width
                    topMargin: 30

                    onClicked: {
                        emailInvocation.query.uri = "mailto:appworld@songuer.de?subject=Instago Feedback";
                        emailInvocation.query.updateQuery();
                    }
                }

                // introduction trigger
                CustomButton {
                    narrowText: "Show introduction"
                    
                    // layout definition
                    preferredWidth: DisplayInfo.width
                    topMargin: 1
                    
                    onClicked: {
                        aboutSheet.close();
                        
                        var introductionPage = introductionComponent.createObject();
                        introductionSheet.setContent(introductionPage);
                        introductionSheet.open();
                    }
                }

                // bugreport invocation trigger
                CustomButton {
                    narrowText: "Report a bug"

                    // layout definition
                    preferredWidth: DisplayInfo.width
                    topMargin: 1

                    onClicked: {
                        bugReportInvocation.trigger("bb.action.OPEN");
                    }
                }
            }
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

    // invocation for opening browser
    attachedObjects: [
        // bug report invocation
        Invocation {
            id: bugReportInvocation
            query {
                InvokeQuery {
                    mimeType: "text/html"
                    uri: "https://github.com/DirkSonguer/InstagoBB10/issues"
                    invokeActionId: "bb.action.OPEN"
                }
            }
        },
        // contact invocation
        Invocation {
            id: emailInvocation
            query.mimeType: "text/plain"
            query.invokeTargetId: "sys.pim.uib.email.hybridcomposer"
            query.invokeActionId: "bb.action.SENDEMAIL"
            onArmed: {
                emailInvocation.trigger(emailInvocation.query.invokeActionId);
            }
        }
    ]
}
