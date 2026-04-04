#pragma once

#include <QObject>
#include <QString>

class QMediaPlayer;
class QAudioOutput;

class Player : public QObject {
    Q_OBJECT
    Q_PROPERTY(bool isPlaying READ isPlaying NOTIFY isPlayingChanged)
    Q_PROPERTY(QString songName READ songName NOTIFY songNameChanged)
    Q_PROPERTY(QString artist READ artist NOTIFY artistChanged)

public:
    explicit Player(QObject *parent = nullptr);

    Q_INVOKABLE void togglePlayPause();
    Q_INVOKABLE void openAudioFile(const QUrl &fileUrl);

    bool isPlaying() const { return m_isPlaying; }
    QString songName() const { return m_songName; }
    QString artist() const { return m_artist; }

    void playSong(QUrl songPath);

signals:
    void isPlayingChanged();
    void songAdded(const QString& name, const QString& path);
    void songNameChanged();
    void artistChanged();

private:
    QMediaPlayer *M_Player;
    QAudioOutput *audioOutput;
    bool m_isPlaying = false;
    QString m_songName = "[song name]";
    QString m_artist = "";

    QStringList allSongs;

private slots:
    void updatePlayingState();
};