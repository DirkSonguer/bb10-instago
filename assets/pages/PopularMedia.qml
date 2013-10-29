// *************************************************** //
// Popular Photos Page
//
// The popular photos page shows a grid of the current
// popular photos that can be tapped.
// It is shown as default starting page if the user is
// not logged in.
// *************************************************** //

// import blackberry components
import bb.cascades 1.2

// set import directory for components
import "../components"

// shared js files
import "../global/globals.js" as Globals
import "../global/copytext.js" as Copytext
import "../instagramapi/media.js" as MediaRepository

// this is a page that is available from the main tab, thus it has to be a navigation pane
// note that the id is always "navigationPane"
NavigationPane {
    id: navigationPane

    Page {
        id: popularMediaPage

        // signal if popular media data loading is complete
        signal popularMediaDataLoaded(variant mediaDataArray)

        // signal if popular media data loading encountered an error
        signal popularMediaDataError(variant errorData)

        // main content container
        Container {
            // layout definition
            layout: DockLayout {
            }
            
            LoadingIndicator {
                id: loadingIndicator
                verticalAlignment: VerticalAlignment.Center
                horizontalAlignment: HorizontalAlignment.Center
            }
            
            ErrorMessage {
                id: errorMessage
                verticalAlignment: VerticalAlignment.Center
                horizontalAlignment: HorizontalAlignment.Center
            }
        }

        // page creation is finished
        // load the gallery content as soon as the page is ready
        onCreationCompleted: {
            loadingIndicator.showLoader("Loading popular items");
            
            // load popular media stream
            // MediaRepository.getPopularMedia(popularMediaPage);
        }
    }

    // destroy pages after use
    onPopTransitionEnded: {
        page.destroy();
    }
}
