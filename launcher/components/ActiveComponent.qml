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
        // priorities = priorities.filter(item => item.priority === true); // bind loop
        // dunno y ts works w/o triggering a binding loop but okay..
        for (let i = 0; i < priorities.length; i++)
            if (priorities[i].priority !== true)
                priorities.splice(i, 1);

        priorities.sort((a, b) => widgets.indexOf(a) - widgets.indexOf(b));
        priorities.forEach((item, index) => {});
    }

    Component.onCompleted: {
        // reverify priorities as widgets may forgot to unset them
        // console.log('input', input);
        for (const item of widgets) {
            item.processed = item.process();
            // console.log('aasdsafasdfafsd', item.predictiveCompletion);
        }
        priorities = priorities.filter(item => item.priority === true);
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
