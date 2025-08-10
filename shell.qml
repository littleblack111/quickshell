import Quickshell
import Quickshell.Io
import "bar"
import "launcher"

import QtQuick
import QtQuick.Layouts

Scope {
    id: root
    Bar {}
    LazyLoader {
        id: launcherLoader
        component: Launcher {
            parentLoader: launcherLoader
        }
    }

    IpcHandler {
        target: "qs"

        function reload(hard: bool): void {
            Quickshell.reload(hard);
        }
    }
    IpcHandler {
        target: "launcher"

        function toggle() {
            launcherLoader.active = !launcherLoader.active;
        }

        function standalone(component: string): void {
            Qt.createQmlObject(`
        import Quickshell
        import QtQuick
        import "launcher"
        import "launcher/components"

        LazyLoader {
			// component SelectionState: QtObject {
				// property Item selected: null
				// property string input: ""
				// property int cursorPosition: 0
				// property var priorities: []
				// property int selectedPriority: 0
				// property int previousSelectedPriority: 0
				// property var widgets: []
				//

			// }
            readonly property list<Component> widgets: [
                Component {
                    Loader {
                        sourceComponent: Component {
                            ${component} {}
                        }
                    }
                }
            ]
            id: root
            active: true
            component: Launcher {
				widgetItems: widgets
                parentLoader: root
            }
        }
    `, root);
        }
    }

    Connections {
        target: Quickshell
        function onReloadCompleted() {
            Quickshell.inhibitReloadPopup();
        }
        // function onReloadFailed() {
        //     Quickshell.inhibitReloadPopup();
        // }
    }
}
