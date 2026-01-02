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

    // Veritabanını başlatır ve tablo yoksa oluşturur
    Q_INVOKABLE void initLogin();

    // Yeni bir formasyon ekler (Pozisyonları JSON string olarak saklarız)
    Q_INVOKABLE int addFormation(const QString &title, int def, int mid, int fwd,
                                  int rDef, int rMid, int rFwd, const QString &positions);

    //yeni kullanıcı ekler
    Q_INVOKABLE bool addUser(const QString &name, const QString &password);

    // Mevcut bir formasyonu günceller (Örn: oyuncu yeri değişince)
    Q_INVOKABLE bool updateFormationPositions(int id, const QString &positions);

    // Mevcut bir kullanıcıyı günceller
    Q_INVOKABLE bool updateUser(const QString &name, const QString &password);

    // Formasyonu siler
    Q_INVOKABLE bool removeFormation(int id);

    // Tüm formasyonları QML'e uygun bir liste olarak döndürür
    Q_INVOKABLE QVariantList loadFormations();

    // id bilgisini çeker
     int GetID(const QString &name,const QString &password);

    // user bilgisini çeker
    Q_INVOKABLE QVariantMap loadUser();



    //rakip sayısını günceller
    Q_INVOKABLE bool updateRivalCounts(int id, int rDef, int rMid, int rFwd);

    Q_INVOKABLE bool updateRivalPositions(int id, const QString &jsonString);

private:
    QSqlDatabase m_db;
};

#endif // DATABASE_H
