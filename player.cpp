#include "player.h"
#include <QDebug>
#include <QMediaPlayer>
#include <QAudioOutput>

Player::Player(QObject *parent)
    : QObject(parent)
{
    M_Player = new QMediaPlayer(this);
    audioOutput = new QAudioOutput(this);
    M_Player->setAudioOutput(audioOutput);

    // Verbinde Playback-Status mit unserer Variable
    connect(M_Player, &QMediaPlayer::playbackStateChanged,
            this, &Player::updatePlayingState);
}

void Player::togglePlayPause()
{
    if (M_Player->playbackState() == QMediaPlayer::PlayingState) {
        M_Player->pause();
    } else {
        M_Player->play();
    }
}

void Player::openAudioFile(const QUrl &fileUrl)
{
    if (fileUrl.isEmpty())
        return;

    M_Player->setSource(fileUrl);
    M_Player->play(); // direkt starten

    // ist jetzt playing
    m_isPlaying = true;
    emit isPlayingChanged();

    qDebug() << "Playing:" << fileUrl;
}

void Player::updatePlayingState()
{
    bool playing = (M_Player->playbackState() == QMediaPlayer::PlayingState);
    if (m_isPlaying != playing) {
        m_isPlaying = playing;
        emit isPlayingChanged();
    }
}