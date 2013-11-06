// *************************************************** //
// User Profile Page
//
// The user profile page shows the personal information
// about the current user.
// Note that is only the profile page of the currently
// logged in user, not users in general
// *************************************************** //

// import blackberry components
import bb.cascades 1.2

// set import directory for components
import "../components"

// shared js files
import "../global/globals.js" as Globals
import "../global/copytext.js" as Copytext
import "../instagramapi/users.js" as UserRepository

// import image url loader component
import WebImageView 1.0

// this is a page that is available from the main tab, thus it has to be a navigation pane
// note that the id is always "navigationPane"
NavigationPane {
    id: navigationPane

    Page {
        id: userProfilePage

        // signal if user profile data loading is complete
        signal userProfileDataLoaded(variant userData)

        // signal if user profile data loading encountered an error
        signal userProfileDataError(variant errorData)

        // content container
        Container {
            layout: DockLayout {            }

            Container {
                id: userProfileContainer

                layout: StackLayout {
                    orientation: LayoutOrientation.TopToBottom
                }
                
                // set initial visibility to false
                visible: false

                UserHeader {
                    id: userProfileHeader
                }

                // the like and comment button
                Container {
                    // layout definition
                    layout: StackLayout {
                        orientation: LayoutOrientation.LeftToRight
                    }

                    // layout definition
                    topMargin: 1

                    CustomButton {
                        id: userProfileFollowersCount

                        // position and layout properties
                        layoutProperties: StackLayoutProperties {
                            spaceQuota: 1.0
                        }

                        // layout definition
                        rightMargin: 1
                    }

                    CustomButton {
                        id: userProfileFollowingCount

                        // position and layout properties
                        layoutProperties: StackLayoutProperties {
                            spaceQuota: 1.0
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
            // show loader
            loadingIndicator.showLoader("Loading user data");

            // console.log("# Loading current user data");
            UserRepository.getUserProfile("self", userProfilePage);
        }

        // user profile data loaded and transformed
        // data is stored in "userData" variant of type InstagramUserData
        onUserProfileDataLoaded: {
            // hide loader and show content
            loadingIndicator.hideLoader();
            userProfileContainer.visible = true;

            // user metadata (profile picture, full and user name)
            userProfileHeader.userimage = userData.profilePicture;
            userProfileHeader.username = "@" + userData.username;
            userProfileHeader.userfullname = userData.fullName;
            userProfileHeader.userwebsite = userData.website;

            userProfileFollowersCount.boldText = userData.numberOfFollowers;
            userProfileFollowersCount.narrowText = "followers";
            userProfileFollowingCount.boldText = userData.numberOfFollows;
            userProfileFollowingCount.narrowText = "following";
        }
    }
}