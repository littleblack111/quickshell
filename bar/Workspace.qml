import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import qs.config
import qs.components

Item {
    id: root

    implicitWidth: layout.implicitWidth

    property var ws: Hyprland.workspaces
    property int activeIndex: -1
    property bool activeOccupied: false
    property real activeRectX: {
        if (activeIndex < 0)
            return 0;
        return layout.x + activeIndex * Bar.workspaceIconSize + activeIndex * Bar.workspaceSpacing;
    }

    function getWorkspaceStats(index) {
        const w = ws.values.find(i => i.id === index + 1);
        return {
            isOccupied: w?.toplevels?.values?.length,
            isActive: w?.active,
            isUrgent: w?.urgent
        };
    }

    Rectangle {
        id: activeRect
        x: activeRectX
        anchors.verticalCenter: layout.verticalCenter
        implicitWidth: Bar.workspaceActiveIconSize
        implicitHeight: Bar.workspaceIconSize - Bar.workspaceHorizontalSpacing
        radius: Bar.workspaceRounding
        color: root.activeOccupied ? Colors.alt : Colors.foreground
        opacity: root.activeOccupied ? Bar.workspaceActiveOpacity : Bar.workspaceEmptyOpacity / 3
        Behavior on x {
            ISpringAnimation {}
        }
        Behavior on color {
            ColorAnimation {
                duration: Bar.workspaceAnimationDuration
                easing.type: Easing.InOutQuad
            }
        }
        Behavior on opacity {
            NumberAnimation {
                duration: Bar.workspaceAnimationDuration
                easing.type: Easing.InOutQuad
            }
        }
    }

    RowLayout {
        id: layout
        anchors.verticalCenter: parent.verticalCenter
        implicitWidth: repeater.width
        spacing: Bar.workspaceSpacing

        Repeater {
            id: repeater
            model: Bar.workspaces

            Rectangle {
                property var st: getWorkspaceStats(index)
                property bool active: st?.isActive || false

                implicitWidth: active ? Bar.workspaceActiveIconSize : Bar.workspaceIconSize
                implicitHeight: Bar.workspaceIconSize - Bar.workspaceHorizontalSpacing
                radius: Bar.workspaceRounding
                color: st.isOccupied ? Colors.alt : Colors.foreground
                opacity: active && st.isOccupied ? Bar.workspaceActiveOpacity : st.isOccupied ? Bar.workspaceOpacity : Bar.workspaceEmptyOpacity

                Icon {
                    anchors.centerIn: parent
                    text: !st.isUrgent ? Icons.ws[index + 1] : Icons.ws['urgent']
                    font.pixelSize: !active ? Bar.workspaceIconSize / 2 : Bar.workspaceActiveIconSize / 2.5
                    color: Colors.foreground
                    opacity: !st.isOccupied ? 0 : 1
                    Behavior on font.pixelSize {
                        ISpringAnimation {}
                    }
                }

                Behavior on opacity {
                    NumberAnimation {
                        duration: Bar.workspaceAnimationDuration
                        easing.type: Easing.InOutQuad
                    }
                }
                Behavior on implicitWidth {
                    NumberAnimation {
                        duration: Bar.workspaceAnimationDuration
                        easing.type: Easing.InOutQuad
                    }
                }
                Behavior on color {
                    ColorAnimation {
                        duration: Bar.workspaceAnimationDuration
                        easing.type: Easing.InOutQuad
                    }
                }

                onActiveChanged: if (active) {
                    root.activeIndex = index;
                    root.activeOccupied = st.isOccupied;
                }
            }
        }
    }
}
