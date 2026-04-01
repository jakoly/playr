#include "filehandler.h"
#include <QDebug>
#include <fstream>
#include <string>
#include <iostream>

FileHandler::FileHandler(QObject* parent) : QObject(parent) {}

void FileHandler::handleFiles(const QList<QUrl>& urls) {
    QStringList paths;

    for (const QUrl& url : urls) {
        QString localPath = url.toLocalFile();
        if (!localPath.isEmpty()) {
            paths << localPath;
            newFiles.append(localPath);
            qDebug() << "Datei erhalten:" << localPath;
        }
    }

    emit filesReceived(paths);  // Signal zurück an QML
}