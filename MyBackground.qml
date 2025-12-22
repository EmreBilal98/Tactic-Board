import QtQuick 2.12


//arka plan burada çiziliyor
Item {

    anchors.fill: parent
    visible:true

    //arka plan rengi
    property color background:"green"
    Rectangle {
        anchors.fill: parent
        color:background

    //sahanın dış çizgisi
    Rectangle {
        id:pitchBorder
        x:parent.x+20
        y:parent.y+20
        width:parent.width-40
        height:parent.height-40
        color: "transparent" // Veya color: "#00000000"
        border.color: "white" // Kenarlık görünür kalsın diye
        border.width: 6

    }

    //ortadan geçen çizgi
    Rectangle {
        id:pitchMidLine
        y:pitchBorder.y
        x:pitchBorder.x+(pitchBorder.width/2)-3
        width:6
        height:pitchBorder.height
        color:"white"
    }

    //sol kale
    Rectangle {
        id:goalPostLeft
        x:pitchBorder.x
        y:pitchBorder.y+((pitchBorder.height*25)/90)-3
        width:(pitchBorder.width*17)/120
        height:(pitchBorder.height*4)/9
        color:"transparent"
        border.color:"white"
        border.width:6
    }

    //sağ kale
    Rectangle {
        id:goalPostRight
        x:pitchBorder.x+pitchBorder.width-goalPostLeft.width
        y:pitchBorder.y+((pitchBorder.height*25)/90)-3
        width:(pitchBorder.width*17)/120
        height:(pitchBorder.height*4)/9
        color:"transparent"
        border.color:"white"
        border.width:6
    }

    //orta yuvarlak
    Rectangle {
        id:pitchCircle
        x:pitchMidLine.x-(pitchBorder.width/10)
        y:pitchMidLine.y+(pitchBorder.height/2)-(pitchBorder.width/10)
        width:pitchBorder.width/5+pitchMidLine.border.width+3
        height:pitchBorder.width/5+pitchMidLine.border.width+3
        radius: width
        color:"transparent"
        border.color:"white"
        border.width:6

    }
    }

}
