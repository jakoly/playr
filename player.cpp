#include "player.h"
#include <QDebug>
#include <QMediaPlayer>
#include <QAudioOutput>
#include <QFileInfo>
#include <QMediaMetaData>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <filesystem>
#include <QDir>
#include <QTimer>

Player::Player(QObject *parent) : QObject(parent)
{
    M_Player = new QMediaPlayer(this);
    audioOutput = new QAudioOutput(this);
    M_Player->setAudioOutput(audioOutput);

    connect(M_Player, &QMediaPlayer::playbackStateChanged,
            this, &Player::updatePlayingState);

    connect(M_Player, &QMediaPlayer::metaDataChanged, this, [this]() {
        m_songName = M_Player->metaData().value(QMediaMetaData::Title).toString();
        m_artist = M_Player->metaData().value(QMediaMetaData::AlbumArtist).toString();
        emit songNameChanged();
        emit artistChanged();
    });

    // WICHTIG: verzögert ausführen
    QTimer::singleShot(0, this, &Player::loadSongs);
}

void Player::addSong(const QString& title, const QString& path)
{
    // 1. Datei lesen (falls sie schon existiert)
    QJsonArray allSongs;

    QFile file("../json/songs.json");
    if (file.open(QIODevice::ReadOnly)) {
        QJsonDocument doc = QJsonDocument::fromJson(file.readAll());
        file.close();
        allSongs = doc.object()["allSongs"].toArray();
    }

    // 2. Neuen Song als Objekt erstellen
    QJsonObject newSong;
    newSong["title"]    = title;
    newSong["path"]     = path;

    // 3. Song ans Array anhängen
    allSongs.append(newSong);

    // 4. Zurückschreiben
    QJsonObject root;
    root["allSongs"] = allSongs;

    if (file.open(QIODevice::WriteOnly)) {
        file.write(QJsonDocument(root).toJson(QJsonDocument::Indented));
        file.close();
    }
}

void Player::loadSongs()
{
    QFile file("../json/songs.json");
    if (!file.open(QIODevice::ReadOnly)) return;

    QJsonDocument doc = QJsonDocument::fromJson(file.readAll());
    QJsonArray arr = doc.object()["allSongs"].toArray();

    for (const QJsonValue& val : arr) {
        QString path = val.toObject()["path"].toString();
        if (!allSongs.contains(path)) {
            allSongs.append(path);
            emit songAdded(QFileInfo(path).fileName(), path); // WICHTIG
        }
    }
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
        addSong(QFileInfo(path).fileName(), path);

    }

    playSong(fileUrl);
}
