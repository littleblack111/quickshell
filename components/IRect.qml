import QtQuick
import qs.config

Rectangle {
    Behavior on color {
        NumberAnimation {
            duration: General.animationDuration
            easing.type: Easing.InOutQuad
        }
    }
}
