pragma Singleton
import Quickshell
import QtQuick

Singleton {
    property Item __selected: null
    property var __exec: null

    function exec() {
        if (__exec) {
            __exec();
        }
    }

    function clear() {
        __selected = null;
        __exec = null;
    }
}
