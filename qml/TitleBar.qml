import QtQuick 2.0
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.2

Item {
    id: titleBar
    property int borderWidth: 0
    property alias pauseButtonText: pauseButton.text
    property alias pauseButtonEnabled: pauseButton.enabled

    signal newButtonClicked()
    signal pauseButtonClicked()
    signal gameModeChanged(int mode)

    Rectangle {
        id: titleBackground
        anchors.fill: parent

        gradient: Gradient {
            GradientStop { position: 0.0; color: "lightgray" }
            GradientStop { position: 0.4; color: "gray" }
            GradientStop { position: 1.0; color: "black" }
        }
        border.color: "gray"
        border.width: 1
        opacity: 0.5
    }

    Item {
        anchors.fill: titleBackground

        Button {
            id: newButton
            height: 34

            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: borderWidth
            text: qsTr("New")

            onClicked: {
                pauseButton.text    = qsTr("Pause")
                pauseButton.enabled = true
                newButtonClicked()
            }
        }

        Text {
            id: gameTitle
            anchors.centerIn: parent
            color: "white"
            z:1
            text: qsTr("Fifteen") // or use qsTranslate(context, string)
            font.bold: true
            font.pointSize: 16

            MouseArea {
                anchors.fill: parent
                onClicked: contextMenu.popup()
            }
        }

        Button {
            id:pauseButton
            height: 34
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: screen.border
            text: qsTr("Pause")
            enabled: false

            onClicked: {
                pauseButtonClicked()
            }
        }
    }


    Menu {
        id: contextMenu
        title: "File"
        MenuItem {
             text: "3x3"
             onTriggered: gameModeChanged(3)
        }
        MenuItem {
             text: "4x4"
             onTriggered: gameModeChanged(4)
        }
        MenuItem {
             text: "5x5"
             onTriggered: gameModeChanged(5)
        }
        MenuItem {
             text: "6x6"
             onTriggered: gameModeChanged(6)
        }
        MenuItem {
             text: "Quit"
             shortcut: "Ctrl+Q"
             onTriggered: Qt.quit()
        }
    }
}

