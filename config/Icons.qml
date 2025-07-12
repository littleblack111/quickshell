pragma Singleton

import Quickshell

Singleton {
    id: root

    readonly property var ws: ({
            1: "",
            2: "",
            3: "",
            4: "",
            5: "",
            6: "",
            7: "",
            8: "",
            9: "",
            urgent: "",
            active: "",
            default: " "
        })

    readonly property var media: ({
            play: "",
            pause: "",
            stop: "",
            // next: "",
            // prev: "",
            mute: "",
            unmute: ""
        })

    readonly property var wifi: ({
            min: "󰤯",
            low: "󰤟",
            mid: "󰤢",
            high: "󰤥",
            max: "󰤨"
        })

    readonly property var network: ({
            disconnected: "󰤭",
            download: "",
            upload: "",
            wifi: wifi
        })

    readonly property var resource: ({
            cpu: "",
            memory: "󰍛",
            disk: "",
            gpu: "󱓞",
            temp: "",
            network: network,
            clock: "",
            calendar: ""
        })

    readonly property var power: ({
            shutdown: "",
            dpms: "󰶐",
            lock: "󰍁",
            suspend: "󰤄",
            restart: ""
        })
}
