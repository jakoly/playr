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

    connect(M_Player, &QMediaPlayer::positionChanged,
        this, &Player::positionChanged);

    connect(M_Player, &QMediaPlayer::durationChanged,
            this, &Player::durationChanged);

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

void Player::removeSong(const QString& path)
{
    QJsonArray allSongs;

    QFile file("../json/songs.json");

    // 1. Datei lesen
    if (file.open(QIODevice::ReadOnly)) {
        QJsonDocument doc = QJsonDocument::fromJson(file.readAll());
        file.close();

        allSongs = doc.object()["allSongs"].toArray();
    }

    // 2. Song entfernen (nach path match)
    QJsonArray updatedSongs;

    for (const QJsonValue& value : allSongs) {
        QJsonObject obj = value.toObject();

        if (obj["path"].toString() != path) {
            updatedSongs.append(obj);
        }
    }

    // 3. Neue JSON schreiben
    QJsonObject root;
    root["allSongs"] = updatedSongs;

    if (file.open(QIODevice::WriteOnly)) {
        file.write(QJsonDocument(root).toJson(QJsonDocument::Indented));
        file.close();
    }

    // 4. Optional: Signal für QML
    emit songRemoved(path);
}

void Player::setPosition(qint64 pos)
{
    M_Player->setPosition(pos);
}