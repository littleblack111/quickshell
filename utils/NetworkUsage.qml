pragma Singleton
// pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Io
import QtQuick
import "networkUsage.js" as Network
import qs.config

Singleton {
    property int up: 0
    property string upUnit: ""
    property int down: 0
    property string downUnit: ""

    property string __iface: ""
    property var __prev: ({
            rx: 0,
            tx: 0
        })

    Timer {
        interval: General.resourceUpdateInterval * 1000
        running: true
        repeat: true
        onTriggered: update()
    }

    function update() {
        __iface = Network.defaultInterface(getRouteProcess.stdout.text);
        const cur = Network.getRxTxBytes(getNetDevProcess.stdout.text, __iface);
        const sec = General.resourceUpdateInterval;
        const rawUp = (cur.tx - __prev.tx) / sec;
        const rawDown = (cur.rx - __prev.rx) / sec;

        up = Network.formatSize(rawUp, false);
        upUnit = Network.formatSize(rawUp, true);
        down = Network.formatSize(rawDown, false);
        downUnit = Network.formatSize(rawDown, true);

        __prev = cur;
        getRouteProcess.running = true;
        getNetDevProcess.running = true;
    }

    Process {
        id: getRouteProcess
        running: true
        command: ["ip", "route"]
        stdout: StdioCollector {}
    }

    Process {
        id: getNetDevProcess
        running: true
        command: ["cat", "/proc/net/dev"]
        stdout: StdioCollector {}
    }

    Component.onCompleted: {
        getRouteProcess.running = true;
        getNetDevProcess.running = true;
        __iface = Network.defaultInterface(getRouteProcess.stdout.text);
        __prev = Network.getRxTxBytes(getNetDevProcess.stdout.text, __iface);
    }
}
