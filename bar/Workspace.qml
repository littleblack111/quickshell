import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import Qt5Compat.GraphicalEffects
import qs.config
import qs.components

Item {
    id: root

    implicitWidth: layout.implicitWidth

    property var ws: Hyprland.workspaces
    property int activeIndex: -1
    property bool activeOccupied: false
    property int previousActiveIndex: -1

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

    DropShadow {
        anchors.fill: activeRect
        source: activeRect
        radius: 8
        cached: true
        color: root.activeOccupied ? WallustColors.color4 : WallustColors.foreground
        opacity: root.activeOccupied ? Bar.workspaceActiveOpacity : Bar.workspaceEmptyOpacity / 3

        Behavior on color {
            NumberAnimation {
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
    Rectangle {
        id: activeRect
        x: activeRectX
        anchors.verticalCenter: layout.verticalCenter
        implicitWidth: Bar.workspaceActiveIconSize
        implicitHeight: Bar.workspaceIconSize - Bar.workspaceHorizontalSpacing
        radius: Bar.workspaceRounding
        color: root.activeOccupied ? WallustColors.color4 : WallustColors.foreground
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
                color: st.isOccupied ? WallustColors.color4 : WallustColors.foreground
                opacity: active && st.isOccupied ? Bar.workspaceActiveOpacity : st.isOccupied ? Bar.workspaceOpacity : Bar.workspaceEmptyOpacity

                Icon {
                    anchors.centerIn: parent
                    text: !st.isUrgent ? Icons.ws[index + 1] : Icons.ws['urgent']
                    font.pixelSize: !active ? Bar.workspaceIconSize / 2 : Bar.workspaceActiveIconSize / 2.5
                    opacity: !st.isOccupied ? 0 : 1
                    color: !st.isUrgent ? !st.isActive ? WallustColors.color15 : WallustColors.foreground : Colors.red
                    Behavior on font.pixelSize {
                        ISpringAnimation {}
                    }
                    Behavior on color {
                        ColorAnimation {
                            duration: Bar.workspaceAnimationDuration
                            easing.type: Easing.InOutQuad
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent

                    acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
                    hoverEnabled: true

                    onPressed: {
                        if (!parent.active)
                            Hyprland.dispatch(`workspace ${index + 1}`);
                    }
                    function moveActive() {
                        if (!active) {
                            previousActiveIndex = root.activeIndex;
                            activeRect.x = parent.x;
                            root.activeOccupied = st.isOccupied || false;
                            activeRect.implicitWidth = Bar.workspaceIconSize;
                        }
                    }
                    onEntered: {
                        moveActive();
                    }
                    // https://github.com/quickshell-mirror/quickshell/issues/118
                    // onPositionChanged: {
                    //     moveActive();
                    // }
                    onExited: {
                        if (!active && previousActiveIndex >= 0) {
                            // just in case
                            activeRect.x = layout.x + previousActiveIndex * Bar.workspaceIconSize + previousActiveIndex * Bar.workspaceSpacing;
                            activeRect.implicitWidth = Bar.workspaceActiveIconSize;
                            root.activeOccupied = parent.st.isOccupied || false;
                            root.activeOccupied = getWorkspaceStats(previousActiveIndex).isOccupied || false;
                            previousActiveIndex = -1;
                        }
                    }
                    onWheel: event => {
                        // no idea wats wrong w/ prev so we just unify it to use +/- 1
                        if (event.angleDelta.y < 0) {
                            if (activeIndex + 1 < Bar.workspaces)
                                Hyprland.dispatch(`workspace +1`);
                            else
                                Hyprland.dispatch(`workspace 1`);
                        } else if (event.angleDelta.y > 0) {
                            if (activeIndex + 1 > 1) {
                                Hyprland.dispatch(`workspace -1`);
                            } else if (Bar.workspaces > 1) {
                                Hyprland.dispatch(`workspace ${Bar.workspaces}`);
                            }
                        }
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
                    activeRect.implicitWidth = Bar.workspaceActiveIconSize;
                    activeRect.x = activeRectX;
                    previousActiveIndex = index;
                }
            }
        }
    }
    MouseArea {
        height: Bar.height
        width: parent.width
        acceptedButtons: Qt.MiddleButton

        // sync w the inner MouseArea
        onWheel: event => {
            // no idea wats wrong w/ prev so we just unify it to use +/- 1
            if (event.angleDelta.y < 0) {
                if (activeIndex + 1 < Bar.workspaces)
                    Hyprland.dispatch(`workspace +1`);
                else
                    Hyprland.dispatch(`workspace 1`);
            } else if (event.angleDelta.y > 0) {
                if (activeIndex + 1 > 1) {
                    Hyprland.dispatch(`workspace -1`);
                } else if (Bar.workspaces > 1) {
                    Hyprland.dispatch(`workspace ${Bar.workspaces}`);
                }
            }
        }
    }
}
