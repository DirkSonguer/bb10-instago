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
        signal userDetailDataLoaded(variant userData)

        // signal if user profile data loading encountered an error
        signal userDetailDataError(variant errorData)

        // property that holds the loaded user data
        property variant userData

        // content container
        Container {
            // layout orientation
            layout: DockLayout {
            }

            // make the whole content container scrollables
            ScrollView {
                id: loginInstagramWebViewScrollContainer
                scrollViewProperties {
                    scrollMode: ScrollMode.Vertical
                    pinchToZoomEnabled: false
                }

                Container {
                    id: userProfileContainer

                    // layout orientation
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
                        id: userProfileFollowerAndFollowingCount

                        // layout orientation
                        layout: StackLayout {
                            orientation: LayoutOrientation.LeftToRight
                        }

                        // set initial visibiity to false
                        // will be set once data is loaded
                        visible: false

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

                            // show followers list
                            onClicked: {
                                var userFollowersPage = userFollowersComponent.createObject();
                                userFollowersPage.userData = userData;
                                navigationPane.push(userFollowersPage);
                            }
                        }

                        CustomButton {
                            id: userProfileFollowingCount

                            // position and layout properties
                            layoutProperties: StackLayoutProperties {
                                spaceQuota: 1.0
                            }

                            // show followers list
                            onClicked: {
                                var userFollowingPage = userFollowingComponent.createObject();
                                userFollowingPage.userData = userData;
                                navigationPane.push(userFollowingPage);
                            }
                        }
                    }

                    CustomButton {
                        id: userProfileImages
                        
                        narrowText: "Your images"
                        
                        // show followers list
                        onClicked: {
                        }
                    }
                    
                    CustomButton {
                        id: userProfileFavourites
                        
                        narrowText: "Your favourites"
                        
                        // show followers list
                        onClicked: {
                        }
                    }

                    CustomButton {
                        id: userProfileEditProfile
                        
                        narrowText: "Edit profile"
                        
                        // show followers list
                        onClicked: {
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
            loadingIndicator.showLoader("Loading user profile");

            // console.log("# Loading current user data for current user");
            UserRepository.getUserProfile("self", userProfilePage);
        }

        // user profile data loaded and transformed
        // data is stored in "userData" variant of type InstagramUserData
        onUserDetailDataLoaded: {
            // console.log("# User detail data loaded for user " + userData.username);

            // update page userData object with full data
            userProfilePage.userData = userData;

            // hide loader and show content
            loadingIndicator.hideLoader();
            userProfileContainer.visible = true;

            // user metadata (profile picture, full and user name)
            userProfileHeader.userimage = userData.profilePicture;
            userProfileHeader.username = "@" + userData.username;
            userProfileHeader.userfullname = userData.fullName;
            userProfileHeader.userwebsite = userData.website;

            // followers and following count
            userProfileFollowerAndFollowingCount.visible = true;
            userProfileFollowersCount.boldText = userData.numberOfFollowers;
            userProfileFollowersCount.narrowText = "followers";
            userProfileFollowingCount.boldText = userData.numberOfFollows;
            userProfileFollowingCount.narrowText = "following";
        }

        // user profile data could not be loaded or transformed
        // show error message
        onUserDetailDataError: {
            // console.log("# User detail data could not be loaded. Error: " + errorData.errorMessage);

            // show error message
            loadingIndicator.showLoader(errorData.errorMessage, "Error " + errorData.errorCode);
        }

        // attach components
        attachedObjects: [
            // detail image page
            // will be called if user clicks on image gallery item
            ComponentDefinition {
                id: detailImageComponent
                source: "MediaDetail.qml"
            },
            // follower list page
            // will be called if user clicks on followers button
            ComponentDefinition {
                id: userFollowersComponent
                source: "UserFollowers.qml"
            },
            // following list page
            // will be called if user clicks on following button
            ComponentDefinition {
                id: userFollowingComponent
                source: "UserFollowing.qml"
            }
        ]
    }
}