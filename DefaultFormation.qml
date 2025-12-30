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
    property var rivalInputPositions: []

    // Oyuncu hareket edince yukarıya haber verecek sinyal
    signal playerMoved(int playerIndex, int x, int y)

    // rakip oyuncu hareket edince yukarıya haber verecek sinyal
    signal rivalPlayerMoved(int playerIndex, int x, int y)

    onInputPositionsChanged: {
        console.log("DefaultFormation: Yeni pozisyon verisi geldi, uzunluk:", inputPositions ? inputPositions.length : 0)
            // Bu blok boş kalabilir, çünkü aşağıda her oyuncu kendi Connection'ı ile dinleyecek.
            // Ama debug için:
            // console.log("DefaultFormation: Yeni pozisyon verisi geldi, uzunluk:", inputPositions ? inputPositions.length : 0)
        }

    onRivalInputPositionsChanged: {
            console.log("DefaultFormation: Rakip verisi değişti, boy:", rivalInputPositions ? rivalInputPositions.length : 0)
            // Rakip oyuncuların updatePosition fonksiyonları kendi connectionları ile çalışacak
        }
        //kaleci(column içinde olmazsa sadece horizontal harekete izin veriyor anchors.berticalcenter satırı.)
        Item {
        anchors.fill:parent
        visible: (forwards) ? true : false
        //anchors.verticalCenter: parent.verticalCenter//dikey ortalar

        Footballer{
            id:goalkeeper
            width:root.width/20
            height: root.width/20
            x:26
            y: (root.height - height) / 2

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
                    if (myIndex >= 0 && incomingX === 0 && incomingY === 0) {
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
        Item{
            //anchors.verticalCenter: parent.verticalCenter//dikey ortalar
            //y: (root.height - height) / 2
            //spacing: 40
            Repeater {
                model: defenders


                delegate: Footballer {
                    id:defplayer
                    width: root.width/20
                    height: root.width/20
                    y: ((root.height - height) / 2)-((defenders-index-((defenders+1)/2))*root.height/6)
                    x:26+((root.width-200)/spaceRate)+width
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
        Item{
            //anchors.verticalCenter: parent.verticalCenter//dikey ortalar
            //y: (root.height - height) / 2
            //spacing: 40
            Repeater {
                model: middfielders

                delegate: Footballer {
                    id:midplayers
                    width: root.width/20
                    height: root.width/20
                    y: ((root.height - height) / 2)-((middfielders-index-((middfielders+1)/2))*root.height/6)
                    x:26+2*(((root.width-200)/spaceRate)+width)
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
        Item{
            //anchors.verticalCenter: parent.verticalCenter//dikey ortalar
            //y: (root.height - height) / 2
            //spacing: 40
            Repeater {
                model: forwards

                delegate: Footballer {
                    id:fwdplayers
                    width: root.width/20
                    height: root.width/20
                    y: ((root.height - height) / 2)-((forwards-index-((forwards+1)/2))*root.height/6)
                    x:26+3*(((root.width-200)/spaceRate)+width)

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



    Item {
        visible: (rivalforwards) ? true : false
        //anchors.verticalCenter: parent.verticalCenter
        // anchors.right:parent.right
        // anchors.rightMargin: 25
        // spacing:(parent.width-200)/spaceRate
        anchors.fill:parent

        //rakip forvet
        Item{
            //anchors.verticalCenter: parent.verticalCenter//dikey ortalar
            //y: (root.height - height) / 2
            //spacing: 40
            Repeater {
                model: rivalforwards

                delegate: Footballer {
                    id:rfwdplayers
                    color: "yellow"
                    width: root.width/20
                    height: root.width/20
                    y: ((root.height - height) / 2)-((rivalforwards-index-((rivalforwards+1)/2))*root.height/6)
                    x:root.width-(26+width+3*(((root.width-200)/spaceRate)+width))
                    readonly property int myIndex: index

                    // LOGLAMA İÇİN GÜNCELLENMİŞ FONKSİYON
                    function updatePosition() {
                        // 1. Fare ile tutuyorsam güncelleme
                        if (typeof isPressed !== "undefined" && isPressed) return;

                        var source = "YOK (Data Undefined)"; // Log için durum
                        var incomingX = 0;
                        var incomingY = 0;

                        // 2. Veri kontrolü
                        if (root.rivalInputPositions && root.rivalInputPositions[myIndex]) {
                            incomingX = root.rivalInputPositions[myIndex].x;
                            incomingY = root.rivalInputPositions[myIndex].y;
                            source = "VERİTABANI";

                            // 3. HATA ÖNLEYİCİ (0,0 Kontrolü)
                            // Kaleci (Index 0) hariç diğerleri 0,0'a gidemez
                            if (myIndex > 0 && incomingX === 0 && incomingY === 0) {
                                console.log("LOG: [" + myIndex + "] Hatalı (0,0) verisi geldi, güncelleme iptal edildi.");
                                return;
                            }

                            // Koordinatları Ata
                            if (incomingX !== 0 || incomingY !== 0) {
                                x = incomingX;
                                y = incomingY;
                            }
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
                            function onRivalInputPositionsChanged() {
                                rfwdplayers.updatePosition()
                            }
                        }


                    // Sürükleme bitince sinyal gönder
                    onPlayerReleased:(newX, newY) =>{ // MouseArea içindeyse
                                    console.log("LOG: Oyuncu [" + myIndex + "] Elle Bırakıldı -> X: " + Math.round(newX) + " Y: " + Math.round(newY));
                                    root.rivalPlayerMoved(myIndex, newX, newY)
                                }

                }
            }

        }

        //rakip ortasaha
        Item{
            //anchors.verticalCenter: parent.verticalCenter//dikey ortalar
            // y: (root.height - height) / 2
            // spacing: 40
            Repeater {
                model: rivalmiddfielders

                delegate: Footballer {
                    id:rmidplayers
                    readonly property int myIndex: root.rivalforwards+index
                    color: "yellow"
                    width: root.width/20
                    height: root.width/20
                    y: ((root.height - height) / 2)-((rivalmiddfielders-index-((rivalmiddfielders+1)/2))*root.height/6)
                    x:root.width-(26+width+2*(((root.width-200)/spaceRate)+width))

                    function updatePosition() {
                        // 1. Fare ile tutuyorsam güncelleme
                        if (typeof isPressed !== "undefined" && isPressed) return;

                        var source = "YOK (Data Undefined)"; // Log için durum
                        var incomingX = 0;
                        var incomingY = 0;

                        // 2. Veri kontrolü
                        if (root.rivalInputPositions && root.rivalInputPositions[myIndex]) {
                            incomingX = root.rivalInputPositions[myIndex].x;
                            incomingY = root.rivalInputPositions[myIndex].y;
                            source = "VERİTABANI";

                            // 3. HATA ÖNLEYİCİ (0,0 Kontrolü)
                            // Kaleci (Index 0) hariç diğerleri 0,0'a gidemez
                            if (myIndex > 0 && incomingX === 0 && incomingY === 0) {
                                console.log("LOG: [" + myIndex + "] Hatalı (0,0) verisi geldi, güncelleme iptal edildi.");
                                return;
                            }

                            // Koordinatları Ata
                            if (incomingX !== 0 || incomingY !== 0) {
                                x = incomingX;
                                y = incomingY;
                            }
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
                            function onRivalInputPositionsChanged() {
                                rmidplayers.updatePosition()
                            }
                        }


                    // Sürükleme bitince sinyal gönder
                    onPlayerReleased:(newX, newY) =>{ // MouseArea içindeyse
                                    console.log("LOG: Oyuncu [" + myIndex + "] Elle Bırakıldı -> X: " + Math.round(newX) + " Y: " + Math.round(newY));
                                    root.rivalPlayerMoved(myIndex, newX, newY)
                                }
                }
            }

        }

        //rakip defans
        Item{
            //anchors.verticalCenter: parent.verticalCenter//dikey ortalar
            // y: (root.height - height) / 2
            // spacing: 40
            Repeater {
                model: rivaldefenders

                delegate: Footballer {
                    id:rdefplayers
                    readonly property int myIndex: root.rivalforwards+root.rivalmiddfielders+index
                    color: "yellow"
                    width: root.width/20
                    height: root.width/20
                    y: ((root.height - height) / 2)-((rivaldefenders-index-((rivaldefenders+1)/2))*root.height/6)
                    x:root.width-(26+width+1*(((root.width-200)/spaceRate)+width))

                    // LOGLAMA İÇİN GÜNCELLENMİŞ FONKSİYON
                    function updatePosition() {
                        // 1. Fare ile tutuyorsam güncelleme
                        if (typeof isPressed !== "undefined" && isPressed) return;

                        var source = "YOK (Data Undefined)"; // Log için durum
                        var incomingX = 0;
                        var incomingY = 0;

                        // 2. Veri kontrolü
                        if (root.rivalInputPositions && root.rivalInputPositions[myIndex]) {
                            incomingX = root.rivalInputPositions[myIndex].x;
                            incomingY = root.rivalInputPositions[myIndex].y;
                            source = "VERİTABANI";

                            // 3. HATA ÖNLEYİCİ (0,0 Kontrolü)
                            // Kaleci (Index 0) hariç diğerleri 0,0'a gidemez
                            if (myIndex > 0 && incomingX === 0 && incomingY === 0) {
                                console.log("LOG: [" + myIndex + "] Hatalı (0,0) verisi geldi, güncelleme iptal edildi.");
                                return;
                            }

                            // Koordinatları Ata
                            if (incomingX !== 0 || incomingY !== 0) {
                                x = incomingX;
                                y = incomingY;
                            }
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
                            function onRivalInputPositionsChanged() {
                                rdefplayers.updatePosition()
                            }
                        }


                    // Sürükleme bitince sinyal gönder
                    onPlayerReleased:(newX, newY) =>{ // MouseArea içindeyse
                                    console.log("LOG: Oyuncu [" + myIndex + "] Elle Bırakıldı -> X: " + Math.round(newX) + " Y: " + Math.round(newY));
                                    root.rivalPlayerMoved(myIndex, newX, newY)
                                }
                }
            }

        }

        //rakip kaleci
        Item{
        //anchors.verticalCenter: parent.verticalCenter//dikey ortalar
        // y: (root.height - height) / 2
        Footballer{
            id:rgoalkeeper
            readonly property int myIndex: root.rivalforwards+root.rivalmiddfielders+root.rivaldefenders
            color: "yellow"
            width:root.width/20
            height: root.width/20
            y: (root.height - height) / 2
            x:root.width-26-width

            // LOGLAMA İÇİN GÜNCELLENMİŞ FONKSİYON
            function updatePosition() {
                // 1. Fare ile tutuyorsam güncelleme
                if (typeof isPressed !== "undefined" && isPressed) return;

                var source = "YOK (Data Undefined)"; // Log için durum
                var incomingX = 0;
                var incomingY = 0;

                // 2. Veri kontrolü
                if (root.rivalInputPositions && root.rivalInputPositions[myIndex]) {
                    incomingX = root.rivalInputPositions[myIndex].x;
                    incomingY = root.rivalInputPositions[myIndex].y;
                    source = "VERİTABANI";

                    // 3. HATA ÖNLEYİCİ (0,0 Kontrolü)
                    // Kaleci (Index 0) hariç diğerleri 0,0'a gidemez
                    if (myIndex > 0 && incomingX === 0 && incomingY === 0) {
                        console.log("LOG: [" + myIndex + "] Hatalı (0,0) verisi geldi, güncelleme iptal edildi.");
                        return;
                    }

                    // Koordinatları Ata
                    if (incomingX !== 0 || incomingY !== 0) {
                        x = incomingX;
                        y = incomingY;
                    }
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
                    function onRivalInputPositionsChanged() {
                        rgoalkeeper.updatePosition()
                    }
                }


            // Sürükleme bitince sinyal gönder
            onPlayerReleased:(newX, newY) =>{ // MouseArea içindeyse
                            console.log("LOG: Oyuncu [" + myIndex + "] Elle Bırakıldı -> X: " + Math.round(newX) + " Y: " + Math.round(newY));
                            root.rivalPlayerMoved(myIndex, newX, newY)
                        }
        }
        }
    }


}
