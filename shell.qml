//@ pragma UseQApplication

import Quickshell
import Quickshell.Io
import "bar"
import "popups/launcher"

import QtQuick

import core

import qs.services

Scope {
	id: root

	property var standaloneObj: ({})

	Bar {}

	PersistentProperties {
		id: loaderProp
		reloadableId: "launcherLoaderProp"

		property bool active: false
	}
	// TODO: cache/don't destory when closed(active=false)
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
			root.standaloneObj.obj = Qt.createComponent("popups/launcher/StandaloneLauncher.qml", Component.PreferSynchronous, root).createObject(root, {
				componentName: component
			});
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
