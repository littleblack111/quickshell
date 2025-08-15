pragma Singleton
// pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Io
import QtQuick
import "../utils/networkUsage.js" as Network
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
        try {
            __iface = Network.defaultInterface(getRouteProc.stdout.text);
        } catch (e) {
            getRouteProc.running = true;
        }
        const cur = Network.getRxTxBytes(getNetDevProc.stdout.text, __iface);
        const sec = General.resourceUpdateInterval;
        const rawUp = (cur.tx - __prev.tx) / sec;
        const rawDown = (cur.rx - __prev.rx) / sec;

        up = Network.formatSize(rawUp, false);
        upUnit = Network.formatSize(rawUp, true);
        down = Network.formatSize(rawDown, false);
        downUnit = Network.formatSize(rawDown, true);

        __prev = cur;
        getRouteProc.running = true;
        getNetDevProc.running = true;
    }

    Process {
        id: getRouteProc
        running: true
        command: ["ip", "route"]
        stdout: StdioCollector {}
    }

    Process {
        id: getNetDevProc
        running: true
        command: ["cat", "/proc/net/dev"]
        stdout: StdioCollector {}
    }

    Component.onCompleted: {
        getRouteProc.running = true;
        getNetDevProc.running = true;
        if (getRouteProc.stdout.text)
            __iface = Network.defaultInterface(getRouteProc.stdout.text);
        if (getNetDevProc.stdout.text)
            __prev = Network.getRxTxBytes(getNetDevProc.stdout.text, __iface);
    }
}
