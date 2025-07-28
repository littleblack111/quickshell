pragma Singleton

import Quickshell
import qs.launcher.widgets

Singleton {
    id: root

    readonly property int width: 1000
    readonly property int height: 700

    readonly property int widgetWidth: 550
    readonly property int widgetHeight: 200

    readonly property int innerMargin: 5

    readonly property int borderRadius: Style.rounding.small
    readonly property int borderWidth: 1

    readonly property int widgetRadius: Style.rounding.small
    readonly property int widgetFontSize: Style.font.size.large

    readonly property double bgTransparency: 0.5
    readonly property double widgetBgTransparency: 0.4
    readonly property double widgetTitleBgTransparency: 0.2 // as it's on top of it

    readonly property list<IWidget> widgets: [Math,]
    // readonly property list<IWidget> order: [
    //     Flight {},
    //     Math {},
    //     Weather {},
    //     Clip {},
    //     Translate {},
    //     Time {},
    //     // above most of the time isn't visible
    //     App {},
    //     Web {},
    //     Finder {}
    // ]
}
