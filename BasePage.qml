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
    property int myrivaldefenders: 0
    property int myrivalmiddfielders: 0
    property int myrivalforwards: 0

    //burada 3 ekran var.takım dizilişi,toplu oyun,topsuz oyun
    SwipeView {
        id: view
        anchors.fill: parent
        currentIndex: 0

        // --- TAKIM DİZİLİŞİ ---
        Item {
            MyBackground{z:0}
            //formasyona göre tahtaya diziliş
            DefaultFormation{
                defenders: mydefenders
                middfielders: mymiddfielders
                forwards: myforwards
            }
        }

        // --- TOPLU OYUN ---
        Item {
            //arka plan
            MyBackground{background: backcolor;z:0}

            //formasyona göre tahtaya diziliş
            DefaultFormation{
                spaceRate: 10
                defenders: mydefenders
                middfielders: mymiddfielders
                forwards: myforwards
                rivaldefenders: myrivaldefenders
                rivalmiddfielders: myrivalmiddfielders
                rivalforwards: myrivalforwards
            }

        }

        // --- TOPSUZ OYUN ---
        Item {
            //arka plan
            MyBackground{background: backcolor;z:0}

            //formasyona göre tahtaya diziliş
            DefaultFormation{
                spaceRate: 10
                defenders: mydefenders
                middfielders: mymiddfielders
                forwards: myforwards
                rivaldefenders: myrivaldefenders
                rivalmiddfielders: myrivalmiddfielders
                rivalforwards: myrivalforwards
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
