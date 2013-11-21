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

    // tab for the personal user feed
    // tab is only visible if user is logged in
    Tab {
        id: personalFeedTab
        title: "Your Feed"
        imageSource: "asset:///images/icons/icon_home.png"

        // note that the page is bound to the component every time it loads
        // this is because the page needs to be created as tapped
        // if created on startup it does not work immediately after login
        onTriggered: {
            personalFeedComponent.source = "pages/PersonalFeed.qml";
            var personalFeedPage = personalFeedComponent.createObject();
            personalFeedTab.setContent(personalFeedPage);
        }

        // attach a component for the user feed page
        // this is bound to the content property later on onCreationCompleted()
        attachedObjects: [
            ComponentDefinition {
                id: personalFeedComponent
            }
        ]
    }

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
                profileComponent.source = "pages/UserProfile.qml"
                var profilePage = profileComponent.createObject();
                profileTab.setContent(profilePage);
            } else {
                // console.log("# User not logged in, loading login page");
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

    // tab for the search page
    // tab is only visible if user is logged in
    Tab {
        id: searchTab
        title: "Search"
        imageSource: "asset:///images/icons/icon_search.png"
        
        // note that the page is bound to the component every time it loads
        // this is because the page needs to be created as tapped
        // if created on startup it does not work immediately after login
        onTriggered: {
            searchComponent.source = "pages/Search.qml";
            var searchPage = searchComponent.createObject();
            searchTab.setContent(searchPage);
        }
        
        // attach a component for the user feed page
        // this is bound to the content property later on onCreationCompleted()
        attachedObjects: [
            ComponentDefinition {
                id: searchComponent
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
            mainTabbedPane.remove(personalFeedTab);
            mainTabbedPane.remove(searchTab);

            // reset tab content by resetting the page
            mainTabbedPane.activeTab = profileTab;
            mainTabbedPane.activeTab = popularMediaTab;
        } else {
            // activate tabs
            // this is a workaround as the initial tab does not recognize taps
            // and does not have the correct height / positioning
            personalFeedTab.triggered();
            mainTabbedPane.activeTab = profileTab;
            mainTabbedPane.activeTab = personalFeedTab;
        }
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
                    // create logout sheet
                    var aboutSheetPage = aboutComponent.createObject();
                    aboutSheet.setContent(aboutSheetPage);
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
        // sheet for about page
        // this is used by the main menu about item
        Sheet {
            id: aboutSheet

            // attach a component for the about page
            attachedObjects: [
                ComponentDefinition {
                    id: aboutComponent
                    source: "sheets/About.qml"
                }
            ]
        },
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
        },
        // sheet for news page
        // this is used by the main menu news item
        Sheet {
            id: newsSheet
            
            // attach a component for the about page
            attachedObjects: [
                ComponentDefinition {
                    id: newsComponent
                    source: "sheets/News.qml"
                }
            ]
        },
        // invocation for bb world
        // used by the action menu to switch to bb world
        Invocation {
            id: rateAppLink
            query {
                mimeType: "application/x-bb-appworld"
                uri: "appworld://content/24485875"
            }
        }
    ]
}
