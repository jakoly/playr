import QtQuick
import QtQuick.Controls 2.15
import QtQuick.Dialogs

ApplicationWindow {
    id: window
    visible: true
    width: 820
    height: 540
    title: "Playr"
    color: '#e6e6e6'

    // ── Sidebar ───────────────────────────────────────────────
    Rectangle {
        id: sidebar
        width: 220
        height: parent.height
        color: "#FFFFFF"

        Rectangle {
            anchors.right: parent.right
            width: 1
            height: parent.height
            color: "#E5E5EA"
        }

        Column {
            anchors.top: parent.top
            anchors.topMargin: 32
            anchors.left: parent.left
            anchors.leftMargin: 20
            spacing: 4

            Text {
                text: "Playr"
                font.pixelSize: 20
                font.weight: Font.DemiBold
                color: "#1D1D1F"
            }
            Text {
                text: "Music Player"
                font.pixelSize: 12
                color: "#8E8E93"
            }
        }

        Column {
            anchors.top: parent.top
            anchors.topMargin: 110
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 12
            anchors.rightMargin: 12
            spacing: 2

            Text {
                text: "LIBRARY"
                font.pixelSize: 10
                font.weight: Font.Medium
                color: "#8E8E93"
                leftPadding: 12
                bottomPadding: 4
                font.letterSpacing: 0.8
            }

            Rectangle {
                width: parent.width
                height: 36
                radius: 8
                color: "#007AFF"

                Row {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 12
                    spacing: 8
                    Text { text: "♪"; font.pixelSize: 14; color: "#FFFFFF" }
                    Text {
                        text: "Songs"
                        font.pixelSize: 13
                        font.weight: Font.Medium
                        color: "#FFFFFF"
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }

            Rectangle {
                width: parent.width
                height: 36
                radius: 8
                color: "transparent"

                Row {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 12
                    spacing: 8
                    Text { text: "≡"; font.pixelSize: 14; color: "#8E8E93" }
                    Text {
                        text: "Playlists"
                        font.pixelSize: 13
                        color: "#1D1D1F"
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }
        }

        Rectangle {
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 24
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 12
            anchors.rightMargin: 12
            height: 36
            radius: 8
            color: addArea.containsMouse ? "#E8E8ED" : "#F2F2F7"
            Behavior on color { ColorAnimation { duration: 80 } }

            Row {
                anchors.centerIn: parent
                spacing: 6
                Text { text: "+"; font.pixelSize: 16; color: "#007AFF"; anchors.verticalCenter: parent.verticalCenter }
                Text {
                    text: "Add Music"
                    font.pixelSize: 13
                    font.weight: Font.Medium
                    color: "#007AFF"
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            MouseArea {
                id: addArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: fileDialog.open()
            }
        }
    }

    // ── Main Content ──────────────────────────────────────────
    Rectangle {
        id: mainContent
        anchors.left: sidebar.right
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: playerBar.top
        color: "#F5F5F7"

        ListModel {
            id: songModel
        }

        Connections {
            target: player
            function onSongAdded(name, path) {
                songModel.append({ name: name, path: path })
            }
        }
        // Leer-Zustand
        Column {
            anchors.centerIn: parent
            spacing: 10
            visible: songModel.count === 0

            Text {
                text: "♫"
                font.pixelSize: 48
                color: "#C7C7CC"
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Text {
                text: "No music added yet"
                font.pixelSize: 15
                color: "#8E8E93"
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Text {
                text: "Click Add Music to get started"
                font.pixelSize: 12
                color: "#AEAEB2"
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        // Song Liste
        ListView {
            id: songList
            anchors.fill: parent
            anchors.margins: 20
            anchors.bottomMargin: 8
            model: songModel
            visible: songModel.count > 0
            clip: true
            spacing: 0

            ScrollBar.vertical: ScrollBar {
                policy: ScrollBar.AsNeeded
            }

            header: Text {
                text: "Songs"
                font.pixelSize: 22
                font.weight: Font.DemiBold
                color: "#1D1D1F"
                bottomPadding: 12
            }

            delegate: Rectangle {
                width: songList.width
                height: 52
                color: delegateArea.containsMouse ? "#EFEFF4" : "transparent"
                Behavior on color { ColorAnimation { duration: 80 } }

                // Trennlinie
                Rectangle {
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.leftMargin: 44
                    height: 1
                    color: "#E5E5EA"
                    visible: index < songModel.count - 1
                }

                Row {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.leftMargin: 8
                    anchors.rightMargin: 8
                    spacing: 12

                    // Index-Nummer / Play-Icon
                    Rectangle {
                        width: 28
                        height: 28
                        radius: 6
                        color: delegateArea.containsMouse ? "#007AFF" : "#EEEEF0"
                        anchors.verticalCenter: parent.verticalCenter
                        Behavior on color { ColorAnimation { duration: 80 } }

                        Text {
                            anchors.centerIn: parent
                            text: delegateArea.containsMouse ? "▶" : (index + 1).toString()
                            font.pixelSize: delegateArea.containsMouse ? 10 : 11
                            font.weight: Font.Medium
                            color: delegateArea.containsMouse ? "#FFFFFF" : "#8E8E93"
                        }
                    }

                    // Songname
                    Text {
                        text: name
                        font.pixelSize: 13
                        font.weight: Font.Medium
                        color: "#1D1D1F"
                        elide: Text.ElideRight
                        width: parent.width - 60
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                MouseArea {
                    id: delegateArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: player.openAudioFile("file:///" + path)
                }
            }
        }
    }

    // ── Player Bar ────────────────────────────────────────────
    Rectangle {
        id: playerBar
        anchors.bottom: parent.bottom
        anchors.left: sidebar.right
        anchors.right: parent.right
        height: 110
        color: "#FFFFFF"

        Rectangle {
            anchors.top: parent.top
            width: parent.width
            height: 1
            color: "#E5E5EA"
        }

        // Song Info links
        Column {
            anchors.left: parent.left
            anchors.leftMargin: 28
            anchors.verticalCenter: parent.verticalCenter
            width: 160
            spacing: 3

            Text {
                text: player ? (player.songName !== "" ? player.songName : "Not playing") : "Not playing"
                font.pixelSize: 13
                font.weight: Font.DemiBold
                color: "#1D1D1F"
                elide: Text.ElideRight
                width: parent.width
            }
            Text {
                text: player ? (player.artist !== "" ? player.artist : "—") : "—"
                font.pixelSize: 11
                color: "#8E8E93"
                elide: Text.ElideRight
                width: parent.width
            }
        }

        // Buttons
        Row {
            id: controlButtons
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 16
            spacing: 20

            // Back
            Rectangle {
                width: 36; height: 36; radius: 18
                color: backArea.pressed ? "#E5E5EA" : backArea.containsMouse ? "#F2F2F7" : "transparent"
                Behavior on color { ColorAnimation { duration: 80 } }

                Canvas {
                    anchors.centerIn: parent
                    width: 16; height: 16
                    onPaint: {
                        var ctx = getContext("2d")
                        ctx.clearRect(0, 0, width, height)
                        ctx.fillStyle = "#1D1D1F"
                        ctx.fillRect(0, 0, 2.5, 16)
                        ctx.beginPath()
                        ctx.moveTo(14, 0)
                        ctx.lineTo(3, 8)
                        ctx.lineTo(14, 16)
                        ctx.closePath()
                        ctx.fill()
                    }
                }

                MouseArea {
                    id: backArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                }
            }

            // Play / Pause
            Rectangle {
                width: 44; height: 44; radius: 22
                color: playArea.pressed ? "#0055CC" : playArea.containsMouse ? "#0066DD" : "#007AFF"
                Behavior on color { ColorAnimation { duration: 80 } }
                scale: playArea.pressed ? 0.93 : 1.0
                Behavior on scale { NumberAnimation { duration: 80; easing.type: Easing.OutQuad } }

                Canvas {
                    id: playIcon
                    anchors.centerIn: parent
                    width: 18; height: 18

                    property bool playing: player ? player.isPlaying : false
                    onPlayingChanged: requestPaint()

                    onPaint: {
                        var ctx = getContext("2d")
                        ctx.clearRect(0, 0, width, height)
                        ctx.fillStyle = "#FFFFFF"
                        if (playing) {
                            ctx.fillRect(2, 1, 4.5, 16)
                            ctx.fillRect(11.5, 1, 4.5, 16)
                        } else {
                            ctx.beginPath()
                            ctx.moveTo(4, 0)
                            ctx.lineTo(18, 9)
                            ctx.lineTo(4, 18)
                            ctx.closePath()
                            ctx.fill()
                        }
                    }
                }

                MouseArea {
                    id: playArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        player.togglePlayPause()
                        playIcon.requestPaint()
                    }
                }
            }

            // Forward
            Rectangle {
                width: 36; height: 36; radius: 18
                color: fwdArea.pressed ? "#E5E5EA" : fwdArea.containsMouse ? "#F2F2F7" : "transparent"
                Behavior on color { ColorAnimation { duration: 80 } }

                Canvas {
                    anchors.centerIn: parent
                    width: 16; height: 16
                    onPaint: {
                        var ctx = getContext("2d")
                        ctx.clearRect(0, 0, width, height)
                        ctx.fillStyle = "#1D1D1F"
                        ctx.beginPath()
                        ctx.moveTo(2, 0)
                        ctx.lineTo(13, 8)
                        ctx.lineTo(2, 16)
                        ctx.closePath()
                        ctx.fill()
                        ctx.fillRect(13.5, 0, 2.5, 16)
                    }
                }

                MouseArea {
                    id: fwdArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                }
            }
        }

        // Progress Slider
        Slider {
            id: progressBar
            width: 300
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: controlButtons.bottom
            anchors.topMargin: 10
            from: 0; to: 1; value: 0

            background: Rectangle {
                x: progressBar.leftPadding
                y: progressBar.topPadding + progressBar.availableHeight / 2 - height / 2
                width: progressBar.availableWidth
                height: 3; radius: 2
                color: "#E5E5EA"

                Rectangle {
                    width: progressBar.visualPosition * parent.width
                    height: parent.height; radius: 2
                    color: "#007AFF"
                }
            }

            handle: Rectangle {
                x: progressBar.leftPadding + progressBar.visualPosition * (progressBar.availableWidth - width)
                y: progressBar.topPadding + progressBar.availableHeight / 2 - height / 2
                width: 12; height: 12; radius: 6
                color: "#007AFF"
            }
        }

        // Volume rechts
        Row {
            anchors.right: parent.right
            anchors.rightMargin: 28
            anchors.verticalCenter: parent.verticalCenter
            spacing: 8

            Text { text: "🔈"; font.pixelSize: 12; color: "#8E8E93"; anchors.verticalCenter: parent.verticalCenter }

            Slider {
                id: volumeSlider
                width: 80
                from: 0; to: 100; value: 50
                anchors.verticalCenter: parent.verticalCenter

                background: Rectangle {
                    x: volumeSlider.leftPadding
                    y: volumeSlider.topPadding + volumeSlider.availableHeight / 2 - height / 2
                    width: volumeSlider.availableWidth
                    height: 3; radius: 2
                    color: "#E5E5EA"

                    Rectangle {
                        width: volumeSlider.visualPosition * parent.width
                        height: parent.height; radius: 2
                        color: "#007AFF"
                    }
                }

                handle: Rectangle {
                    x: volumeSlider.leftPadding + volumeSlider.visualPosition * (volumeSlider.availableWidth - width)
                    y: volumeSlider.topPadding + volumeSlider.availableHeight / 2 - height / 2
                    width: 12; height: 12; radius: 6
                    color: "#007AFF"
                }
            }

            Text { text: "🔊"; font.pixelSize: 12; color: "#8E8E93"; anchors.verticalCenter: parent.verticalCenter }
        }
    }

    FileDialog {
        id: fileDialog
        nameFilters: ["Audio files (*.mp3 *.wav *.flac)"]
        onAccepted: player.openAudioFile(fileDialog.selectedFile)
    }
}