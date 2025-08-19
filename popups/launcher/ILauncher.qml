import Quickshell.Hyprland

import ".."

IPopup {
    id: root

    HyprlandFocusGrab {
        active: true
        windows: [root]
        onCleared: {
            parentLoader.active = false; // or active = true again
        }
    }
}
