#pragma once

#include <QObject>
#include <QString>
#include <QMediaPlayer>

class QMediaPlayer;
class QAudioOutput;

class Player : public QObject {
    Q_OBJECT
    Q_PROPERTY(bool isPlaying READ isPlaying NOTIFY isPlayingChanged)
    Q_PROPERTY(QString songName READ songName NOTIFY songNameChanged)
    Q_PROPERTY(QString artist READ artist NOTIFY artistChanged)
    Q_PROPERTY(qint64 position READ position NOTIFY positionChanged)
    Q_PROPERTY(qint64 duration READ duration NOTIFY durationChanged)

public:
    explicit Player(QObject *parent = nullptr);

    qint64 position() const { return M_Player->position(); }
    qint64 duration() const { return M_Player->duration(); }    

    Q_INVOKABLE void togglePlayPause();
    Q_INVOKABLE void openAudioFile(const QUrl &fileUrl);
    Q_INVOKABLE void removeSong(const QString &path);
    Q_INVOKABLE void setPosition(qint64 pos);

    bool isPlaying() const { return m_isPlaying; }
    QString songName() const { return m_songName; }
    QString artist() const { return m_artist; }

    void playSong(QUrl songPath);

signals:
    void isPlayingChanged();
    void songAdded(const QString& name, const QString& path);
    void songNameChanged();
    void artistChanged();
    void songRemoved(const QString &path);
    void positionChanged();
    void durationChanged();

private:
    void addSong(const QString& title, const QString& path);
    void loadSongs();
    QMediaPlayer *M_Player;
    QAudioOutput *audioOutput;
    bool m_isPlaying = false;
    QString m_songName = "[song name]";
    QString m_artist = "";

    QStringList allSongs;

private slots:
    void updatePlayingState();
};