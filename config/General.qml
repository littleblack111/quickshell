pragma Singleton

import Quickshell

Singleton {
    id: root

    readonly property bool sloppySearch: true

    readonly property int resourceUpdateInterval: 1

    readonly property real iconSize: Style.font.size.larger ?? 16

    readonly property string cpuThermalPath: "/sys/class/thermal/thermal_zone0/temp"

    readonly property int rectMargin: Style.spacing.small

    readonly property int fontSize: Style.font.size.larger

    readonly property int animationDuration: Style.anim.durations.normal
    readonly property real springAnimationSpring: 8
    readonly property real springAnimationDamping: 0.4

    readonly property double accentTransparency: 0.15
}
