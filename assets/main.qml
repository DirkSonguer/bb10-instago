import bb.cascades 1.2

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
            mainTabbedPane.activeTab = tab2;
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

    Tab { //Second tab
        id: tab2
        title: qsTr("Tab 2") + Retranslate.onLocaleOrLanguageChanged
        Page {
            Container {
                Label {
                    text: qsTr("Second tab") + Retranslate.onLocaleOrLanguageChanged
                }
            }
        }
    } //End of second tab
}
