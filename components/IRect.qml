import QtQuick
import qs.config

Rectangle {
    Behavior on color {
        NumberAnimation {
            duration: General.animationDuration
            easing.type: Easing.InOutQuad
        }
    }

    Behavior on opacity {
        NumberAnimation {
            duration: General.animationDuration
            easing.type: Easing.InOutQuad
        }
    }
}
