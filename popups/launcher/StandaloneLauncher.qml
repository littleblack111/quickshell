import Quickshell
import QtQuick

import "components"

LazyLoader {
	id: root

	required property string componentName

	// TODO: just use the same selectionState
	property QtObject selectionState: QtObject {
		property Item selected: null
		property string input: ""
		property int cursorPosition: 0
		property var priorities: []
		property int selectedPriority: 0
		property var widgets: []
	}

	readonly property list<Component> widgets: [
		Component {
			Loader {
				sourceComponent: Qt.createComponent(`components/${root.componentName}.qml`)
				onLoaded: {
					item.standalone = true;
					item.state = selectionState;
					item.priority = true;
					item.close.connect(() => root.active = false);
				}
			}
		}
	]

	active: true
	component: Launcher {
		name: "quickshell::launcher::${component}"
		widgetItems: widgets
		state: selectionState
		parentLoader: root
	}
}
