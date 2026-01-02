import QtQuick
import QtQuick.Controls 2.5

Rectangle {
        id: loginOverlay
        anchors.fill: parent
        color: "#2c3e50" // Koyu Lacivert Arka Plan
        z: 9999 // Her şeyin en üstünde durmasını sağlar
        visible: !window.isLoggedIn // Giriş yapıldıysa gizle
        property bool visibility:true

        // Giriş Kutusu (Ortadaki Beyaz Alan)
        Rectangle {
            width: 300
            height: 370
            anchors.centerIn: parent
            color: "white"
            radius: 10

            LoginBox{}
            ChangeBox{}

        }

}
