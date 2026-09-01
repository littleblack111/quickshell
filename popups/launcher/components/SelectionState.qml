pragma Singleton
import Quickshell
import QtQuick

// FIXME: fix some selection not show/updated when deselected i.e. "pi" from app back to calc wont visually show deselection of last app
// FIXME: icon/answer not updated when changed to non first priority
Singleton {
    id: root

    PersistentProperties {
        id: persist
        reloadableId: "launcherSelectionState"

        property string input: ""
        property int cursorPosition: 0
        property int selectedPriority: 0
    }

    property Item selected: null
    property alias input: persist.input
    property alias cursorPosition: persist.cursorPosition
    property var priorities: []
    property alias selectedPriority: persist.selectedPriority
    property var widgets: []
    signal syncSelectionState

    onSelectedPriorityChanged: {
        priorities[selectedPriority]?.enter();
        priorities[selectedPriority]?.syncSelectionState();
    }

    // order them based on widgets(which came from order from config)
    onPrioritiesChanged: {
        for (let i = priorities.length - 1; i >= 0; i--)
            if (!priorities[i] || priorities[i].priority !== true)
                priorities.splice(i, 1);

        priorities.sort((a, b) => (widgets.indexOf(a) - widgets.indexOf(b)) || 0);

        Qt.callLater(function step() {
            if (!priorities[selectedPriority] && selectedPriority > 0) {
                selectedPriority--;
                Qt.callLater(step);
            } else {
                priorities[selectedPriority]?.enter();
                priorities[selectedPriority]?.syncSelectionState();
            }
        });
    }
}
