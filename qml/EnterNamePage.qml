import QtQuick 2.0
import QtQuick.Controls 1.3

Rectangle {
    width: 300
    height: 400
    color: "#8b7d7d"

    TextField {
        placeholderText: qsTr("Enter name")
        x: 110
        y: 257
        width: 100
        height: 30
        font.pixelSize: 12

        onAccepted: {

        }
    }
}

