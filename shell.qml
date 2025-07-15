import Quickshell
import "bar"

import QtQuick
import QtQuick.Layouts

Scope {
    Bar {}
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
