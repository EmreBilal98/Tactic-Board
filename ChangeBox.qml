import QtQuick
import QtQuick.Controls 2.5

Item {
    anchors.fill:parent
    Column {
        id:myColumn2
        visible:!visibility
        anchors.centerIn: parent
        spacing: 20
        width: parent.width * 0.8

        Text {
            text: "CHANGE USER"
            font.pixelSize: 24
            font.bold: true
            color: "#2c3e50"
            anchors.horizontalCenter: parent.horizontalCenter
        }

        // Eski Kullanıcı Adı
        TextField {
            id: oldusernameField
            width: parent.width
            placeholderText: "Old ID"
            text: "admin" // Test için varsayılan
            font.pixelSize: 16
        }

        //Kullanıcı Adı
        TextField {
            id: usernameField
            width: parent.width
            placeholderText: "Personal ID"
            text: "admin" // Test için varsayılan
            font.pixelSize: 16
        }

        // Eski Şifre
        TextField {
            id: oldpasswordField
            width: parent.width
            placeholderText: "Old Password"
            text: "1234" // Test için varsayılan
            echoMode: TextInput.Password // Şifreyi gizler (***)
            font.pixelSize: 16
        }

        // Yeni Şifre
        TextField {
            id: passwordField
            width: parent.width
            placeholderText: "New Password"
            text: "1234" // Test için varsayılan
            echoMode: TextInput.Password // Şifreyi gizler (***)
            font.pixelSize: 16
        }

        // Yeni Şifre tekrar
        TextField {
            id: repasswordField
            width: parent.width
            placeholderText: "New Password Again"
            text: "1234" // Test için varsayılan
            echoMode: TextInput.Password // Şifreyi gizler (***)
            font.pixelSize: 16
        }

        // Hata Mesajı
        Text {
            id: errorText
            text: "Wrong password or ID!"
            color: "red"
            font.pixelSize: 12
            visible: false
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Row{
        width:parent.width
        spacing:6
        // Giriş Butonu
        Button {
            id: loginButton
            text: "Log In"
            width: parent.width/2-3
            highlighted: true

            contentItem: Text {
                text: loginButton.text
                font.pixelSize: 16
                font.bold: true
                color: "white"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            background: Rectangle {
                color: loginButton.down ? "#2980b9" : "#3498db"
                radius: 5
            }

            onClicked: {
                visibility=true
            }
        }

        Button {
            id: changeButton
            text: "Change User"
            width: parent.width/2-3
            highlighted: true

            contentItem: Text {
                text: changeButton.text
                font.pixelSize: 16
                font.bold: true
                color: "white"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            background: Rectangle {
                color: loginButton.down ? "#2980b9" : "#3498db"
                radius: 5
            }

            onClicked: {
                //yeni user kaydet
            }
        }
        }
    }

}

