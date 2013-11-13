// *************************************************** //
// Location Map Component
//
// This component shows a map with the defined dimensions
// and provides logic to show a simple marker in the
// center of the map component.
// *************************************************** //

// import blackberry components
import bb.cascades 1.2
import bb.system 1.2
import bb.cascades.maps 1.0

// shared js files
import "../global/globals.js" as Globals
import "../global/copytext.js" as Copytext

Container {
    id: locationMapComponent

    // signal that map view has been clicked
    signal clicked()

    // properties to make accessible
    property alias latitude: locationMapView.latitude
    property alias longitude: locationMapView.longitude
    property alias altitude: locationMapView.altitude
    property alias pinText: locationMapPinText.text

    // set initial background color
    background: Color.create(Globals.instagoDefaultBackgroundColor)

    layout: DockLayout {
    }

    // actual map view
    // map position needs to be set by the using component
    MapView {
        id: locationMapView
        preferredWidth: DisplayInfo.width
        preferredHeight: 250
    }

    // container that blocks touch events on the map
    Container {
        preferredWidth: DisplayInfo.width
        preferredHeight: 250
    }

    // this contains the pin information
    // its only visible if the pinText propoerty is filled by the component
    Container {
        id: locationMapPinContainer

        // layout definition
        verticalAlignment: VerticalAlignment.Center
        horizontalAlignment: HorizontalAlignment.Center
        leftPadding: 5
        rightPadding: 5

        // set initial visibility to false
        // will be set visible if text has been given for marker
        visible: false

        Container {
            id: locationMapPinLabel

            // layout definition
            layout: StackLayout {
                orientation: LayoutOrientation.TopToBottom
            }

            // layout definition
            background: Color.Black
            bottomPadding: 8
            bottomMargin: 0
            leftPadding: 10
            rightPadding: 10
            topPadding: 5
            opacity: 0.8

            // the label for the pin
            Label {
                id: locationMapPinText

                // layout definition
                textStyle.base: SystemDefaults.TextStyles.BodyText
                textStyle.color: Color.White
            }
        }

        // this is the marker of the pin
        // as cascaes does not know shapes this needs to be an image
        ImageView {
            horizontalAlignment: HorizontalAlignment.Center
            imageSource: "asset:///images/triangle_black_down.png"
            opacity: 0.8
            topMargin: 0
        }
    }

    // make pin visible if content has changed
    onPinTextChanged: {
        locationMapPinContainer.visible = true;
    }

    // handle tap on custom button
    gestureHandlers: [
        TapHandler {
            onTapped: {
                customButtonComponent.clicked();
            }
        }
    ]
}