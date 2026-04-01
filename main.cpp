#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QFile>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QDebug>
#include <QTimer>
#include "player.h"
#include "filehandler.h"



QJsonObject readJson(const QString& path)
{
    QFile file(path);
    if (!file.open(QIODevice::ReadOnly)) {
        qWarning() << "Datei nicht gefunden:" << path;
        return {};
    }

    QByteArray data = file.readAll();
    QJsonDocument doc = QJsonDocument::fromJson(data);
    return doc.object();
}


int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    Player player;
    FileHandler fileHandler;

    engine.rootContext()->setContextProperty("player", &player);
    engine.rootContext()->setContextProperty("fileHandler", &fileHandler);
    engine.rootContext()->setContextProperty("fileList", "Hallo Welt!");

    
    FileHandler handler;
    // Timer erstellen
    QTimer timer;

    // Was jede Sekunde passieren soll:
    QObject::connect(&timer, &QTimer::timeout, [&]() {
        for (int i = 0; i < handler.newFiles.size(); i++) {
            QVariant wert = engine.rootContext()->contextProperty("fileList");
            QString text = wert.toString() + QString::fromStdString(handler.newFiles[i]);

            engine.rootContext()->setContextProperty("fileList", text);
        }
    });

    timer.start(1000);

    engine.load(QUrl::fromLocalFile(
        QCoreApplication::applicationDirPath() + "/../qml/Main.qml"
    ));

    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}