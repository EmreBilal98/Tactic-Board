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

    // Yukarıdan gelen veri: Sadece bu sayfanın koordinatları
    property var inputPositions: []

    // Oyuncu hareket edince yukarıya haber verecek sinyal
    signal playerMoved(int playerIndex, int x, int y)

    onInputPositionsChanged: {
        console.log("DefaultFormation: Yeni pozisyon verisi geldi, uzunluk:", inputPositions ? inputPositions.length : 0)
            // Bu blok boş kalabilir, çünkü aşağıda her oyuncu kendi Connection'ı ile dinleyecek.
            // Ama debug için:
            // console.log("DefaultFormation: Yeni pozisyon verisi geldi, uzunluk:", inputPositions ? inputPositions.length : 0)
        }

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

            readonly property int myIndex: 0

            // LOGLAMA İÇİN GÜNCELLENMİŞ FONKSİYON
            function updatePosition() {
                // 1. Fare ile tutuyorsam güncelleme
                if (typeof isPressed !== "undefined" && isPressed) return;

                var source = "YOK (Data Undefined)"; // Log için durum
                var incomingX = 0;
                var incomingY = 0;

                // 2. Veri kontrolü
                if (root.inputPositions && root.inputPositions[myIndex]) {
                    incomingX = root.inputPositions[myIndex].x;
                    incomingY = root.inputPositions[myIndex].y;
                    source = "VERİTABANI";

                    // 3. HATA ÖNLEYİCİ (0,0 Kontrolü)
                    // Kaleci (Index 0) hariç diğerleri 0,0'a gidemez
                    if (myIndex > 0 && incomingX === 0 && incomingY === 0) {
                        console.log("LOG: [" + myIndex + "] Hatalı (0,0) verisi geldi, güncelleme iptal edildi.");
                        return;
                    }

                    // Koordinatları Ata
                    x = incomingX;
                    y = incomingY;
                }

                // 4. KONSOLA DURUMU YAZ (BU SATIR ÇOK ÖNEMLİ)
                console.log("LOG: Oyuncu [" + myIndex + "] Güncellendi -> X: " + Math.round(x) + " Y: " + Math.round(y) +
                            " | Kaynak: " + source + " | Gelen Veri: " + Math.round(incomingX) + "," + Math.round(incomingY));
            }

            Component.onCompleted:{
                console.log("LOG: Oyuncu [" + myIndex + "] YARATILDI (Component.onCompleted)");
                updatePosition()

            }

            // 3. ÖNEMLİ OLAN BU: Ana verideki (root.inputPositions) değişiklikleri dinle!
                Connections {
                    target: root
                    function onInputPositionsChanged() {
                        goalkeeper.updatePosition()
                    }
                }


            // Sürükleme bitince sinyal gönder
            onPlayerReleased:(newX, newY) =>{ // MouseArea içindeyse
                            console.log("LOG: Oyuncu [" + myIndex + "] Elle Bırakıldı -> X: " + Math.round(newX) + " Y: " + Math.round(newY));
                            root.playerMoved(myIndex, newX, newY)
                        }

        }
        }


        //defans
        Column{
            anchors.verticalCenter: parent.verticalCenter//dikey ortalar
            spacing: 40
            Repeater {
                model: defenders

                delegate: Footballer {
                    id:defplayer
                    width: root.width/20
                    height: root.width/20

                    readonly property int myIndex: 1+index

                    // LOGLAMA İÇİN GÜNCELLENMİŞ FONKSİYON
                    function updatePosition() {
                        // 1. Fare ile tutuyorsam güncelleme
                        if (typeof isPressed !== "undefined" && isPressed) return;

                        var source = "YOK (Data Undefined)"; // Log için durum
                        var incomingX = 0;
                        var incomingY = 0;

                        // 2. Veri kontrolü
                        if (root.inputPositions && root.inputPositions[myIndex]) {
                            incomingX = root.inputPositions[myIndex].x;
                            incomingY = root.inputPositions[myIndex].y;
                            source = "VERİTABANI";

                            // 3. HATA ÖNLEYİCİ (0,0 Kontrolü)
                            // Kaleci (Index 0) hariç diğerleri 0,0'a gidemez
                            if (myIndex > 0 && incomingX === 0 && incomingY === 0) {
                                console.log("LOG: [" + myIndex + "] Hatalı (0,0) verisi geldi, güncelleme iptal edildi.");
                                return;
                            }

                            // Koordinatları Ata
                            x = incomingX;
                            y = incomingY;
                        }

                        // 4. KONSOLA DURUMU YAZ (BU SATIR ÇOK ÖNEMLİ)
                        console.log("LOG: Oyuncu [" + myIndex + "] Güncellendi -> X: " + Math.round(x) + " Y: " + Math.round(y) +
                                    " | Kaynak: " + source + " | Gelen Veri: " + Math.round(incomingX) + "," + Math.round(incomingY));
                    }

                    Component.onCompleted:{
                        console.log("LOG: Oyuncu [" + myIndex + "] YARATILDI (Component.onCompleted)");
                        updatePosition()

                    }

                    // 3. ÖNEMLİ OLAN BU: Ana verideki (root.inputPositions) değişiklikleri dinle!
                        Connections {
                            target: root
                            function onInputPositionsChanged() {
                                defplayer.updatePosition()
                            }
                        }

                        // Sürükleme bitince sinyal gönder
                        onPlayerReleased:(newX, newY) =>{ // MouseArea içindeyse
                                        console.log("LOG: Oyuncu [" + myIndex + "] Elle Bırakıldı -> X: " + Math.round(newX) + " Y: " + Math.round(newY));
                                        root.playerMoved(myIndex, newX, newY)
                                    }
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
                    id:midplayers
                    width: root.width/20
                    height: root.width/20

                    readonly property int myIndex: 1+root.defenders+index

                    // LOGLAMA İÇİN GÜNCELLENMİŞ FONKSİYON
                    function updatePosition() {
                        // 1. Fare ile tutuyorsam güncelleme
                        if (typeof isPressed !== "undefined" && isPressed) return;

                        var source = "YOK (Data Undefined)"; // Log için durum
                        var incomingX = 0;
                        var incomingY = 0;

                        // 2. Veri kontrolü
                        if (root.inputPositions && root.inputPositions[myIndex]) {
                            incomingX = root.inputPositions[myIndex].x;
                            incomingY = root.inputPositions[myIndex].y;
                            source = "VERİTABANI";

                            // 3. HATA ÖNLEYİCİ (0,0 Kontrolü)
                            // Kaleci (Index 0) hariç diğerleri 0,0'a gidemez
                            if (myIndex > 0 && incomingX === 0 && incomingY === 0) {
                                console.log("LOG: [" + myIndex + "] Hatalı (0,0) verisi geldi, güncelleme iptal edildi.");
                                return;
                            }

                            // Koordinatları Ata
                            x = incomingX;
                            y = incomingY;
                        }

                        // 4. KONSOLA DURUMU YAZ (BU SATIR ÇOK ÖNEMLİ)
                        console.log("LOG: Oyuncu [" + myIndex + "] Güncellendi -> X: " + Math.round(x) + " Y: " + Math.round(y) +
                                    " | Kaynak: " + source + " | Gelen Veri: " + Math.round(incomingX) + "," + Math.round(incomingY));
                    }

                    Component.onCompleted:{
                        console.log("LOG: Oyuncu [" + myIndex + "] YARATILDI (Component.onCompleted)");
                        updatePosition()

                    }

                    // 3. ÖNEMLİ OLAN BU: Ana verideki (root.inputPositions) değişiklikleri dinle!
                        Connections {
                            target: root
                            function onInputPositionsChanged() {
                                midplayers.updatePosition()
                            }
                        }

                        // Sürükleme bitince sinyal gönder
                        onPlayerReleased:(newX, newY) =>{ // MouseArea içindeyse
                                        console.log("LOG: Oyuncu [" + myIndex + "] Elle Bırakıldı -> X: " + Math.round(newX) + " Y: " + Math.round(newY));
                                        root.playerMoved(myIndex, newX, newY)
                                    }
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
                    id:fwdplayers
                    width: root.width/20
                    height: root.width/20

                    readonly property int myIndex: 1+root.defenders+root.middfielders+index

                    // LOGLAMA İÇİN GÜNCELLENMİŞ FONKSİYON
                    function updatePosition() {
                        // 1. Fare ile tutuyorsam güncelleme
                        if (typeof isPressed !== "undefined" && isPressed) return;

                        var source = "YOK (Data Undefined)"; // Log için durum
                        var incomingX = 0;
                        var incomingY = 0;

                        // 2. Veri kontrolü
                        if (root.inputPositions && root.inputPositions[myIndex]) {
                            incomingX = root.inputPositions[myIndex].x;
                            incomingY = root.inputPositions[myIndex].y;
                            source = "VERİTABANI";

                            // 3. HATA ÖNLEYİCİ (0,0 Kontrolü)
                            // Kaleci (Index 0) hariç diğerleri 0,0'a gidemez
                            if (myIndex > 0 && incomingX === 0 && incomingY === 0) {
                                console.log("LOG: [" + myIndex + "] Hatalı (0,0) verisi geldi, güncelleme iptal edildi.");
                                return;
                            }

                            // Koordinatları Ata
                            x = incomingX;
                            y = incomingY;
                        }

                        // 4. KONSOLA DURUMU YAZ (BU SATIR ÇOK ÖNEMLİ)
                        console.log("LOG: Oyuncu [" + myIndex + "] Güncellendi -> X: " + Math.round(x) + " Y: " + Math.round(y) +
                                    " | Kaynak: " + source + " | Gelen Veri: " + Math.round(incomingX) + "," + Math.round(incomingY));
                    }

                    Component.onCompleted:{
                        console.log("LOG: Oyuncu [" + myIndex + "] YARATILDI (Component.onCompleted)");
                        updatePosition()

                    }

                    // 3. ÖNEMLİ OLAN BU: Ana verideki (root.inputPositions) değişiklikleri dinle!
                        Connections {
                            target: root
                            function onInputPositionsChanged() {
                                fwdplayers.updatePosition()
                            }
                        }

                        // Sürükleme bitince sinyal gönder
                        onPlayerReleased:(newX, newY) =>{ // MouseArea içindeyse
                                        console.log("LOG: Oyuncu [" + myIndex + "] Elle Bırakıldı -> X: " + Math.round(newX) + " Y: " + Math.round(newY));
                                        root.playerMoved(myIndex, newX, newY)
                                    }
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
