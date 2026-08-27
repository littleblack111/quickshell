import QtQuick
import qs.config

Rectangle {
    id: root

    Behavior on color {
        ColorAnimation {
            duration: General.animationDuration
            easing.type: Easing.InOutQuad
        }
    }

    states: [
        State {
            name: "hidden"
            when: root.opacity === 0
            PropertyChanges {
                target: root
                visible: false
            }
        }
    ]

    Behavior on opacity {
        NumberAnimation {
            duration: General.animationDuration
            easing.type: Easing.InOutQuad
        }
    }
}
