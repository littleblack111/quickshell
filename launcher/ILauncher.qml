import Quickshell
import QtQuick

import qs.components
import qs.config

IWindow {
    // TODO: optional only display on focused screen
    name: "launcher"
    focusable: true

    anchors {
        top: false
        bottom: false
        left: false
        right: false
    }

    color: Qt.rgba(Colors.background3.r, Colors.background3.g, Colors.background3.b, Bar.bgTransparency)
}
