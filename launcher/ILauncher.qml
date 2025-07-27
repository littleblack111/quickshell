import Quickshell
import QtQuick

import qs.components
import qs.config

IWindow {
    // TODO: optional only display on focused screen
    name: "launcher"

    anchors {
        top: false
        bottom: false
        left: false
        right: false
    }

    color: Qt.rgba(WallustColors.background.r, WallustColors.background.g, WallustColors.background.b, Bar.bgTransparency)
}
