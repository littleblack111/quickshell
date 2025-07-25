pragma Singleton

import Quickshell

Singleton {
    id: root

    readonly property bool sloopySearch: false

    readonly property int resourceUpdateInterval: 1

    readonly property real iconSize: Style.font.size.larger ?? 16

    readonly property string cpuThermalPath: "/sys/class/thermal/thermal_zone0/temp"

    readonly property int rectMargin: Style.spacing.small

    readonly property int fontSize: Style.font.size.larger

    readonly property int animateDuration: Style.anim.durations.normal
    readonly property string animateProp: "scale"
    readonly property real springAnimationSpring: 8
    readonly property real springAnimationDamping: 0.4
}
