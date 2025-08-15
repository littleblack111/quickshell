import Quickshell
import Quickshell.Wayland
import QtQuick

PanelWindow {
    required property string name
    property ShellScreen modelData
    property var layer: WlrLayer.Top

    screen: modelData
    WlrLayershell.namespace: `${name}`
    WlrLayershell.layer: layer
    color: "transparent"
}
