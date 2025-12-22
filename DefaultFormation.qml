import QtQuick

Item {
    id:root
    anchors.fill: parent

    //pozisyon->oynayan oyuncu sayısı değerleri
    property int defenders: 0
    property int middfielders: 0
    property int forwards: 0

    //yatayda kaleci-defans-ortasaha-forvet sırasıyla tutacak satır
    Row{
        id: row
        anchors.centerIn: parent
        spacing:(parent.width-200)/4

        //kaleci
        Footballer{
            anchors.verticalCenter: parent.verticalCenter
            width:40
            height: 40
        }


        //defans
        Column{
            anchors.verticalCenter: parent.verticalCenter
            spacing: 20
            Repeater {
                model: defenders

                delegate: Footballer {
                    width: 40
                    height: 40
                }
            }

        }

        //orta saha
        Column{
            anchors.verticalCenter: parent.verticalCenter
            spacing: 20
            Repeater {
                model: middfielders

                delegate: Footballer {
                    width: 40
                    height: 40
                }
            }

        }

        //forvet
        Column{
            anchors.verticalCenter: parent.verticalCenter
            spacing: 20
            Repeater {
                model: forwards

                delegate: Footballer {
                    width: 40
                    height: 40
                }
            }

        }
    }


}
