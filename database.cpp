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

    // Eğer çeviri sonucu boşsa, "null" ise veya çok kısaysa,
    // Veritabanına NULL gitmesin diye elle varsayılan boş yapıyı yazıyoruz.
    if (jsonPositions.isEmpty() || jsonPositions == "null" || jsonPositions == "") {
        qDebug() << "UYARI: Gelen pozisyon verisi boş, varsayılan değer atanıyor.";
        jsonPositions = "[[],[],[]]"; // 3 Sayfalık boş yapı
    }

    qDebug() << "DB INSERTING POSITIONS:" << jsonPositions; // Kontrol için log

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
    // Veriyi JSON'a çevir
    QJsonDocument doc = QJsonDocument::fromVariant(positions);
    QString jsonPositions = doc.toJson(QJsonDocument::Compact);

    // --- LOG 1: C++'a veri geldi mi? ---
    qDebug() << "C++ UPDATE ÇAĞRILDI -> ID:" << id << " DATA UZUNLUK:" << jsonPositions.length();
    // Verinin içeriğini de görelim (Kısa halini)
    qDebug() << "DATA:" << jsonPositions;

    QSqlQuery query;
    query.prepare("UPDATE formations SET positions = :pos WHERE id = :id");
    query.bindValue(":pos", jsonPositions);
    query.bindValue(":id", id);

    if (!query.exec()) {
        // --- LOG 2: SQL Hatası var mı? ---
        qDebug() << "!!! SQL UPDATE HATASI !!! :" << query.lastError().text();
        return false;
    }

    qDebug() << ">>> SQL UPDATE BAŞARILI <<<";
    return true;
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

bool Database::updateRivalCounts(int id, int rDef, int rMid, int rFwd)
{
    qDebug() << "Rakip Güncelleniyor -> ID:" << id << " D:" << rDef << " M:" << rMid << " F:" << rFwd;

    QSqlQuery query;
    // Sadece rakip sütunlarını güncelliyoruz
    query.prepare("UPDATE formations SET rival_def = :rd, rival_mid = :rm, rival_fwd = :rf WHERE id = :id");

    query.bindValue(":rd", rDef);
    query.bindValue(":rm", rMid);
    query.bindValue(":rf", rFwd);
    query.bindValue(":id", id);

    if (!query.exec()) {
        qDebug() << "Rakip güncelleme hatası:" << query.lastError().text();
        return false;
    }
    return true;
}




