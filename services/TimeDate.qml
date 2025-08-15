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
    readonly property int hours: {
        var h = clock.date.getHours();
        h = h % 12;
        if (h === 0)
            h = 12;
        return h;
    }
    readonly property int minutes: clock.date.getMinutes()
    readonly property int seconds: clock.date.getSeconds()

    readonly property string date: Qt.formatDateTime(clock.date, "dddd dd/MM")

    function sinceWhen(d) {
        if (typeof d === "string")
            return;

        var now = clock.date;

        function startOfDay(x) {
            return new Date(x.getFullYear(), x.getMonth(), x.getDate(), 0, 0, 0, 0);
        }

        function startOfWeek(x) {
            var dow = x.getDay();
            var mondayOffset = (dow + 6) % 7;
            var sod = startOfDay(x);
            sod.setDate(sod.getDate() - mondayOffset);
            return sod;
        }

        function fmt12h(dateObj) {
            var h24 = dateObj.getHours();
            var m = dateObj.getMinutes();
            var h12 = h24 % 12;
            if (h12 === 0)
                h12 = 12;
            var ampm = h24 < 12 ? "AM" : "PM";
            return ((h12 < 10 ? "0" : "") + h12 + ":" + (m < 10 ? "0" : "") + m + " " + ampm);
        }

        function weekdayName(dateObj) {
            return Qt.formatDateTime(dateObj, "dddd");
        }

        var nowSOD = startOfDay(now).getTime();
        var dSOD = startOfDay(d).getTime();
        if (nowSOD === dSOD) {
            return fmt12h(d);
        }

        var nowSOW = startOfWeek(now).getTime();
        var dSOW = startOfWeek(d).getTime();
        if (nowSOW === dSOW) {
            return weekdayName(d) + " " + fmt12h(d);
        }

        var ymd = Qt.formatDateTime(d, "yyyy-MM-dd");
        var h24 = d.getHours();
        var m = d.getMinutes();

        var h12 = h24 % 12;
        if (h12 === 0)
            h12 = 12;
        var ampm = h24 < 12 ? "AM" : "PM";
        var hhmm = (h12 < 10 ? "0" : "") + h12 + (m < 10 ? "0" : "") + m + " " + ampm;

        return ymd + " at " + hhmm;
    }

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }
}
