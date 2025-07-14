import QtQuick.Layouts
import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import qs.config
import qs.components

Item {
    id: root
    property var ws: Hyprland.workspaces
    function getWorkspaceStats(index) {
        const w = ws.values.find(i => i.id === index + 1);
        return {
            isOccupied: Boolean(w?.toplevels?.values?.length),
            isActive: Boolean(w?.active),
            isUrgent: Boolean(w?.urgent)
        };
    }
    implicitWidth: layout.implicitWidth
    property int activeIndex: 0
    property int prevIndex: 0

    Rectangle {
        id: activeRect
        anchors.verticalCenter: parent.verticalCenter
        height: Bar.workspaceIconSize - Bar.workspaceHorizontalSpacing
        width: Bar.workspaceIconSize
        radius: Bar.workspaceRounding
        color: Colors.alt
        opacity: Bar.workspaceActiveOpacity
        Behavior on x {
            NumberAnimation {
                duration: Bar.workspaceAnimationTransition
                easing.type: Easing.OutQuad
            }
        }
        Behavior on width {
            NumberAnimation {
                duration: Bar.workspaceAnimationExpand
                easing.type: Easing.OutQuad
            }
        }
    }

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
                property bool active: st.isActive
                property bool shouldExpand: false

                implicitWidth: shouldExpand ? Bar.workspaceActiveIconSize : Bar.workspaceIconSize
                implicitHeight: Bar.workspaceIconSize - Bar.workspaceHorizontalSpacing
                radius: Bar.workspaceRounding

                Behavior on implicitWidth {
                    NumberAnimation {
                        duration: shouldExpand ? Bar.workspaceAnimationExpand : Bar.workspaceAnimationShrink
                        easing.type: Easing.OutQuad
                    }
                }

                SequentialAnimation {
                    id: activeRectAnimation
                    PauseAnimation {
                        duration: Bar.workspaceAnimationTransition
                    }
                    ScriptAction {
                        script: {
                            activeRect.x = workspaceRect.x;
                            activeRect.width = Bar.workspaceActiveIconSize;
                            workspaceRect.shouldExpand = true;
                        }
                    }
                }

                Component.onCompleted: {
                    if (active) {
                        root.activeIndex = index;
                        root.prevIndex = index;
                        shouldExpand = true;
                        activeRect.x = x;
                        activeRect.width = Bar.workspaceActiveIconSize;
                    }
                }

                onActiveChanged: {
                    if (active) {
                        root.prevIndex = root.activeIndex;
                        root.activeIndex = index;
                        activeRect.width = Bar.workspaceIconSize;
                        layout.children[root.prevIndex].shouldExpand = false;
                        activeRect.x = layout.children[root.prevIndex].x;
                        activeRectAnimation.start();
                    }
                }

                Icon {
                    anchors.centerIn: parent
                    text: !st.isUrgent ? Icons.ws[index + 1] : Icons.ws['urgent']
                    font.pixelSize: Bar.workspaceIconSize / 2
                    color: Colors.foreground
                    opacity: st.isOccupied ? 1 : 0
                }

                color: st.isOccupied ? Colors.alt : Colors.foreground
                opacity: st.isOccupied ? Bar.workspaceOpacity : Bar.workspaceEmptyOpacity
            }
        }
    }
}
