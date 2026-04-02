#pragma once

#include <QObject>

class QMediaPlayer;
class QAudioOutput;

class Player : public QObject {
    Q_OBJECT
    Q_PROPERTY(bool isPlaying READ isPlaying NOTIFY isPlayingChanged)

public:
    explicit Player(QObject *parent = nullptr);

    Q_INVOKABLE void togglePlayPause();
    Q_INVOKABLE void openAudioFile(const QUrl &fileUrl);

    bool isPlaying() const { return m_isPlaying; }

signals:
    void isPlayingChanged();

private:
    QMediaPlayer *M_Player;
    QAudioOutput *audioOutput;
    bool m_isPlaying = false;

private slots:
    void updatePlayingState();
};