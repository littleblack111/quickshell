pragma Singleton
import Quickshell
import QtQuick

Singleton {
    id: root

    PersistentProperties {
        id: persist
        reloadableId: "launcherSelectionState"

        property string input: ""
        property int cursorPosition: 0
        property int selectedPriority: 0
        property int previousSelectedPriority: 0
    }

    property Item selected: null
    property alias input: persist.input
    property alias cursorPosition: persist.cursorPosition
    property var priorities: []
    property alias selectedPriority: persist.selectedPriority
    property alias previousSelectedPriority: persist.previousSelectedPriority
    property var widgets: []

    onSelectedPriorityChanged: {
        if (selectedPriority > previousSelectedPriority) {
            priorities[selectedPriority].home();
            priorities[selectedPriority].syncSelectionState();
        } else {
            priorities[selectedPriority].end();
            priorities[selectedPriority].syncSelectionState();
        }

        previousSelectedPriority = selectedPriority;
    }
    // order them based on widgets(which came from order from config)
    onPrioritiesChanged: {
        for (let i = priorities.length - 1; i >= 0; i--)
            if (!priorities[i] || priorities[i].priority !== true)
                priorities.splice(i, 1);

        priorities.sort((a, b) => (widgets.indexOf(a) - widgets.indexOf(b)) || 0);

        priorities.forEach((item, index) => {});

        priorities[selectedPriority]?.syncSelectionState();
    }
}
