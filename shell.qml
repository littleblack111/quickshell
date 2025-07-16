import Quickshell
import Quickshell.Io
import "bar"

import QtQuick
import QtQuick.Layouts

Scope {
    Bar {}

    IpcHandler {
        target: "qs"

        function reload(hard: bool): void {
            Quickshell.reload(hard);
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
