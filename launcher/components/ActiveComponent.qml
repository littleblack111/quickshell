pragma Singleton
import Quickshell
import QtQuick

Singleton {
    property Item selected: null
    property var exec: null
    property string input: ""
    property int cursorPosition: 0
    property var priorities: []
    property var widgets: []

    // order them based on widgets(which came from order from config)
    onPrioritiesChanged: {
        priorities.sort((a, b) => widgets.indexOf(a) - widgets.indexOf(b));
        console.log(priorities[0].name);
    }

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
