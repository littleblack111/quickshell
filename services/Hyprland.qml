pragma Singleton

import Quickshell
import Quickshell.Hyprland
import QtQuick
import "../config"

Singleton {
    id: root

    readonly property var toplevels: Hyprland.toplevels
    readonly property var workspaces: Hyprland.workspaces
    readonly property var monitors: Hyprland.monitors
    // readonly property HyprlandToplevel activeToplevel: Hyprland.activeToplevel
    readonly property HyprlandWorkspace focusedWorkspace: Hyprland.focusedWorkspace
    readonly property HyprlandMonitor focusedMonitor: Hyprland.focusedMonitor
    readonly property int activeWs: focusedWorkspace?.id ?? 1

    function dispatch(request: string): void {
        Hyprland.dispatch(request);
    }

	function getAllWorkspaces(): var {
		var allWorkspaces = {
			values: [],
			count: 0
		};
		for (let i = 1; i <= Bar.workspaces; i++) {
			if (workspaces[i] === undefined) {
				allWorkspaces.values[i] = HyprlandWorkspace;
			}
		}
		return allWorkspaces;
	}

    Connections {
        target: Hyprland

        function onRawEvent(event: HyprlandEvent): void {
            if (event.name.endsWith("v2"))
                return;

            if (event.name.includes("mon"))
                Hyprland.refreshMonitors();
            else if (event.name.includes("workspace"))
                Hyprland.refreshWorkspaces();
            // else
            //     Hyprland.refreshToplevels();
        }
    }
}
