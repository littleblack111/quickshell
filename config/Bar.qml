pragma Singleton

import Quickshell

Singleton {
    id: root

    readonly property int height: 40
    readonly property int borderRadius: Style.rounding.small
    readonly property int topMargin: Style.spacing.small
    readonly property int leftMargin: Style.spacing.larger
    readonly property int rightMargin: Style.spacing.larger

    readonly property int moduleLeftMargin: Style.spacing.larger
    readonly property int moduleRightMargin: Style.spacing.small

    readonly property int leftModuleSpacing: Style.spacing.smaller
    readonly property int rightModuleSpacing: Style.spacing.smaller

    readonly property var windowStrip: [" — Zen Browser"]

    readonly property int wss: 10
    readonly property int wsIconSize: 32
    readonly property int wsSpacing: 2
    readonly property int wsHorizontalSpacing: Style.spacing.smaller
    readonly property int wsActiveIconSize: wsIconSize * 1.5
    readonly property int wsRounding: Style.rounding.small
    readonly property double wsOpacity: 0.8
    readonly property int wsActiveOpacity: 1
    readonly property double wsEmptyOpacity: 0.2
    // wsAnimationEasing using Hyprland's actual ws animation easing
    readonly property int wsAnimationDuration: 200
    readonly property int wsExtraMouseArea: wsHorizontalSpacing / 2

    readonly property int appIconSize: 25

    readonly property int resourceIconTextSpacing: Style.spacing.small

    readonly property int moduleRadius: Style.rounding.small

    readonly property double mediaPausedOpacity: 0.75
    readonly property double mediaScrollScale: 1 / 25 // 5sec
    readonly property string preferedPlayer: "spotify"

    readonly property double bgTransparency: 0.25
}
