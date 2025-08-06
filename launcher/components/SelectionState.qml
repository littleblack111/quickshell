pragma Singleton
import Quickshell
import QtQuick

Singleton {
    property Item selected: null
    property string input: ""
    property int cursorPosition: 0
    property var priorities: []
    property int selectedPriority: 0
    property int previousSelectedPriority: 0
    property var widgets: []

    onSelectedPriorityChanged: {
        if (selectedPriority > previousSelectedPriority)
            priorities[selectedPriority].home();
        else
            priorities[selectedPriority].end();

        previousSelectedPriority = selectedPriority;
    }

    // order them based on widgets(which came from order from config)
    onPrioritiesChanged: {
        for (let i = priorities.length - 1; i >= 0; i--)
            if (!priorities[i] || priorities[i].priority !== true)
                priorities.splice(i, 1);

        priorities.sort((a, b) => (widgets.indexOf(a) - widgets.indexOf(b)) || 0);

        priorities.forEach((item, index) => {});
    }

    function clear() {
        selected = null;
    }
}
