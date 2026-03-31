import QtQuick
import QtQuick.Controls
import QtQuick.Controls 2.15

ApplicationWindow {
    visible: true
    width: 800
    height: 500
    title: "Playr - A music player"

    Button {
    id: playButton
    property bool isPlaying: false

    text: isPlaying ? "⏸" : "▶"

    onClicked: {
        isPlaying = !isPlaying
        player.togglePlayPause()  // C++ Funktion aufrufen
    }
}
}