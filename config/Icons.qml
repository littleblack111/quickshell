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
}
