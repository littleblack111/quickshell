pragma Singleton
import Quickshell
import QtQuick

Singleton {
    readonly property color background: WallustColors.background
    readonly property color foreground: WallustColors.foreground
    readonly property color surface: WallustColors.color0
    readonly property color primary: WallustColors.color3
    readonly property color alt: WallustColors.color4
    readonly property color accent: WallustColors.color1
    readonly property color success: WallustColors.color2
    readonly property color warning: WallustColors.color3
    readonly property color error: WallustColors.color1
    readonly property color info: WallustColors.color4
    readonly property color textSecondary: WallustColors.color7
    readonly property color border: WallustColors.color8
    readonly property color highlight: WallustColors.color5
    readonly property color disabled: WallustColors.color6
    readonly property color muted: WallustColors.color2

    // actual colors
    // 	@define-color BLACK rgba (59, 66, 82, 1);
    // @define-color RED rgba (191, 97, 106, 1);
    // @define-color GREEN rgba (163, 190, 140, 1);
    // @define-color YELLOW rgba (235, 203, 139, 1);
    // @define-color BLUE rgba (129, 161, 193, 1);
    // @define-color MAGENTA rgba (180, 142, 173, 1);
    // @define-color CYAN rgba (136, 192, 208, 1);
    // @define-color WHITE rgba (229, 233, 240, 1);
    // @define-color ALTBLACK rgba (76, 86, 106, 1);
    // @define-color ALTRED rgba (191, 97, 106, 1);
    // @define-color ALTGREEN rgba (163, 190, 140, 1);
    // @define-color ALTYELLOW rgba (235, 203, 139, 1);
    // @define-color ALTBLUE rgba (129, 161, 193, 1);
    // @define-color ALTMAGENTA rgba (180, 142, 173, 1);
    // @define-color ALTCYAN rgba (143, 188, 187, 1);
    // @define-color ALTWHITE rgba (236, 239, 244, 1);

    readonly property color black: Qt.rgba(59, 66, 82)
    readonly property color red: Qt.rgba(191, 97, 106)
    readonly property color green: Qt.rgba(163, 190, 140)
    readonly property color yellow: Qt.rgba(235, 203, 139)
    readonly property color blue: Qt.rgba(129, 161, 193)
    readonly property color magenta: Qt.rgba(180, 142, 173)
    readonly property color cyan: Qt.rgba(136, 192, 208)
    readonly property color white: Qt.rgba(229, 233, 240)
    readonly property color altBlack: Qt.rgba(76, 86, 106)
    readonly property color altRed: Qt.rgba(191, 97, 106)
    readonly property color altGreen: Qt.rgba(163, 190, 140)
    readonly property color altYellow: Qt.rgba(235, 203, 139)
    readonly property color altBlue: Qt.rgba(129, 161, 193)
    readonly property color altMagenta: Qt.rgba(180, 142, 173)
    readonly property color altCyan: Qt.rgba(143, 188, 187)
    readonly property color altWhite: Qt.rgba(236, 239, 244)
}
