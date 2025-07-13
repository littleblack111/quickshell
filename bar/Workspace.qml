import QtQuick.Layouts
import QtQuick
import Quickshell
import Quickshell.Hyprland
import qs.config as Config
import qs.components

Item {
    id: root

    property list<bool> workspaceOccupied: []

    function updateWorkspaceOccupied() {
        // workspaceOccupied = Array.from({ length: Config.options.bar.workspaces.shown }, (_, i) => {
        //     return Hyprland.workspaces.values.some(ws => ws.id === workspaceGroup * Config.options.bar.workspaces.shown + i + 1);
        // })
        workspaceOccupied = Array.from({
            length: Config.Bar.workspaces
        }, (_, i) => {
            return Hyprland.workspaces.values.some(ws => ws?.id === (i + 1));
        });
    }
    // dont work no more for some reason
    function isActive(index: int): bool {
        return Hyprland.focusedWorkspace?.id === (index + 1);
    }
    function isOccupied(index: int): bool {
        return workspaceOccupied[index] === true;
    }

    Connections {
        target: Hyprland.workspaces
        function onValuesChanged() {
            updateWorkspaceOccupied();
        }
    }

    Component.onCompleted: updateWorkspaceOccupied()

    RowLayout {
        id: layout
        implicitWidth: childrenRect.width
        anchors.verticalCenter: parent.verticalCenter

        spacing: Config.Bar.workspaceSpacing

        Repeater {
            model: Config.Bar.workspaces

            Rectangle {
                id: workspaceRect
                // text: Hyprland.focusedWorkspace?.id.toString() == (index + 1).toString()
                // text: isActive(index)

                implicitWidth: !isActive(index) ? Config.Bar.workspaceIconSize : Config.Bar.workspaceActiveIconSize
                implicitHeight: Config.Bar.workspaceIconSize - 10
                anchors {
                    topMargin: 20
                }
                radius: Config.Bar.workspaceRounding
                Icons {
                    anchors.centerIn: parent
                    text: Config.Icons.ws[index + 1]
                    font.pixelSize: Config.Bar.workspaceIconSize / 1.9
                    color: Config.Colors.foreground // TODO make IText w/ ts default color
                    // opacity: !isOccupied(index) ? 0 : 1 // less contrast
                    opacity: isActive(index) ? Config.Bar.workspaceActiveOpacity : isOccupied(index) ? Config.Bar.workspaceOpacity : Config.Bar.workspaceEmptyOpacity
                }
                color: isOccupied(index) ? Config.Colors.alt : Config.Colors.foreground
                opacity: isActive(index) ? Config.Bar.workspaceActiveOpacity : isOccupied(index) ? Config.Bar.workspaceOpacity : Config.Bar.workspaceEmptyOpacity
            }
        }
    }
}
