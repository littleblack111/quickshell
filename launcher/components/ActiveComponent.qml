pragma Singleton
import Quickshell
import QtQuick

Singleton {
    property Item selected: null
    property var exec: null
    property string input: ""
    property int cursorPosition: 0
    property var priorities: []
	property var widgets:[]

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
