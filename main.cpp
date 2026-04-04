#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QDebug>

#include "player.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    Player player;

    engine.rootContext()->setContextProperty("player", &player);
    engine.rootContext()->setContextProperty("fileList", QString(""));

    engine.load(QUrl::fromLocalFile(
        QCoreApplication::applicationDirPath() + "/../qml/Main.qml"
    ));

    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}