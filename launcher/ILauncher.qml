import Quickshell
import Quickshell.Hyprland
import QtQuick.Controls
import QtQuick

import qs.components
import qs.config

IWindow {
    id: root
    required property var parentLoader
    // TODO: optional only display on focused screen
    focusable: true

    anchors {
        top: false
        bottom: false
        left: false
        right: false
    }

    HyprlandFocusGrab {
        active: true
        windows: [root]
        onCleared: {
            parentLoader.active = false;
        }
    }
}
