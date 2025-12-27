import QtQuick 2.12
import QtQuick.Controls 2.5

ApplicationWindow {
    id: window
    visible: true
    width: 640
    height: 480
    title: qsTr("Tactic Board")

    property var tacticStorage: []//futbolcuların konumlarını tutan data

    //buradaki toolbar da seçilen formasyonların isimlerini tutan bir stack view yapısı ve formasyon seçme action u var
     header:ToolBar {
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
        ToolButton {display: AbstractButton.TextOnly; action: actionFormation}
        //yeni rakip formasyonu eklemek için bir action button
        ToolButton {display: AbstractButton.TextOnly; action: actionRFormation}
        }

    }
    //formasyon seçmeyi triggerlayan action bar
     Action {
         id: actionFormation
         text: qsTr("Formation")
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
          onTriggered: {
              //trigger olunca formasyon seçmek için liste içeren bir pop-up açılıyor
             formationPopup.action=true
             formationPopup.open()
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
                                     window.tacticStorage.push([ [], [], [] ]);
                                     dynamicMenuModel.append({
                                                                 "title": name,//formasyon ismi
                                                                 "defCount": def, // Defans sayısı
                                                                 "midCount": mid, // Orta saha sayısı
                                                                 "fwdCount": fwd, // Forvet sayısı
                                                                 "pageSource": stackPage, // Hangi sayfaya gideceği

                                                                 //rakip içinde veri ayırıyoruz
                                                                 "rivalDefCount": 0,
                                                                 "rivalMidCount": 0,
                                                                 "rivalFwdCount": 0
                                                             })
                                     }
                                     else{//rakip takım formasyon ekleme aksiyonu
                                         // stackView.currentItem.myrivaldefenders = def
                                         // stackView.currentItem.myrivalmiddfielders = mid
                                         // stackView.currentItem.myrivalforwards = fwd

                                         if (stackView.currentItem && stackView.currentItem.menuIndex !== undefined) {

                                                 var currentIndex = stackView.currentItem.menuIndex;

                                                 if (currentIndex !== -1) {
                                                     // 2. VERİYİ KALICI OLARAK MODELE YAZ
                                                     dynamicMenuModel.setProperty(currentIndex, "rivalDefCount", def);
                                                     dynamicMenuModel.setProperty(currentIndex, "rivalMidCount", mid);
                                                     dynamicMenuModel.setProperty(currentIndex, "rivalFwdCount", fwd);

                                                     // 3. EKRANI ANLIK GÜNCELLE (Kullanıcı değişikliği hemen görsün)
                                                     stackView.currentItem.myrivaldefenders = def;
                                                     stackView.currentItem.myrivalmiddfielders = mid;
                                                     stackView.currentItem.myrivalforwards = fwd;

                                                     console.log("Rakip takım kaydedildi. Index:", currentIndex, "Formasyon:", def, mid, fwd);
                                                 }
                                             }
                                     }
                                 }

         }
     }

     //burası bizim stack barda gözükecek formasyonların ayarlanacağı yer
    Drawer {
        id: drawer
        width: window.width * 0.17
        height: window.height


        //bu model yeni formasyonun ekleneceği model
        ListModel {
                id: dynamicMenuModel
            }

        Column {
            id:menuColumn
            anchors.fill: parent

            ItemDelegate {
                text: qsTr("Page 1")
                width: parent.width
                onClicked: {
                    stackView.push("Page1Form.ui.qml")
                    drawer.close()
                }
            }
            ItemDelegate {
                text: qsTr("Page 2")
                width: parent.width
                onClicked: {
                    stackView.push("Page2Form.ui.qml")
                    drawer.close()
                }
            }
            ItemDelegate {
                text: qsTr("Page 3")
                width: parent.width
                onClicked: {
                    stackView.push("Page3Form.ui.qml")
                    drawer.close()
                }
            }
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

    //tacticstorageye veriyi yazıyor
    function updateModelPosition(tacticIndex, pageIndex, playerIndex, x, y) {
            if (tacticIndex === -1) return;

            // 1. Veriyi tacticStorage'dan çek
            var allPagesData = window.tacticStorage[tacticIndex];

            // Eğer veri henüz yoksa oluştur
            if (!allPagesData) {
                allPagesData = [[], [], []];
            }

            // 2. İlgili sayfayı kontrol et
            if (!allPagesData[pageIndex]) {
                allPagesData[pageIndex] = [];
            }

            // 3. Eksik indeksleri doldur (Array boşluklarını doldur)
            while (allPagesData[pageIndex].length <= playerIndex) {
                allPagesData[pageIndex].push({ x: 0, y: 0 });
            }

            // 4. Veriyi güncelle
            allPagesData[pageIndex][playerIndex] = { x: x, y: y };

            // 5. Depoya geri yaz
            window.tacticStorage[tacticIndex] = allPagesData;

            console.log("KAYIT BAŞARILI (Storage): Tactic", tacticIndex, "Page", pageIndex, "XY:", x, y);

            // 6. Ekrana Canlı Yansıt
            if (stackView.currentItem && stackView.currentItem.menuIndex === tacticIndex) {
                stackView.currentItem.savedPositions = allPagesData;
            }
        }
    }
