import Quickshell.Wayland

import qs.components

IWindow {
    required property var parentLoader
    // TODO: optional only display on focused screen
    focusable: true

    layer: WlrLayer.Overlay

    anchors {
        top: false
        bottom: false
        left: false
        right: false
    }
}
