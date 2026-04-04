import QtQuick
import QtQuick.Controls 2.15
import QtQuick.Dialogs

ApplicationWindow {
    id: window
    visible: true
    width: 800
    height: 500
    title: "Playr - A music player"
    color: "darkgrey"

    Text {
        id: songList
        anchors.left: parent.left
        anchors.leftMargin: 100
        anchors.topMargin: 100
        text: fileList
    }

    Rectangle {
        property string songTitel: ""

        anchors.bottom: parent.bottom

        color: "black"
        width: window.width
        height: 125

        Text {
            id: songName

            anchors.left: parent.left
            anchors.top: parent.top
            anchors.topMargin: 20
            anchors.leftMargin: 20
            
            text: player ? player.songName : ""
            color: "white"
            font.pixelSize: 25
        }

        Text {
            text: player ? player.artist : ""
            color: "grey"
            font.pixelSize: 16
        }

        Button {
            id: playButton
            
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -20  // Negativer Wert = nach oben

            font.pixelSize: 30
            width: 50
            height: 50

            text: player ? (player.isPlaying ? "⏸️" : "▶️") : "▶️"
            onClicked: {
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

        Slider {
            id: volumeControle

            anchors.top: parent.top
            anchors.right: parent.right
            anchors.margins: 10

            width: 100
            height: 20

            from: 0
            to: 100
            value: 50

            background: Rectangle {
                height: 4
                radius: 2
                color: "#444"

                Rectangle {
                    width: volumeControle.visualPosition * parent.width
                    height: parent.height
                    color: "#00cc88"
                    radius: 2
                }
            }

            handle: Rectangle {
                width: 12
                height: 12
                radius: 6
                color: "#00cc88"
                y: (volumeControle.height - height) / 2
                x: volumeControle.visualPosition * (volumeControle.width - width)
            }
        }

        
    } 

    Column {
        anchors.fill: parent
        anchors.margins: 10

        spacing: 10

        Button {
            id: openAudioFile
        

            font.pixelSize: 10
            width: 50
            height: 50

            text: "open"

            onClicked: fileDialog.open()
        }

        Rectangle { width: 50; height: 50; color: "green" }
        Rectangle { width: 50; height: 50; color: "blue" }
    }

    FileDialog {
        id: fileDialog
        nameFilters: ["Audio files (*.mp3 *.wav *.flac)"]

        onAccepted: {
            player.openAudioFile(fileDialog.selectedFile)
        }
    }
}

