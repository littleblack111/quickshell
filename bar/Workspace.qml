import QtQuick.Layouts
import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import qs.config
import qs.components

Item {
    id: root

    // required property ShellScreen screen // multi monitor
    property var ws: Hyprland.workspaces

    // readonly property HyprlandMonitor monitor: Hyprland.monitorFor(screen) // multi monitor
    // dont work no more for some reason

    function getWorkspaceStats(index) {
        const w = ws.values.find(i => i.id === index + 1);
        return {
            isOccupied: w?.toplevels?.values?.length,
            isActive: w?.active,
            isUrgent: w?.urgent
        };
    }

    implicitWidth: layout.implicitWidth

    RowLayout {
        id: layout
        implicitWidth: childrenRect.width
        anchors.verticalCenter: parent.verticalCenter

        spacing: Bar.workspaceSpacing

        Repeater {
            model: Bar.workspaces

            Rectangle {
                id: workspaceRect
                property var st: getWorkspaceStats(index)

                implicitWidth: !st.isActive ? Bar.workspaceIconSize : Bar.workspaceActiveIconSize
                implicitHeight: Bar.workspaceIconSize - Bar.workspaceHorizontalSpacing
                radius: Bar.workspaceRounding
                Icon {
                    anchors.centerIn: parent
                    text: !st.isUrgent ? Icons.ws[index + 1] : Icons.ws['urgent'] // TODO: urgent = red
                    font.pixelSize: Bar.workspaceIconSize / 2
                    color: Colors.foreground // TODO make IText w/ ts default color
                    opacity: !st.isOccupied ? 0 : 1 // less contrast
                    // opacity: isActive(index) ? Bar.workspaceActiveOpacity : isOccupied(index) ? Bar.workspaceOpacity : Bar.workspaceEmptyOpacity
                }

                color: st.isOccupied ? Colors.alt : Colors.foreground
                opacity: st.isActive && st.isOccupied ? Bar.workspaceActiveOpacity : st.isOccupied ? Bar.workspaceOpacity : Bar.workspaceEmptyOpacity

                Behavior on opacity {
                    NumberAnimation {
                        duration: 200
                        easing.type: Easing.InOutQuad
                    }
                }
                Behavior on implicitWidth {
                    NumberAnimation {
                        duration: 200
                        easing.type: Easing.InOutQuad
                    }
                }
            }
        }
    }
}
