import QtQuick 2.12
import QtQuick.Controls 2.5


ApplicationWindow {
    id: window
    visible: true
    width: 640
    height: 480
    title: qsTr("Tactic Board")

    property bool isLoggedIn: false//login kontrol değişkeni

    property var tacticStorage: []//futbolcuların konumlarını tutan data
    property var rivalTacticStorage: []//rakip futbolcuların konumlarını tutan data

    // --- UYGULAMA AÇILINCA VERİLERİ YÜKLE ---
        Component.onCompleted: {
            var savedList = dbManager.loadFormations();
            console.log("Veritabanından yüklenen formasyon sayısı:", savedList.length);

            //tacticStorage'ı sıfırla (Çift kayıt olmasın)
            window.tacticStorage = [];
            window.rivalTacticStorage = [];
            dynamicMenuModel.clear();

            for (var i = 0; i < savedList.length; i++) {
                var item = savedList[i];

                // Depoya pozisyonları ekle
                window.tacticStorage.push(item.positions);

                //varsa rakip pozisyonları yoksa boş arrayi ata
                var rPos = item.rivalPositions ? item.rivalPositions : [[],[],[]];
                window.rivalTacticStorage.push(rPos);

                // Menüye ekle (Veritabanı ID'sini de modele ekliyoruz!)
                dynamicMenuModel.append({
                    "dbId": item.id, // Veritabanı ID'si (Update için gerekli)
                    "title": item.title,
                    "defCount": item.defCount,
                    "midCount": item.midCount,
                    "fwdCount": item.fwdCount,
                    "rivalDefCount": item.rivalDefCount,
                    "rivalMidCount": item.rivalMidCount,
                    "rivalFwdCount": item.rivalFwdCount,
                    "pageSource": stackPage
                })
                console.log("Yüklenen Taktik:", item.title, "DB ID:", item.id);
            }
        }

    //buradaki toolbar da seçilen formasyonların isimlerini tutan bir stack view yapısı ve formasyon seçme action u var
     header:ToolBar {
        visible: isLoggedIn
        contentHeight: toolButton.implicitHeight

        //toolbar arka planı
        background: Rectangle {
                implicitHeight: 30
                color: "#C2D6D6"
        }

        Row{
        spacing:10

        //bu toolbutton formasyonların view larını tutan bir buton
        ToolButton {
            id: toolButton
            text: stackView.depth > 1 ? "\u25C0" : "\u2630"
            font.pixelSize: Qt.application.font.pixelSize * 1.6
            onClicked: {
                if (stackView.depth > 1) {
                    stackView.pop()
                } else {
                    drawer.open()
                }
            }
        }
        //yeni formasyon eklemek için bir action button
        ToolButton {display: AbstractButton.IconOnly; action: actionFormation;icon.width: 28;icon.height: 28}
        //yeni rakip formasyonu eklemek için bir action button
        ToolButton {display: AbstractButton.IconOnly; action: actionRFormation;icon.width: 28;icon.height: 28}
        //formasyon silmek için bir action button
        ToolButton {display: AbstractButton.IconOnly; action: removeFormation;icon.width: 28;icon.height: 28}
        }

    }
    //formasyon seçmeyi triggerlayan action bar
     Action {
         id: actionFormation
         text: qsTr("Formation")
         icon.source: "qrc:/plus.png"
         onTriggered: {
             //trigger olunca formasyon seçmek için liste içeren bir pop-up açılıyor
            formationPopup.action=false
            formationPopup.open()
         }
     }

     //rakip formasyonu seçmeyi triggerlayan action bar
      Action {
          id: actionRFormation
          text: qsTr("RivalFormation")
          icon.source: "qrc:/competition.png"
          onTriggered: {
              //trigger olunca formasyon seçmek için liste içeren bir pop-up açılıyor
             formationPopup.action=true
             formationPopup.open()
          }
      }

      //rakip formasyonu seçmeyi triggerlayan action bar
       Action {
           id: removeFormation
           text: qsTr("RemoveFormation")
           icon.source: "qrc:/delete.png"
           onTriggered: {
               //trigger olunca formasyon seçmek için liste içeren bir pop-up açılıyor
              rformationPopup.open()
           }
       }

     //formasyon seçme aksiyonunun pop-up ı
     Popup {
         id:formationPopup
         anchors.centerIn: parent
         width:200
         height:200
         modal: true
         focus: true
         closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
         clip:true

         property bool action:false//0 ise kendi takımın 1 ise rakip takım ayarlanacak

         //içinde formasyonlar içeren liste
         ListView {
             id: listView
             focus: true
             anchors.fill:parent
             delegate: FormationDelegate {}
             model: FormationModel {}

             //bu sinyal sayesinde seçilen formasyonun ismi(stack bara yazılıyor) defender,middfielder,forwards değerlerine
             //göre de değerler alınıp playerları pozisyona yerleştirmede kullanılacak
             signal formationSelected(string name, int def, int mid, int fwd)

             onFormationSelected:(name,def,mid,fwd)=>{
                                     if(!formationPopup.action){//takım formasyon ekleme aksiyonu

                                         var emptyPos = [[], [], []];

                                         var jsonString = JSON.stringify(emptyPos);

                                         // C++ Veritabanına Ekle
                                         // addFormation fonksiyonu parametreleri: title, def, mid, fwd, rDef, rMid, rFwd, positions
                                         var newDbId =dbManager.addFormation(name, def, mid, fwd, 0, 0, 0, jsonString);

                                        console.log("Yeni Kayıt -> ID:", newDbId, " Data:", jsonString);

                                         window.tacticStorage.push(emptyPos);
                                         window.rivalTacticStorage.push([[],[],[]]);
                                         dynamicMenuModel.append({
                                                                     "dbId": newDbId, // Geçici ID, restartta düzelir
                                                                     "title": name,
                                                                     "defCount": def,
                                                                     "midCount": mid,
                                                                     "fwdCount": fwd,
                                                                     "rivalDefCount": 0,
                                                                     "rivalMidCount": 0,
                                                                     "rivalFwdCount": 0,
                                                                     "pageSource": stackPage
                                                                 })
                                     }
                                     else{//rakip takım formasyon ekleme aksiyonu

                                         // 1. Açık olan sayfanın indeksini ve model verisini al
                                         if (stackView.currentItem && stackView.currentItem.menuIndex !== -1) {

                                             var currentIndex = stackView.currentItem.menuIndex;
                                             var modelItem = dynamicMenuModel.get(currentIndex);

                                             // 2. Önce EKRANI güncelle (Anlık değişim için)
                                             stackView.currentItem.myrivaldefenders = def;
                                             stackView.currentItem.myrivalmiddfielders = mid;
                                             stackView.currentItem.myrivalforwards = fwd;

                                             // 3. Modeli güncelle (Menüde veri tutarsızlığı olmasın)
                                             dynamicMenuModel.setProperty(currentIndex, "rivalDefCount", def);
                                             dynamicMenuModel.setProperty(currentIndex, "rivalMidCount", mid);
                                             dynamicMenuModel.setProperty(currentIndex, "rivalFwdCount", fwd);

                                             // 4. VERİTABANINA KAYDET
                                             if (modelItem && modelItem.dbId !== undefined && modelItem.dbId !== -1) {
                                                 // C++ fonksiyonunu çağırıyoruz
                                                 dbManager.updateRivalCounts(modelItem.dbId, def, mid, fwd);
                                             } else {
                                                 console.log("HATA: DB ID bulunamadı, rakip kaydedilemedi.");
                                             }
                                         }

                                     }
                                 }

         }
     }

     Popup {
         id:rformationPopup
         anchors.centerIn: parent
         width:200
         height:200
         modal: true
         focus: true
         closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
         clip:true

         property bool action:false//0 ise kendi takımın 1 ise rakip takım ayarlanacak

         //içinde formasyonlar içeren liste
         ListView {
             id: rlistView
             focus: true
             anchors.fill:parent
             delegate: FormationDelegate {ltext: model.title;deleteMode: true}
             model: dynamicMenuModel

             //bu sinyal sayesinde seçilen formasyonun ismi(stack bara yazılıyor) defender,middfielder,forwards değerlerine
             //göre de değerler alınıp playerları pozisyona yerleştirmede kullanılacak
             signal formationDeleteRequested(int Index)

             onFormationDeleteRequested:(Index)=>{

                window.deleteFormationByIndex(Index)

             }

         }
     }

     //burası bizim stack barda gözükecek formasyonların ayarlanacağı yer
    Drawer {
        id: drawer
        width: window.width * 0.17
        height: window.height

        interactive: isLoggedIn


        //bu model yeni formasyonun ekleneceği model
        ListModel {
                id: dynamicMenuModel
            }

        Column {
            id:menuColumn
            anchors.fill: parent
            //modeldeki verilere göre formasyon ismi item ismi oluyor ve pozisyondaki oyuncu verileri
            //formasyona ait düzenlenecek qml e gönderiliyor
            Repeater {
                model: dynamicMenuModel
                delegate: ItemDelegate {
                    text: model.title  // Modelden gelen isim
                    width: menuColumn.width
                    onClicked: {
                        //burada mydefender,mymiddfielders ve myforwards propertylerine değerler yazılıyor
                        stackView.push(model.pageSource,{
                                           "mydefenders": model.defCount,
                                           "mymiddfielders": model.midCount,
                                           "myforwards": model.fwdCount,
                                           "menuIndex": index,// Modeldeki sırasını bilsin ki oraya geri yazsın
                                           "myrivaldefenders": model.rivalDefCount,
                                           "myrivalmiddfielders": model.rivalMidCount,
                                           "myrivalforwards": model.rivalFwdCount
                                       }) // Modelden gelen sayfa yolu
                        drawer.close()
                    }
                }
            }
        }
    }

    //açılış ekranı ayarlanıyor
    StackView {
        id: stackView
        initialItem: mainPage
        anchors.fill: parent
    }

    //ana ekran
    Component {
            id: mainPage
            BasePage {}
        }

    //formasyona özel özelleşen ekran
    Component {
            id: stackPage
            BasePage {}
        }

    MyLogin{}


    //tacticstorageye veriyi yazıyor
    function updateModelPosition(tacticIndex, pageIndex, playerIndex, x, y) {
        if (tacticIndex === -1) return;

        // ---------------------------------------------------------
        // 1. ADIM: RAM (window.tacticStorage) GÜNCELLEMESİ
        // ---------------------------------------------------------
        var allPagesData = window.tacticStorage[tacticIndex];

        // Veri yoksa oluştur
        if (!allPagesData) {
            allPagesData = [[], [], []];
        }

        // İlgili sayfayı kontrol et
        if (!allPagesData[pageIndex]) {
            allPagesData[pageIndex] = [];
        }

        // Eksik indeksleri doldur (Array boşluklarını doldur)
        while (allPagesData[pageIndex].length <= playerIndex) {
            allPagesData[pageIndex].push({ x: 0, y: 0 });
        }

        // Veriyi güncelle
        allPagesData[pageIndex][playerIndex] = { x: x, y: y };

        // Depoya geri yaz
        window.tacticStorage[tacticIndex] = allPagesData;

        console.log("RAM Güncellendi: Tactic", tacticIndex, "XY:", x, y);

        // ---------------------------------------------------------
        // 2. ADIM: EKRAN (CANLI) GÜNCELLEMESİ
        // ---------------------------------------------------------
        if (stackView.currentItem && stackView.currentItem.menuIndex === tacticIndex) {
            stackView.currentItem.savedPositions = allPagesData;
        }

        // ---------------------------------------------------------
        // 3. ADIM: VERİTABANI (SQLITE) GÜNCELLEMESİ [YENİ KISIM]
        // ---------------------------------------------------------

        // Modelden bu taktiğin gerçek veritabanı ID'sini (dbId) alıyoruz.
        var modelItem = dynamicMenuModel.get(tacticIndex);

        // modelItem bazen undefined olabilir, kontrol edelim
        // if (modelItem) {
        //     var dbId = modelItem.dbId;

        //     // Eğer geçerli bir ID varsa C++ tarafını çağır
        //     // dbId: Veritabanındaki satır ID'si
        //     // allPagesData: Güncel koordinatların tamamı
        //     if (dbId !== undefined && dbId !== -1) {
        //         dbManager.updateFormationPositions(dbId, allPagesData);
        //         console.log("SQLITE Güncellendi -> DB ID:", dbId);
        //     } else {
        //         console.log("UYARI: DB ID bulunamadı, veritabanına yazılamadı.");
        //     }
        // }
        if (modelItem && modelItem.dbId !== undefined && modelItem.dbId !== -1) {

            // --- DEĞİŞİKLİK BURADA ---
            // JavaScript nesnesini String formatına paketliyoruz
            var jsonString = JSON.stringify(allPagesData);

            console.log("C++'a Giden String:", jsonString); // Log ile kontrol edin

            // Artık nesneyi değil, bu stringi gönderiyoruz
            dbManager.updateFormationPositions(modelItem.dbId, jsonString);

        } else {
            console.log("HATA: DB ID bulunamadı.");
        }


    }

    function updateRivalModelPosition(tacticIndex, pageIndex, playerIndex, x, y) {
            if (tacticIndex === -1) return;

            // ---------------------------------------------------------
            // 1. ADIM: RAM (window.rivalTacticStorage) GÜNCELLEMESİ
            // ---------------------------------------------------------
            // DİKKAT: Burada 'tacticStorage' değil 'rivalTacticStorage' kullanıyoruz
            var allPagesData = window.rivalTacticStorage[tacticIndex];

            // Veri yoksa oluştur
            if (!allPagesData) {
                allPagesData = [[], [], []];
            }

            // İlgili sayfayı kontrol et
            if (!allPagesData[pageIndex]) {
                allPagesData[pageIndex] = [];
            }

            // Eksik indeksleri doldur
            while (allPagesData[pageIndex].length <= playerIndex) {
                allPagesData[pageIndex].push({ x: 0, y: 0 });
            }

            // Veriyi güncelle
            allPagesData[pageIndex][playerIndex] = { x: x, y: y };

            // Depoya geri yaz
            window.rivalTacticStorage[tacticIndex] = allPagesData;

            console.log("RAKİP RAM Güncellendi: Tactic", tacticIndex, "XY:", x, y);

            // ---------------------------------------------------------
            // 2. ADIM: EKRAN (CANLI) GÜNCELLEMESİ
            // ---------------------------------------------------------
            if (stackView.currentItem && stackView.currentItem.menuIndex === tacticIndex) {
                // DİKKAT: BasePage'deki 'rivalSavedPositions' değişkenini güncelliyoruz
                stackView.currentItem.rivalSavedPositions = allPagesData;
            }

            // ---------------------------------------------------------
            // 3. ADIM: VERİTABANI (SQLITE) GÜNCELLEMESİ
            // ---------------------------------------------------------
            var modelItem = dynamicMenuModel.get(tacticIndex);

            if (modelItem && modelItem.dbId !== undefined && modelItem.dbId !== -1) {

                // JavaScript nesnesini String formatına paketliyoruz
                var jsonString = JSON.stringify(allPagesData);

                console.log("C++'a Giden RAKİP String:", jsonString);

                // DİKKAT: C++ tarafındaki YENİ fonksiyonu çağırıyoruz (updateRivalPositions)
                // Bu fonksiyonu DatabaseManager.cpp'ye eklemiştik
                dbManager.updateRivalPositions(modelItem.dbId, jsonString);

            } else {
                console.log("HATA: DB ID bulunamadı (Rakip Kayıt).");
            }
        }

    function deleteFormationByIndex(listIndex) {
            // 1. Modelden o satırın verisini çek
            var modelItem = dynamicMenuModel.get(listIndex);

            // Eğer modelde veri yoksa işlem yapma
            if (!modelItem) return;

            // 2. ID'yi modelin içinden al
            var dbId = modelItem.dbId;

            console.log("Siliniyor -> Index:", listIndex, " DB ID:", dbId, " İsim:", modelItem.title);

            // 3. Veritabanından Sil (ID geçerliyse)
            if (dbId !== undefined && dbId !== -1) {
                var success = dbManager.removeFormation(dbId);

                if (!success) {
                    console.log("HATA: Veritabanından silinemedi.");
                    return;
                }
            }

            // 4. Görsel Listeden (Modelden) Sil
            dynamicMenuModel.remove(listIndex);

            // 5. Eğer tacticStorage (pozisyon dizisi) kullanıyorsan onu da senkronize et
            // (Eğer tacticStorage kullanmıyorsan bu satırı silebilirsin)
            if (window.tacticStorage && window.tacticStorage.length > listIndex) {
                window.tacticStorage.splice(listIndex, 1);
            }

            console.log("Başarıyla Silindi.");
        }
}
