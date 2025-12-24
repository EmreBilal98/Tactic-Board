import QtQuick 2.12

//oyuncuyu niteleyen buton
Rectangle {
    color:"blue"
    radius:width
    id:froot

    signal playerReleased(real newX, real newY)

    property alias isPressed: mouseArea.pressed

    //drag özelliği teknik direktörün sürükle bırak yapmasına imkan sağlamak için
    MouseArea {
        id:mouseArea
        anchors.fill: parent
        drag.target: parent

        // İsterseniz sürükleme sınırlarını belirleyebilirsiniz
        // drag.axis: Drag.XAndYAxis

        // 2. MouseArea'nın kendi released sinyalini yakalıyoruz
        onReleased: {
            // 3. Yakaladığımız bu olayı kendi sinyalimizle dışarı fırlatıyoruz
            froot.playerReleased(froot.x, froot.y)
        }
    }

}
