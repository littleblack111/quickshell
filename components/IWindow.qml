import Quickshell
import Quickshell.Wayland
import QtQuick

PanelWindow {
    required property string name
    property ShellScreen modelData

    screen: modelData
    WlrLayershell.namespace: `${name}`
    color: "transparent"

    Behavior on color {
        NumberAnimation {
            duration: General.animationDuration
            easing.type: Easing.InOutQuad
        }
    }
}
