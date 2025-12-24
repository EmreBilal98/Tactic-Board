import QtQuick
import QtQuick.Controls 2.3

//listenin her bir elemanda ne tutacağı burada verilit

Item {
    id: delegateRoot
    width: parent.width
    height: 100

    Rectangle {
        anchors.fill:parent
        color: "transparent"
        radius: 4

        Label {
            id: labelText
            width: 50
            font.bold: true
            font.pixelSize: 25
            text: name //modelden geliyor(formasyon ismi)
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
                listView.formationSelected(name, defenders, middfielders, forwards)
                console.log("Sinyal gönderildi: " + name)
            }
            onPressed: parent.color = "yellow" // Görsel geri bildirim
            onReleased: parent.color = "lightblue"
            onEntered: parent.color = "lightblue"
            onExited: parent.color = "transparent"
        }
    }


}

