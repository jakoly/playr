#include "player.h"
#include <QDebug>
#include <iostream>

Player::Player(QObject *parent) : QObject(parent) {}

void Player::togglePlayPause() {
    qDebug() << "Play/Pause geklickt!";
    // Hier später QMediaPlayer steuern
}