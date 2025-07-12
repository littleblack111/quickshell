pragma Singleton

import Quickshell

Singleton {
    id: root

    readonly property int height: 45
    readonly property int borderRadius: Style.rounding.small
    readonly property int topMargin: Style.spacing.small
    readonly property int leftMargin: Style.spacing.larger
    readonly property int rightMargin: Style.spacing.larger

    readonly property int workspaceIconSize: 32
    readonly property int workspaces: 10

    readonly property int appIconSize: 32

    readonly property int resourceIconTextSpacing: Style.spacing.small
}
