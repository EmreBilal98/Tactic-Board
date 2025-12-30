import QtQuick
import QtQuick.Controls 2.3

//listenin her bir elemanda ne tutacağı burada verilir
Item {
    id: delegateRoot
    width: parent ? parent.width : 0
    height: 100

    property string ltext:name
    property bool deleteMode: false

    Rectangle {
        anchors.fill:parent
        color: "transparent"
        radius: 4

        Label {
            id: labelText
            width: 50
            font.bold: true
            font.pixelSize: 25
            text: ltext //modelden geliyor(formasyon ismi)
            anchors.centerIn: parent
        }

        //buton özelliği vermek için gerekli
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor // Üzerine gelince el işareti çıkar
            //onEntered ve onExitedı kullanmak için lazım
            hoverEnabled: true
            onClicked: {
                //sinyale değerler veriliyor
                if(deleteMode){
                    rlistView.formationDeleteRequested(index)
                    console.log("Silme istendi. Index: " + index)
                }
                else{
                listView.formationSelected(labelText.text, defenders, middfielders, forwards)
                console.log("Sinyal gönderildi: " + labelText.text)
                }
            }
            onPressed: parent.color = "yellow" // Görsel geri bildirim
            onReleased: parent.color = "lightblue"
            onEntered: parent.color = "lightblue"
            onExited: parent.color = "transparent"
        }
    }


}

