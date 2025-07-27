import Quickshell
import Quickshell.Io
import "bar"
import "launcher"

import QtQuick
import QtQuick.Layouts

Scope {
    Bar {}
    LazyLoader {
        id: launcherLoader
        component: UnifiedLauncher {}
    }

    IpcHandler {
        target: "qs"

        function reload(hard: bool): void {
            Quickshell.reload(hard);
        }
    }
    IpcHandler {
        target: "launcher"

        function toggle() {
            launcherLoader.active = !launcherLoader.active;
        }
    }

    Connections {
        target: Quickshell
        function onReloadCompleted() {
            Quickshell.inhibitReloadPopup();
        }
        // function onReloadFailed() {
        //     Quickshell.inhibitReloadPopup();
        // }
    }
}
