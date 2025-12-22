import QtQuick

//her element isim ve defanss,ortasaha,forvet sayılarını tutar
ListModel {
    id: formationModel

    ListElement {
        name: "4-4-2"
        defenders: 4
        middfielders: 4
        forwards:2
    }
    ListElement {
        name: "4-3-3"
        defenders: 4
        middfielders: 3
        forwards:3
    }
    ListElement {
        name: "4-5-1"
        defenders: 4
        middfielders: 5
        forwards:1
    }
    ListElement {
        name: "3-4-3"
        defenders: 3
        middfielders: 4
        forwards: 3
    }
    ListElement {
        name: "5-3-2"
        defenders: 5
        middfielders: 3
        forwards: 2
    }

}
