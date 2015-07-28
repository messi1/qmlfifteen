import QtQuick 2.0
import QtQuick.Particles 2.0

Item {
    id:finalItem
    visible: false

    Text {
        id: finalText
//        anchors.fill: parent
        text: "Well done but to slow.\nMaybe next time."
        horizontalAlignment: Text.Center
        font.pixelSize: 30
        font.bold: true
        color: "white"
        visible: false
        y: parent.height
    }

    PropertyAnimation { id: animation; target: finalText; property: "y"; to: 00; duration: 500 }

    ParticleSystem {
        id: particleSystem
        anchors.fill: parent
        paused: true
        visible: false

        ImageParticle {
            source: "images/star.png"
            rotationVariation: 180
            color:"#ffffff"
        }
        Emitter {
            id: particleEmitter
            width: parent.width
            height: 8
            emitRate: 16
            lifeSpan: 2000
            size: 48
            sizeVariation: 16
            endSize: 8
            velocity: PointDirection{ y: 120; x:-2; xVariation: 5; yVariation: 100 }
            enabled: true

        }
        Turbulence {
            width: parent.width
            height: (parent.height / 2)
            strength: 8
        }
    }

    onVisibleChanged: {
        particleSystem.paused = !finalItem.visible
        particleSystem.visible= finalItem.visible
        finalText.visible     = finalItem.visible
        animation.running = finalItem.visible
    }
}

