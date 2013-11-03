// *************************************************** //
// Main
//
// This is the main entry point of the application.
// It provides the main navigation pane, menus and
// the components for the main pages.
// Note that the actual page content is defined in
// the /pages.
// *************************************************** //

// import blackberry components
import bb.cascades 1.2

// set import directory for pages
import "pages"

// shared js files
import "classes/authenticationhandler.js" as Authentication
import "instagramapi/users.js" as UserRepository

TabbedPane {
    id: mainTabbedPane

    // pane definition
    showTabsOnActionBar: true
    activeTab: popularMediaTab

    // tab for popular media page
    // tab is always visible regardless of login state
    Tab {
        id: popularMediaTab
        title: "Popular"
        imageSource: "asset:///images/icons/icon_popular.png"

        // note that the page is bound to the component every time it loads
        // this is because the page needs to be created as tapped
        // if created on startup it does not work immediately after login
        onTriggered: {
            popularMediaComponent.source = "pages/PopularMedia.qml"
            var popularMediaPage = popularMediaComponent.createObject();
            popularMediaTab.setContent(popularMediaPage);

            // reset tab content by resetting the page
            mainTabbedPane.activeTab = profileTab;
            mainTabbedPane.activeTab = popularMediaTab;
        }

        // attach a component for the popular media page
        // this is bound to the content property later on onCreationCompleted()
        attachedObjects: [
            ComponentDefinition {
                id: popularMediaComponent
            }
        ]
    }

    // tab for profile page
    // tab is always visible regardless of login state
    // however the page content varies depending on the login state
    Tab {
        id: profileTab
        title: "Profile"
        imageSource: "asset:///images/icons/icon_profile.png"

        // check authentication state and load tab content accordingly
        onTriggered: {
            if (Authentication.auth.isAuthenticated()) {
                console.log("# User logged in, loading user detail page");
                profileComponent.source = "pages/UserProfile.qml"
                var profilePage = profileComponent.createObject();
                profileTab.setContent(profilePage);
            } else {
                console.log("# User not logged in, loading login page");
                profileComponent.source = "pages/UserLogin.qml"
                var profilePage = profileComponent.createObject();
                profileTab.setContent(profilePage);
            }

            // reset tab content by resetting the page
            mainTabbedPane.activeTab = popularMediaTab;
            mainTabbedPane.activeTab = profileTab;
        }

        // attach a component for the profile page
        // this is bound to the content property later on onCreationCompleted()
        attachedObjects: [
            ComponentDefinition {
                id: profileComponent
            }
        ]
    }

    // main logic on startup
    onCreationCompleted: {
        popularMediaComponent.source = "pages/PopularMedia.qml"
        var popularMediaPage = popularMediaComponent.createObject();
        popularMediaTab.setContent(popularMediaPage);

        // show content according to the login status of the user
        // actually this removes all features that require a login
        // also: set active tabs
        if (! Authentication.auth.isAuthenticated()) {
            // remove tabs and menu items that are authenticated only
            mainMenu.removeAction(mainMenuLogout);
        }

        // reset tab content by resetting the page
        mainTabbedPane.activeTab = profileTab;
        mainTabbedPane.activeTab = popularMediaTab;
    }

    // application menu (top menu)
    Menu.definition: MenuDefinition {
        id: mainMenu

        // application menu items
        actions: [
            // action for force logout
            ActionItem {
                id: mainMenuLogout
                title: "Logout"
                imageSource: "asset:///images/icons/icon_close.png"
                onTriggered: {
                    // delete the stored user data of the user from the database
                    Authentication.auth.deleteStoredInstagramData();
                    
                    // remove tabs and menu items that are authenticated only
                    mainMenu.removeAction(mainMenuLogout);                    
                    
                    // change current tab to profile tab
                    popularMediaTab.triggered();

                    // create logout sheet
                    var logoutPage = logoutComponent.createObject();
                    logoutSheet.setContent(logoutPage);
                    logoutSheet.open();
                }
            },
            // action for ratinig the app
            ActionItem {
                id: mainMenuAbout
                title: "About"
                imageSource: "asset:///images/icons/icon_about.png"
                onTriggered: {
                    aboutSheet.open();
                }
            },
            // action for rate sheet
            ActionItem {
                id: mainMenuRate
                title: "Update & Rate"
                imageSource: "asset:///images/icons/icon_bbworld.png"
                onTriggered: {
                    rateAppLink.trigger("bb.action.OPEN");
                }
            },
            // action for news sheet
            ActionItem {
                id: mainMenuNews
                title: "News"
                imageSource: "asset:///images/icons/icon_news.png"
                onTriggered: {
                    // create and open news sheet
                    var newsPage = newsComponent.createObject();
                    newsSheet.setContent(newsPage);
                    newsSheet.open();
                }
            }
        ]
    }

    // attached objects
    // this contains the sheets which are used for general page based popupos
    attachedObjects: [
        // sheet for login page
        // this is used by the UserLogin page
        Sheet {
            id: loginSheet

            // attach a component for the about page
            attachedObjects: [
                ComponentDefinition {
                    id: loginComponent
                    source: "sheets/UserLogin.qml"
                }
            ]
        },
        // sheet for logout page
        // this is used by the main menu logout item
        Sheet {
            id: logoutSheet

            // attach a component for the about page
            attachedObjects: [
                ComponentDefinition {
                    id: logoutComponent
                    source: "sheets/UserLogout.qml"
                }
            ]
        }
    ]
}
