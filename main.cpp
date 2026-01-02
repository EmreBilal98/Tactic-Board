#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "database.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    Database db;
    db.init();// Veritabanını başlat
    db.initLogin();//login tablosu yoksa oluştur

    QQmlApplicationEngine engine;

    // C++ nesnesini QML'e tanıtıyoruz
    engine.rootContext()->setContextProperty("dbManager", &db);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("tactic_board", "Main");

    return app.exec();
}
