import QtQuick
import qs.config

Rectangle {
    Behavior on color {
        NumberAnimation {
            duration: General.animationDuration
            easing.type: Easing.InOutQuad
        }
    }

    // TODO: use visible instead of opacity for perf, but we need to animate the opacity then set visible
    Behavior on opacity {
        NumberAnimation {
            duration: General.animationDuration
            easing.type: Easing.InOutQuad
        }
    }
}
