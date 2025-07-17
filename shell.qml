import Quickshell
import Quickshell.Io
import "bar"
import qs.services

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

    // Timer {
    //     running: true
    //     interval: 1000
    //     repeat: true
    //     onTriggered: {
    //         console.log(Lyrics.lyrics.map(function (o) {
    //             return o.position + ": " + o.line;
    //         }).join("\n"));
    //     }
    // }

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
