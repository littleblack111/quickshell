pragma Singleton
import Quickshell
import QtQuick

Singleton {
    readonly property color background1: WallustColors.color8
    // readonly property color background2: WallustColors.color0
    readonly property color background2: Qt.rgba(WallustColors.color0.r, WallustColors.color0.g, WallustColors.color0.b, General.accentTransparency)
    readonly property color background3: WallustColors.background
    readonly property color a1: WallustColors.color9
    readonly property color a2: WallustColors.color1
    readonly property color b1: WallustColors.color10
    readonly property color b2: WallustColors.color2
    readonly property color c1: WallustColors.color11
    readonly property color c2: WallustColors.color3
    readonly property color d1: WallustColors.color12
    readonly property color d2: WallustColors.color4
    readonly property color e1: WallustColors.color13
    readonly property color e2: WallustColors.color5
    readonly property color f1: WallustColors.color14
    readonly property color f2: WallustColors.color6
    readonly property color foreground1: WallustColors.foreground
    readonly property color foreground2: WallustColors.color15
    readonly property color foreground3: WallustColors.color7

    readonly property color accent: background2
    readonly property color accentAlt: background1

    readonly property color black: Qt.rgba(59 / 255, 66 / 255, 82 / 255, 1)
    readonly property color red: Qt.rgba(191 / 255, 97 / 255, 106 / 255, 1)
    readonly property color green: Qt.rgba(163 / 255, 190 / 255, 140 / 255, 1)
    readonly property color yellow: Qt.rgba(235 / 255, 203 / 255, 139 / 255, 1)
    readonly property color blue: Qt.rgba(129 / 255, 161 / 255, 193 / 255, 1)
    readonly property color magenta: Qt.rgba(180 / 255, 142 / 255, 173 / 255, 1)
    readonly property color cyan: Qt.rgba(136 / 255, 192 / 255, 208 / 255, 1)
    readonly property color white: Qt.rgba(229 / 255, 233 / 255, 240 / 255, 1)
    readonly property color altBlack: Qt.rgba(76 / 255, 86 / 255, 106 / 255, 1)
    readonly property color altRed: Qt.rgba(191 / 255, 97 / 255, 106 / 255, 1)
    readonly property color altGreen: Qt.rgba(163 / 255, 190 / 255, 140 / 255, 1)
    readonly property color altYellow: Qt.rgba(235 / 255, 203 / 255, 139 / 255, 1)
    readonly property color altBlue: Qt.rgba(129 / 255, 161 / 255, 193 / 255, 1)
    readonly property color altMagenta: Qt.rgba(180 / 255, 142 / 255, 173 / 255, 1)
    readonly property color altCyan: Qt.rgba(143 / 255, 188 / 255, 187 / 255, 1)
    readonly property color altWhite: Qt.rgba(236 / 255, 239 / 255, 244 / 255, 1)
}
