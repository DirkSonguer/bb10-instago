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

// set import directory for covers
// import "covers"

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
                // profileComponent.source = "pages/UserProfile.qml"
                // var profilePage = profileComponent.createObject();
                // profileTab.setContent(profilePage);
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

        // reset tab content by resetting the page
        mainTabbedPane.activeTab = profileTab;
        mainTabbedPane.activeTab = popularMediaTab;
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
        }
    ]
}
