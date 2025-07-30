pragma Singleton
import Quickshell
import QtQuick

Singleton {
    property Item selected: null
    property var exec: null

    function exec() {
        if (exec) {
            exec();
        }
    }

    function clear() {
        selected = null;
        exec = null;
    }
}
