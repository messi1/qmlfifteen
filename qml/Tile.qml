import QtQuick 2.0

Rectangle {
     id: tile
     property int tileId: 0
     border.color: "ForestGreen"
     border.width: 2

     signal tileClicked()

     gradient: Gradient {
         GradientStop { position: 0.0; color: "wheat" }
         GradientStop { position: 0.5; color: "white" }
         GradientStop { position: 1.0; color: "wheat" }
     }

     Text {
         text: tileId
         font.pixelSize: 20
         font.bold: false
         anchors.centerIn: parent
         color:"black"
     }

     MouseArea {
         id: mouseArea
         anchors.fill: parent

         onPressed: tile.tileClicked()
     }
 } // Rectangle

