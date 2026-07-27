import Quickshell.Hyprland

import ".."

IPopup {
    id: root

    function closeLauncher() {
        parentLoader.active = false;
    }

    HyprlandFocusGrab {
        active: true
        windows: [root]
        onCleared: {
            root.closeLauncher();
        }
    }
}
