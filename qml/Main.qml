import QtQuick
import QtQuick.Controls 2.15

ApplicationWindow {
    id: window
    visible: true
    width: 800
    height: 500
    title: "Playr - A music player"
    color: "darkgrey"

    Rectangle {
        id: dropArea
        width: window.width/4
        height: 300
        anchors.right: parent.right
        anchors.rightMargin: 10
        color: dropHandler.containsDrag ? "#cce5ff" : "#f0f0f0"
        border.color: dropHandler.containsDrag ? "#0066cc" : "#aaaaaa"
        border.width: 2

        DropArea {
            id: dropHandler
            anchors.fill: parent

            // Nur Dateien akzeptieren
            onEntered: (drag) => {
                drag.accepted = drag.hasUrls
            }

            onDropped: (drop) => {
                if (drop.hasUrls) {
                    fileHandler.handleFiles(drop.urls)  // C++ aufrufen
                }
            }
        }

        Text {
            anchors.centerIn: parent
            text: dropHandler.containsDrag
                ? "Loslassen zum Ablegen"
                : "Dateien hier ablegen"
            color: "#555"
            font.pixelSize: 16
        }
    }

    Text {
        id: songList
        anchors.left: parent.left
        anchors.leftMargin: 100
        anchors.topMargin: 100
        text: fileList
    }

    Rectangle {
        property bool isPlaying: false
        property string songTitel: ""

        anchors.bottom: parent.bottom

        color: "black"
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