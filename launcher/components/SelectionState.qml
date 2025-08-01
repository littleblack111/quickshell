pragma Singleton
import Quickshell
import QtQuick

Singleton {
    property Item selected: null
    property string input: ""
    property int cursorPosition: 0
    property var priorities: []
    property var widgets: []

    // order them based on widgets(which came from order from config)
    onPrioritiesChanged: {
        // priorities = priorities.filter(item => item.priority === true); // bind loop
        // dunno y ts works w/o triggering a binding loop but okay..
        for (let i = 0; i < priorities.length; i++)
            if (priorities[i].priority !== true)
                priorities.splice(i, 1);

        priorities.sort((a, b) => widgets.indexOf(a) - widgets.indexOf(b));
        priorities.forEach((item, index) => {});
    }

    function clear() {
        selected = null;
    }
}
