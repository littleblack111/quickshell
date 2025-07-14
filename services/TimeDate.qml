pragma Singleton

import Quickshell
import QtQuick

Singleton {
    id: root
    readonly property string time: {
        // fuck you qt give me my 12 hr time
        var h = clock.date.getHours();
        var m = clock.date.getMinutes();
        var s = clock.date.getSeconds();
        h = h % 12;
        if (h === 0)
            h = 12;
        return (h < 10 ? "0" : "") + h + ":" + (m < 10 ? "0" : "") + m + ":" + (s < 10 ? "0" : "") + s;
    }
    readonly property string date: Qt.formatDateTime(clock.date, "dddd dd/MM")

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }
}
