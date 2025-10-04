pragma Singleton
// pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Io
import QtQuick

import qs.config

Singleton {
    id: root

    property bool wifi: true
    property bool ethernet: false
    property string networkName: ""
    property int networkStrength
    property int count
    property string state: ethernet ? Icons.resource.network.wifi : (networkName.length >= 0 && networkName !== "lo") ? (networkStrength >= 90 ? Icons.resource.network.wifi.max : networkStrength >= 80 ? Icons.resource.network.wifi.high : networkStrength >= 60 ? Icons.resource.network.wifi.mid : networkStrength >= 40 ? Icons.resource.network.wifi.low : networkStrength >= 20 ? Icons.resource.network.wifi.min : Icons.resource.network.disconnected) : Icons.resource.network.disconnected
    property alias updateNetworkNameProc: updateNetworkName

    function update() {
        updateNetworkStrength.running = true;
        if (count >= 50) {
            updateNetworkName.running = true;
            count = 0;
        }
        count++;
    }

    Component.onCompleted: {
        updateConnectionType.startCheck();
    }

    Timer {
        interval: General.resourceUpdateInterval
        running: true
        repeat: true
        onTriggered: {
            root.update();
            interval = General.resourceUpdateInterval * 1000;
        }
    }

    Process {
        id: updateConnectionType
        property string buffer
        command: ["nmcli", "-t", "-f", "TYPE", "c", "show", "--active"]
        running: true
        function startCheck() {
            buffer = "";
            updateConnectionType.running = true;
        }
        stdout: SplitParser {
            onRead: data => {
                updateConnectionType.buffer += data + "\n";
            }
        }
        onExited: (exitCode, exitStatus) => {
            const lines = updateConnectionType.buffer.trim().split('\n');
            let hasEthernet = false;
            let hasWifi = false;
            lines.forEach(line => {
                if (line.includes("ethernet"))
                    hasEthernet = true;
                else if (line.includes("wireless"))
                    hasWifi = true;
            });
            root.ethernet = hasEthernet;
            root.wifi = hasWifi;
        }
    }

    Process {
        id: updateNetworkName
        command: ["sh", "-c", "nmcli -t -f NAME c show --active | head -1"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                root.networkName = data;
            }
        }
    }

    Process {
        id: updateNetworkStrength
        running: true
        command: ["sh", "-c", "nmcli -f IN-USE,SIGNAL,SSID device wifi | awk '/^\*/{if (NR!=1) {print $2}}'"]
        stdout: SplitParser {
            onRead: data => {
                root.networkStrength = parseInt(data);
            }
        }
    }
}
