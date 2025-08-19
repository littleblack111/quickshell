import Quickshell
import Quickshell.Io
import "bar"
import "popups/launcher"

import QtQuick

Scope {
    id: root

    property var standaloneObj: ({})

    Bar {}

    PersistentProperties {
        id: loaderProp
        reloadableId: "launcherLoaderProp"

        property bool active: false
    }
    LazyLoader {
        id: launcherLoader

        active: loaderProp.active

        component: Launcher {
            parentLoader: loaderProp
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
            loaderProp.active = !loaderProp.active;
        }

        function standalone(component: string): void {
            if (root.standaloneObj.name === component) {
                root.standaloneObj.obj.active = !root.standaloneObj.obj.active;
                return;
            }
            root.standaloneObj.obj = Qt.createQmlObject(`
				import Quickshell
				import QtQuick
				import "popups/launcher"
				import "popups/launcher/components"

				LazyLoader {
					property QtObject selectionState: QtObject {
						property Item selected: null
						property string input: ""
						property int cursorPosition: 0
						property var priorities: []
						property int selectedPriority: 0
						property int previousSelectedPriority: 0
						property var widgets: []
					}
					readonly property list<Component> widgets: [
						Component {
							Loader {
								sourceComponent: Qt.createComponent("popups/launcher/components/" + "${component}.qml")
								onLoaded: {
									item.standalone = true
									item.state = selectionState;
									item.close.connect(() => root.active = false);
								}
							}
						}
					]
					id: root
					active: true
					component: Launcher {
						widgetItems: widgets
						state: selectionState
						parentLoader: root
					}
				}
			`, root);
            root.standaloneObj.name = component;
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
