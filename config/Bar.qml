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

    readonly property int workspaces: 10
    readonly property int workspaceIconSize: 32
    readonly property int workspaceSpacing: 2
    readonly property int workspaceHorizontalSpacing: Style.spacing.smaller
    readonly property int workspaceActiveIconSize: workspaceIconSize * 1.5
    readonly property int workspaceRounding: Style.rounding.small
    readonly property double workspaceOpacity: 0.8
    readonly property int workspaceActiveOpacity: 1
    readonly property double workspaceEmptyOpacity: 0.2
    // workspaceAnimationEasing using Hyprland's actual ws animation easing
    readonly property int workspaceAnimationDuration: 200

    readonly property int appIconSize: 25

    readonly property int resourceIconTextSpacing: Style.spacing.small

    readonly property int moduleRadius: Style.rounding.small

    readonly property double mediaPausedOpacity: 0.8

    readonly property double bgTransparency: 0.25
}
