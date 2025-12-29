#include "database.h"

Database::Database(QObject *parent)
    : QObject{parent}
{
    // Veritabanı dosyasını ayarla
    m_db = QSqlDatabase::addDatabase("QSQLITE");

    // Raspberry Pi veya PC'de yazılabilir bir klasör seçiyoruz
    QString path = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    QDir dir(path);
    if (!dir.exists()) dir.mkpath(".");

    QString dbPath = path + "/tactic_board.db";
    m_db.setDatabaseName(dbPath);

    qDebug() << "Veritabanı Yolu:" << dbPath;
}

Database::~Database()
{
    if(m_db.isOpen()) m_db.close();
}

void Database::init()
{
    if (!m_db.open()) {
        qDebug() << "Veritabanı açılamadı:" << m_db.lastError();
        return;
    }

    QSqlQuery query;
    // Tabloyu oluştur: ID, Başlık, Oyuncu Sayıları ve Pozisyonlar (TEXT olarak)
    QString createTable = R"(
        CREATE TABLE IF NOT EXISTS formations (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            def_count INTEGER,
            mid_count INTEGER,
            fwd_count INTEGER,
            rival_def INTEGER,
            rival_mid INTEGER,
            rival_fwd INTEGER,
            positions TEXT
        )
    )";

    if (!query.exec(createTable)) {
        qDebug() << "Tablo oluşturma hatası:" << query.lastError();
    }
}

bool Database::addFormation(const QString &title, int def, int mid, int fwd, int rDef, int rMid, int rFwd, const QVariant &positions)
{
    // QML'den gelen JS Array'i JSON String'e çevir
    QJsonDocument doc = QJsonDocument::fromVariant(positions);
    QString jsonPositions = doc.toJson(QJsonDocument::Compact);

    QSqlQuery query;
    query.prepare("INSERT INTO formations (title, def_count, mid_count, fwd_count, "
                  "rival_def, rival_mid, rival_fwd, positions) "
                  "VALUES (:title, :def, :mid, :fwd, :rDef, :rMid, :rFwd, :pos)");

    query.bindValue(":title", title);
    query.bindValue(":def", def);
    query.bindValue(":mid", mid);
    query.bindValue(":fwd", fwd);
    query.bindValue(":rDef", rDef);
    query.bindValue(":rMid", rMid);
    query.bindValue(":rFwd", rFwd);
    query.bindValue(":pos", jsonPositions);

    if(!query.exec()) {
        qDebug() << "Ekleme hatası:" << query.lastError();
        return false;
    }
    return true;

}

bool Database::updateFormationPositions(int id, const QVariant &positions)
{
    QJsonDocument doc = QJsonDocument::fromVariant(positions);
    QString jsonPositions = doc.toJson(QJsonDocument::Compact);

    QSqlQuery query;
    query.prepare("UPDATE formations SET positions = :pos WHERE id = :id");
    query.bindValue(":pos", jsonPositions);
    query.bindValue(":id", id);

    return query.exec();
}

bool Database::removeFormation(int id)
{
    QSqlQuery query;
    query.prepare("DELETE FROM formations WHERE id = :id");
    query.bindValue(":id", id);
    return query.exec();
}

QVariantList Database::loadFormations()
{
    QVariantList list;
    QSqlQuery query("SELECT * FROM formations");

    while (query.next()) {
        QVariantMap map;
        map["id"] = query.value("id");
        map["title"] = query.value("title");
        map["defCount"] = query.value("def_count");
        map["midCount"] = query.value("mid_count");
        map["fwdCount"] = query.value("fwd_count");
        map["rivalDefCount"] = query.value("rival_def");
        map["rivalMidCount"] = query.value("rival_mid");
        map["rivalFwdCount"] = query.value("rival_fwd");

        // JSON String'i geri QVariant (JS Array)'e çevir
        QString jsonStr = query.value("positions").toString();
        QJsonDocument doc = QJsonDocument::fromJson(jsonStr.toUtf8());
        map["positions"] = doc.toVariant();

        list.append(map);
    }
    return list;
}




