import Quickshell
import Quickshell.Wayland

PanelWindow {
    required property string name
    property ShellScreen modelData

    screen: modelData
    WlrLayershell.namespace: `${name}`
    color: "transparent"
}
