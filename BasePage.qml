import QtQuick
import QtQuick.Controls

Item {
    id: root
    //arka plan rengi
    property color backcolor:"green"

    //pozisyonda oynayan oyuncu sayıları
    property int mydefenders: 0
    property int mymiddfielders: 0
    property int myforwards: 0

    //burada 3 ekran var.takım dizilişi,toplu oyun,topsuz oyun
    SwipeView {
        id: view
        anchors.fill: parent
        currentIndex: 0

        // --- TAKIM DİZİLİŞİ ---
        Item {
            MyBackground{z:0}
            Footballer {
                x:40
                y:40
                width:20
                height: 20
            }
        }

        // --- TOPLU OYUN ---
        Item {
            //arka plan
            MyBackground{background: backcolor;z:0}

            //formasyona göre tahtaya diziliş
            DefaultFormation{
                defenders: mydefenders
                middfielders: mymiddfielders
                forwards: myforwards
            }

        }

        // --- TOPSUZ OYUN ---
        Item {
            MyBackground{}
        }
    }

    PageIndicator {
        anchors.bottom: parent.bottom
        currentIndex: view.currentIndex
        count: view.count
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
