import Quickshell
import Quickshell.Wayland
import QtQuick

PanelWindow {
    required property string name
    property ShellScreen modelData

    screen: modelData
    WlrLayershell.namespace: `${name}`
    color: "transparent"
}
