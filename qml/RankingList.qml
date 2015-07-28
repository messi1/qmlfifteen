import QtQuick 2.0

Item {
    width: 300
    height: 290
    z:10

    Rectangle {
        anchors.fill: parent
        opacity: 0.6
        color: "black"
    }


    Text {
        id: rankingTitle
        anchors{ left: parent.left; right: parent.right; top: parent.top;  }
        anchors.margins: 20
        color:"white";
        font.pixelSize: 20
        text: "Ranking"
        font.bold: true
    }

    ListView {
        id: rankingListView
        anchors{ left: parent.left; right: parent.right; top: rankingTitle.bottom; bottom: parent.bottom }
        anchors.margins: 20

        clip: true

        model: myModel

        delegate: rankingListEntry

        section.property: "mode"
        section.delegate: sectionDelegate
    }

    Component {
        id: rankingListEntry

        Item {
            width: 260
            height: 20

            Row {
                anchors{ left: parent.left; right: parent.right; top: parent.top; }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    color:"white";
                    width: parent.width/3;
                    font.pixelSize: 14
                    text: time
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    color:"white";
                    width: parent.width*2/3;
                    font.pixelSize: 14
                    text: name }
            }
        }
    }

    Component {
        id: sectionDelegate

        Rectangle {
            width: parent.width
            height: 20

            color: "lightGray"

            Text {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 10

                font.pixelSize: 12
                font.bold: true

                text: section
            }
        }
    }


    ListModel {
        id: rankingListModel

        ListElement { time: "00:00:10"; name: "Abdul Ahad Mohmand"; mode: "3x3"; }
        ListElement { time: "00:00:40"; name: "Roberta Bondar"; mode: "4x4"; }
        ListElement { time: "00:00:20"; name: "Marc Garneau"; mode: "4x4"; }
        ListElement { time: "00:00:35"; name: "Chris Hadfield"; mode: "4x4"; }
        ListElement { time: "00:00:00"; name: "Guy Laliberte"; mode: "4x4"; }
        ListElement { time: "00:00:00"; name: "Steven MacLean"; mode: "4x4"; }
        ListElement { time: "00:00:00"; name: "Julie Payette"; mode: "4x4"; }
        ListElement { time: "00:00:00"; name: "Robert Thirsk"; mode: "4x4"; }
        ListElement { time: "00:00:00"; name: "Bjarni Tryggvason"; mode: "4x4"; }
        ListElement { time: "00:00:00"; name: "Dafydd Williams"; mode: "4x4"; }
        ListElement { time: "00:00:00"; name: "Alexandar Panayotov Alexandrov"; mode: "5x5"; }
        ListElement { time: "00:00:00"; name: "Georgi Ivanov"; mode: "5x5"; }
        ListElement { time: "00:00:00"; name: "Marcos Pontes"; mode: "6x6"; }
    }
}
