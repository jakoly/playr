import QtQuick
import QtQuick.Controls 2.15

ApplicationWindow {
    id: window
    visible: true
    width: 800
    height: 500
    title: "Playr - A music player"

    Rectangle {
        property bool isPlaying: false
        property string songTitel: ""

        anchors.bottom: parent.bottom

        color: "lightgrey"
        width: window.width
        height: 125

        Button {
            id: playButton
            
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -20  // Negativer Wert = nach oben

            font.pixelSize: 32
            width: 50
            height: 50

            text: parent.isPlaying ? "⏸" : "▶"

            onClicked: {
                parent.isPlaying = !parent.isPlaying
                player.togglePlayPause()
            }
        }

        Button {
            id: backButton
            
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -20
            anchors.horizontalCenterOffset: -60  // Negativer Wert = nach oben

            font.pixelSize: 32
            width: 50
            height: 50

            text: "⏪"
        }

        Button {
            id: forwardButton
            
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -20
            anchors.horizontalCenterOffset: 60  // Negativer Wert = nach oben

            font.pixelSize: 32
            width: 50
            height: 50

            text: "⏩"
        }

        Slider {
            id: progressBar
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: 30
            width: window.width-100
        }

        
    } 

    Column {
        anchors.fill: parent
        anchors.margins: 10

        spacing: 10

        Rectangle { width: 50; height: 50; color: "red" }
        Rectangle { width: 50; height: 50; color: "green" }
        Rectangle { width: 50; height: 50; color: "blue" }
    }
}