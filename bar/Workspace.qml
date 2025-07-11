import QtQuick.Layouts
import QtQuick
import Quickshell
import qs.services
import qs.config

Item {
    id: root

    property list<bool> workspaceOccupied: []

    function updateWorkspaceOccupied() {
        // workspaceOccupied = Array.from({ length: Config.options.bar.workspaces.shown }, (_, i) => {
        //     return SHyprland.workspaces.values.some(ws => ws.id === workspaceGroup * Config.options.bar.workspaces.shown + i + 1);
        // })
        workspaceOccupied = Array.from({
            length: Bar.workspaces
        }, (_, i) => {
            return SHyprland.workspaces.values.some(ws => ws.id === (i + 1));
        });
    }
    function isActive(index: int): bool {
        SHyprland.focusedWorkspace.id.toString() == (index + 1).toString();
    }
    function isOccupied(index: int): bool {
        return workspaceOccupied[index] === true;
    }

    Connections {
        target: SHyprland.workspaces
        function onValuesChanged() {
            updateWorkspaceOccupied();
        }
    }

    Component.onCompleted: updateWorkspaceOccupied()

    RowLayout {
        id: layout
        implicitWidth: parent.width
        height: Bar.height

        spacing: 0

        Repeater {
            model: Bar.workspaces

            Rectangle {
                Text {
                    text: SHyprland.focusedWorkspace?.id.toString() == (index + 1).toString()
                    // text: isActive(index)
                }
                implicitWidth: 10
                implicitHeight: 10
                opacity: !isOccupied(index) ? 0.2 : 1
                // color: isActive(index) ? "#00ff00" : "#ffffff"
                color: "#000000"
            }
        }
    }
}
