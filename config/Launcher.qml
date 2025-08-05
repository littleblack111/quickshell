pragma Singleton

import Quickshell
import QtQuick
import qs.launcher.components

Singleton {
    id: root

    readonly property int defaultWidth: 500

    readonly property int widgetWidth: 700
    readonly property int widgetHeight: 200

    readonly property int innerMargin: 5

    readonly property int borderRadius: Style.rounding.large
    readonly property int borderWidth: 1

    readonly property int widgetRadius: Style.rounding.small
    readonly property int widgetFontSize: Style.font.size.large

    readonly property double bgTransparency: 0.4
    readonly property double widgetBgTransparency: 0.3
    readonly property double widgetTitleBgTransparency: 0.2 // as it's on top of it

    readonly property bool showWidgetTitle: true

    readonly property int topMargin: 400

    readonly property int predictiveCompletionRadius: 6

    readonly property list<Component> widgets: [
        Component {
            Spell {}
        },
        Component {
            App {}
        },
        Component {
            Calc {}
        }
    ]
}
