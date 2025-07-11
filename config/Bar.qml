pragma Singleton

import Quickshell

Singleton {
    id: root

    readonly property int height: 45
    readonly property int borderRadius: Style.rounding.small
    readonly property int topMargin: Style.spacing.small
    readonly property int leftMargin: Style.spacing.larger
    readonly property int rightMargin: Style.spacing.larger

    readonly property int workspaces: 10
}
