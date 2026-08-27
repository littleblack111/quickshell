import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland

import qs.components

IWindow {
    required property var parentLoader
    
    property bool focusedScreenOnly: false
    property string _activeMonitorName: Hyprland.focusedMonitor ? Hyprland.focusedMonitor.name : ""
    property var _focusedScreen: {
        var name = _activeMonitorName;
        var screens = Quickshell.screens;
        for (var i = 0; i < screens.length; i++) {
            if (screens[i].name === name) return screens[i];
        }
        return null;
    }

    screen: focusedScreenOnly && _focusedScreen ? _focusedScreen : modelData

    focusable: true

    layer: WlrLayer.Overlay

    anchors {
        top: false
        bottom: false
        left: false
        right: false
    }
}
