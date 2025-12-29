#ifndef DATABASE_H
#define DATABASE_H

#include <QObject>
#include <QStandardPaths>
#include <QDir>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QDebug>
#include <QVariantMap>
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>


class Database : public QObject
{
    Q_OBJECT
public:
    explicit Database(QObject *parent = nullptr);
    ~Database();

    // Veritabanını başlatır ve tablo yoksa oluşturur
    Q_INVOKABLE void init();

    // Yeni bir formasyon ekler (Pozisyonları JSON string olarak saklarız)
    Q_INVOKABLE bool addFormation(const QString &title, int def, int mid, int fwd,
                                  int rDef, int rMid, int rFwd, const QVariant &positions);

    // Mevcut bir formasyonu günceller (Örn: oyuncu yeri değişince)
    Q_INVOKABLE bool updateFormationPositions(int id, const QVariant &positions);

    // Formasyonu siler
    Q_INVOKABLE bool removeFormation(int id);

    // Tüm formasyonları QML'e uygun bir liste olarak döndürür
    Q_INVOKABLE QVariantList loadFormations();

    //rakip sayısını günceeller
    Q_INVOKABLE bool updateRivalCounts(int id, int rDef, int rMid, int rFwd);

private:
    QSqlDatabase m_db;
};

#endif // DATABASE_H
