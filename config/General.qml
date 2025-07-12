pragma Singleton

import Quickshell

Singleton {
    id: root

    readonly property bool sloopySearch: false

    readonly property int resourceUpdateInterval: 1

    readonly property real iconSize: Style.font.size.small ?? 16

    readonly property string cpuThermalPath: "/sys/class/thermal/thermal_zone0/temp"
}
