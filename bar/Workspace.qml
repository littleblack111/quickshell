import QtQuick.Layouts
import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import qs.config as Config
import qs.components

Item {
    id: root

    // required property ShellScreen screen // multi monitor
    property var ws: Hyprland.workspaces

    // readonly property HyprlandMonitor monitor: Hyprland.monitorFor(screen) // multi monitor
    // dont work no more for some reason
    function isActive(index: int): bool {
        for (let i of ws.values)
            if (i.id === (index + 1) && i.active)
                return true;
        return false;
    }
    function isOccupied(index: int): bool {
        for (let i of ws.values) {
            if (i.id === (index + 1) && i?.toplevels?.values?.length > 0) {
                return true;
            }
        }
        return false;
    }

    implicitWidth: layout.implicitWidth

    RowLayout {
        id: layout
        implicitWidth: childrenRect.width
        anchors.verticalCenter: parent.verticalCenter

        spacing: Config.Bar.workspaceSpacing

        Repeater {
            model: Config.Bar.workspaces

            Rectangle {
                id: workspaceRect

                implicitWidth: !isActive(index) ? Config.Bar.workspaceIconSize : Config.Bar.workspaceActiveIconSize
                implicitHeight: Config.Bar.workspaceIconSize - Config.Bar.workspaceHorizontalSpacing
                radius: Config.Bar.workspaceRounding
                Icons {
                    anchors.centerIn: parent
                    text: Config.Icons.ws[index + 1]
                    font.pixelSize: Config.Bar.workspaceIconSize / 2
                    color: Config.Colors.foreground // TODO make IText w/ ts default color
                    opacity: !isOccupied(index) ? 0 : 1 // less contrast
                    // opacity: isActive(index) ? Config.Bar.workspaceActiveOpacity : isOccupied(index) ? Config.Bar.workspaceOpacity : Config.Bar.workspaceEmptyOpacity
                }

                color: isOccupied(index) ? Config.Colors.alt : Config.Colors.foreground
                opacity: isActive(index) && isOccupied(index) ? Config.Bar.workspaceActiveOpacity : isOccupied(index) ? Config.Bar.workspaceOpacity : Config.Bar.workspaceEmptyOpacity
            }
        }
    }
}
