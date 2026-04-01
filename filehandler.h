#pragma once
#include <QObject>
#include <QList>
#include <QUrl>
#include <string>
#include <vector>

class FileHandler : public QObject {
    Q_OBJECT

public:
    explicit FileHandler(QObject* parent = nullptr);

    std::vector<std::string> newFiles;

public slots:
    void handleFiles(const QList<QUrl>& urls);

signals:
    void filesReceived(const QStringList& paths);
};