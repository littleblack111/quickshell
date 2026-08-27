pragma Singleton

// TODO: move to rust or native Network modules
import Quickshell
import Quickshell.Networking
import QtQuick

import qs.config

Singleton {
    id: root

    property var activeDevice: {
        let devs = Networking.devices.values;
        let active = null;
        for (let i = 0; i < devs.length; ++i) {
            if (devs[i].connected && !active) {
                active = devs[i];
            }
        }
        return active;
    }

    property var activeNetwork: {
        let dev = activeDevice;
        if (!dev) return null;
        let nets = dev.networks.values;
        let active = null;
        for (let i = 0; i < nets.length; ++i) {
            if (nets[i].connected && !active) {
                active = nets[i];
            }
        }
        return active;
    }

    property bool wifi: activeDevice && activeDevice.type === DeviceType.Wifi
    property bool ethernet: activeDevice && activeDevice.type === DeviceType.Wired
    property string networkName: activeNetwork ? activeNetwork.name : ""
    
    // signalStrength is 0.0 to 1.0, convert to 0-100
    property int networkStrength: (wifi && activeNetwork && activeNetwork.signalStrength !== undefined) ? Math.round(activeNetwork.signalStrength * 100) : 0

    property string state: ethernet ? Icons.resource.network.wifi : (networkName.length > 0 && networkName !== "lo") ? (networkStrength >= 90 ? Icons.resource.network.wifi.max : networkStrength >= 80 ? Icons.resource.network.wifi.high : networkStrength >= 60 ? Icons.resource.network.wifi.mid : networkStrength >= 40 ? Icons.resource.network.wifi.low : networkStrength >= 20 ? Icons.resource.network.wifi.min : Icons.resource.network.disconnected) : Icons.resource.network.disconnected
}
