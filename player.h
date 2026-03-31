#pragma once
#include <QObject>

class Player : public QObject {
    Q_OBJECT

public:
    explicit Player(QObject *parent = nullptr);

public slots:
    Q_INVOKABLE void togglePlayPause();
};