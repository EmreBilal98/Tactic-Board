import QtQuick

Item {
    id:root
    anchors.fill: parent

    //pozisyon->oynayan oyuncu sayısı değerleri
    property int defenders: 0
    property int middfielders: 0
    property int forwards: 0
    property int rivaldefenders: 0
    property int rivalmiddfielders: 0
    property int rivalforwards: 0
    property int spaceRate:4

    //yatayda kaleci-defans-ortasaha-forvet sırasıyla tutacak satır
    Row{
        id: row
        anchors.verticalCenter: parent.verticalCenter
        anchors.left:parent.left
        anchors.leftMargin: 25
        spacing:(parent.width-200)/spaceRate

        //kaleci(column içinde olmazsa sadece horizontal harekete izin veriyor anchors.berticalcenter satırı.)
        Column{
        visible: (forwards) ? true : false
        anchors.verticalCenter: parent.verticalCenter//dikey ortalar
        Footballer{
            id:goalkeeper
            width:root.width/20
            height: root.width/20
        }
        }


        //defans
        Column{
            anchors.verticalCenter: parent.verticalCenter//dikey ortalar
            spacing: 40
            Repeater {
                model: defenders

                delegate: Footballer {
                    width: root.width/20
                    height: root.width/20
                }
            }

        }

        //orta saha
        Column{
            anchors.verticalCenter: parent.verticalCenter//dikey ortalar
            spacing: 40
            Repeater {
                model: middfielders

                delegate: Footballer {
                    width: root.width/20
                    height: root.width/20
                }
            }

        }

        //forvet
        Column{
            anchors.verticalCenter: parent.verticalCenter//dikey ortalar
            spacing: 40
            Repeater {
                model: forwards

                delegate: Footballer {
                    width: root.width/20
                    height: root.width/20
                }
            }

        }


    }
    Row {
        visible: (rivalforwards) ? true : false
        anchors.verticalCenter: parent.verticalCenter
        anchors.right:parent.right
        anchors.rightMargin: 25
        spacing:(parent.width-200)/spaceRate

        //rakip forvet
        Column{
            anchors.verticalCenter: parent.verticalCenter//dikey ortalar
            spacing: 40
            Repeater {
                model: rivalforwards

                delegate: Footballer {
                    color: "yellow"
                    width: root.width/20
                    height: root.width/20
                }
            }

        }

        //rakip ortasaha
        Column{
            anchors.verticalCenter: parent.verticalCenter//dikey ortalar
            spacing: 40
            Repeater {
                model: rivalmiddfielders

                delegate: Footballer {
                    color: "yellow"
                    width: root.width/20
                    height: root.width/20
                }
            }

        }

        //rakip defans
        Column{
            anchors.verticalCenter: parent.verticalCenter//dikey ortalar
            spacing: 40
            Repeater {
                model: rivaldefenders

                delegate: Footballer {
                    color: "yellow"
                    width: root.width/20
                    height: root.width/20
                }
            }

        }

        //rakip kaleci
        Column{
        anchors.verticalCenter: parent.verticalCenter//dikey ortalar
        Footballer{
            color: "yellow"
            width:root.width/20
            height: root.width/20
        }
        }
    }


}
