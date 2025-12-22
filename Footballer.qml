import QtQuick 2.12

//oyuncuyu niteleyen buton
Rectangle {
    color:"blue"
    radius:width

    //drag özelliği teknik direktörün sürükle bırak yapmasına imkan sağlamak için
    MouseArea {
            anchors.fill: parent
            drag.target: parent

            // İsterseniz sürükleme sınırlarını belirleyebilirsiniz
            // drag.axis: Drag.XAndYAxis
        }

}
