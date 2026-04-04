#include "player.h"
#include <QDebug>
#include <QMediaPlayer>
#include <QAudioOutput>
#include <QFileInfo>
#include <QMediaMetaData>

Player::Player(QObject *parent) : QObject(parent)
{
    M_Player = new QMediaPlayer(this);
    audioOutput = new QAudioOutput(this);
    M_Player->setAudioOutput(audioOutput);

    connect(M_Player, &QMediaPlayer::playbackStateChanged,
            this, &Player::updatePlayingState);

    // Hier, nicht in playSong:
    connect(M_Player, &QMediaPlayer::metaDataChanged, this, [this]() {
        m_songName = M_Player->metaData().value(QMediaMetaData::Title).toString();
        m_artist = M_Player->metaData().value(QMediaMetaData::AlbumArtist).toString();
        emit songNameChanged();
        emit artistChanged();
    });
}

void Player::togglePlayPause()
{
    if (M_Player->playbackState() == QMediaPlayer::PlayingState) {
        M_Player->pause();
    } else {
        M_Player->play();
    }
}

void Player::updatePlayingState()
{
    bool playing = (M_Player->playbackState() == QMediaPlayer::PlayingState);
    if (m_isPlaying != playing) {
        m_isPlaying = playing;
        emit isPlayingChanged();
    }
}

void Player::playSong(QUrl songPath)
{
    M_Player->setSource(songPath);
    M_Player->play();
    m_isPlaying = true;
    m_songName = QFileInfo(songPath.toLocalFile()).baseName();
    emit isPlayingChanged();
    emit songNameChanged();
}

void Player::openAudioFile(const QUrl &fileUrl)
{
    if (fileUrl.isEmpty()) return;

    QString path = fileUrl.toLocalFile();

    if (!allSongs.contains(path)) {
        allSongs.append(path);
        emit songAdded(QFileInfo(path).fileName(), path);
    }

    playSong(fileUrl);
}

