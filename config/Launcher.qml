pragma Singleton

import Quickshell
import qs.launcher.widgets

Singleton {
    id: root

    readonly property int width: 800
    readonly property int height: 1000

    readonly property int widgetWidth: 750
    readonly property int widgetHeight: 200

    readonly property int borderRadius: Style.rounding.small

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
