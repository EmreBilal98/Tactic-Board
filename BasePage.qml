import QtQuick
import QtQuick.Controls

Item {
    id: broot
    //arka plan rengi
    property color backcolor:"green"

    //pozisyonda oynayan oyuncu sayıları
    property int mydefenders: 0
    property int mymiddfielders: 0
    property int myforwards: 0
    property int myrivaldefenders: 0
    property int myrivalmiddfielders: 0
    property int myrivalforwards: 0
    property int menuIndex: -1
    property var savedPositions: [[], [], []]

    // --- KRİTİK DÜZELTME: SAYFA AÇILINCA VERİYİ ÇEK ---
        Component.onCompleted: {
            forceFetchData();
        }

        function forceFetchData() {
                console.log(">>> SAYFA AÇILIYOR (BasePage) - Index:", menuIndex)

                if (menuIndex === -1) return;

                // --- DEĞİŞİKLİK: Veriyi window.tacticStorage'dan çek ---
                // window id'si Main.qml'de tanımlı olduğu için erişebiliriz.
                var data = window.tacticStorage[menuIndex];

                if (data) {
                    console.log("VERİ BULUNDU (Storage). Sayfa 0 Uzunluk:", data[0] ? data[0].length : 0)
                    // Veriyi kopyalayarak al (Referans hatasını önlemek için)
                    // JSON parse/stringify en temiz derin kopyalama yöntemidir.
                    savedPositions = JSON.parse(JSON.stringify(data));
                } else {
                    console.log("UYARI: Veri henüz yok (Boş başlatılıyor).")
                    savedPositions = [[], [], []];
                }
            }

    // Bu fonksiyonu DefaultFormation çağıracak
    function handlePositionSave(pageIndex, playerIndex, x, y) {
            // Main.qml'deki global fonksiyonu çağırıyoruz
            // Main.qml root id'si "window" olduğu için window.updateModelPosition diyebiliriz
            // veya scope chain sayesinde direkt fonksiyon adını yazabiliriz.
            updateModelPosition(menuIndex, pageIndex, playerIndex, x, y)
    }

    //burada 3 ekran var.takım dizilişi,toplu oyun,topsuz oyunbasepage.qml
    SwipeView {
        id: view
        anchors.fill: parent
        currentIndex: 0

        // --- TAKIM DİZİLİŞİ ---
        Item {
            MyBackground{z:0}
            //formasyona göre tahtaya diziliş
            DefaultFormation{
                property int pageId: 0//sayfanın özel id si(takım diziliş = 0)

                inputPositions: (broot.savedPositions && broot.savedPositions[0]) ? broot.savedPositions[0] : []
                defenders: mydefenders
                middfielders: mymiddfielders
                forwards: myforwards

                // DefaultFormation içinden bir oyuncu hareket edince bu sinyali tetiklemeli
                onPlayerMoved: (pIndex, px, py) => broot.handlePositionSave(pageId, pIndex, px, py)
            }
        }

        // --- TOPLU OYUN ---
        Item {
            //arka plan
            MyBackground{background: backcolor;z:0}

            //formasyona göre tahtaya diziliş
            DefaultFormation{
                property int pageId: 1//sayfanın özel id si(toplu oyun = 1)

                inputPositions: (broot.savedPositions && broot.savedPositions[1]) ? broot.savedPositions[1] : []
                spaceRate: 10
                defenders: mydefenders
                middfielders: mymiddfielders
                forwards: myforwards
                rivaldefenders: myrivaldefenders
                rivalmiddfielders: myrivalmiddfielders
                rivalforwards: myrivalforwards

                // DefaultFormation içinden bir oyuncu hareket edince bu sinyali tetiklemeli
                onPlayerMoved: (pIndex, px, py) => broot.handlePositionSave(pageId, pIndex, px, py)
            }

        }

        // --- TOPSUZ OYUN ---
        Item {
            //arka plan
            MyBackground{background: backcolor;z:0}

            //formasyona göre tahtaya diziliş
            DefaultFormation{
                property int pageId: 2//sayfanın özel id si(topsuz oyun = 2)

                // Modelden gelen verinin SADECE 0. indeksini (bu sayfanın verisini) gönderiyoruz
                                // Kontrol ekliyoruz: savedPositions var mı? Varsa 0. elemanı var mı?
                inputPositions: (broot.savedPositions && broot.savedPositions[2]) ? broot.savedPositions[2] : []
                spaceRate: 10
                defenders: mydefenders
                middfielders: mymiddfielders
                forwards: myforwards
                rivaldefenders: myrivaldefenders
                rivalmiddfielders: myrivalmiddfielders
                rivalforwards: myrivalforwards

                // DefaultFormation içinden bir oyuncu hareket edince bu sinyali tetiklemeli
                onPlayerMoved: (pIndex, px, py) => broot.handlePositionSave(pageId, pIndex, px, py)
            }
        }
    }

    //hangi sayfada olunduğunu gösteren indikatör
    PageIndicator {
        anchors.bottom: parent.bottom
        currentIndex: view.currentIndex
        count: view.count
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
