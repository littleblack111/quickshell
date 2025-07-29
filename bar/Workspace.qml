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
    property var toplevels: Hyprland.toplevels.values // update activeOccupied when toplevels changes as getWorkspaceStat's return is non reactive

    property int activeIndex: -1
    property bool activeOccupied: false
    property bool toChild: false

    property real activeRectX: {
        if (activeIndex < 0)
            return 0;
        return layout.x + activeIndex * Bar.wsIconSize + activeIndex * Bar.wsSpacing;
    }

    function getWorkspaceStats(index) {
        const w = ws.values.find(i => i.id === index + 1);
        return {
            isOccupied: w?.toplevels?.values?.length,
            isActive: w?.active,
            isUrgent: w?.urgent
        };
    }

    onToplevelsChanged: {
        Qt.callLater(() => {
            activeOccupied = getWorkspaceStats(activeIndex).isOccupied || false;
        });
    }

    DropShadow {
        anchors.fill: activeRect
        source: activeRect
        radius: 8
        cached: true
        color: root.activeOccupied ? Colors.accent : Colors.foreground1
        opacity: root.activeOccupied ? Bar.wsActiveOpacity : Bar.wsEmptyOpacity / 3

        Behavior on color {
            NumberAnimation {
                duration: Bar.wsAnimationDuration
                easing.type: Easing.InOutQuad
            }
        }
        Behavior on opacity {
            NumberAnimation {
                duration: Bar.wsAnimationDuration
                easing.type: Easing.InOutQuad
            }
        }
    }
    IRect {
        id: activeRect
        x: activeRectX
        anchors.verticalCenter: layout.verticalCenter
        implicitWidth: Bar.wsActiveIconSize
        implicitHeight: Bar.wsIconSize - Bar.wsHorizontalSpacing
        radius: Bar.wsRounding
        color: root.activeOccupied ? Colors.accent : Colors.foreground1
        opacity: root.activeOccupied ? Bar.wsActiveOpacity : Bar.wsEmptyOpacity / 3
        Behavior on x {
            ISpringAnimation {}
        }
        Behavior on color {
            ColorAnimation {
                duration: Bar.wsAnimationDuration
                easing.type: Easing.InOutQuad
            }
        }
        Behavior on opacity {
            NumberAnimation {
                duration: Bar.wsAnimationDuration
                easing.type: Easing.InOutQuad
            }
        }
        Behavior on implicitWidth {
            NumberAnimation {
                duration: Bar.wsAnimationDuration
                easing.type: Easing.InOutQuad
            }
        }
    }

    RowLayout {
        id: layout
        anchors.verticalCenter: parent.verticalCenter
        implicitWidth: repeater.width
        spacing: Bar.wsSpacing

        Repeater {
            id: repeater
            model: Bar.wss

            IRect {
                property var st: getWorkspaceStats(index)
                property bool active: st?.isActive || false

                implicitWidth: active ? Bar.wsActiveIconSize : Bar.wsIconSize
                implicitHeight: Bar.wsIconSize - Bar.wsHorizontalSpacing
                radius: Bar.wsRounding
                color: st.isOccupied ? Colors.accent : Colors.foreground1
                opacity: active && st.isOccupied ? Bar.wsActiveOpacity : st.isOccupied ? Bar.wsOpacity : Bar.wsEmptyOpacity

                Icon {
                    anchors.centerIn: parent
                    text: !st.isUrgent ? Icons.ws[index + 1] : Icons.ws['urgent']
                    font.pixelSize: !active ? Bar.wsIconSize / 2 : Bar.wsActiveIconSize / 2.5
                    opacity: !st.isOccupied ? 0 : 1
                    color: !st.isUrgent ? !st.isActive ? Colors.foreground2 : Colors.foreground1 : Colors.red
                    Behavior on font.pixelSize {
                        ISpringAnimation {}
                    }
                    Behavior on color {
                        ColorAnimation {
                            duration: Bar.wsAnimationDuration
                            easing.type: Easing.InOutQuad
                        }
                    }
                }

                MouseArea {
                    anchors {
                        fill: parent
                        topMargin: Bar.wsExtraMouseArea * -1
                        bottomMargin: Bar.wsExtraMouseArea * -1
                    }

                    acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
                    hoverEnabled: true

                    onPressed: {
                        if (!parent.active)
                            Hyprland.dispatch(`workspace ${index + 1}`);
                    }
                    function moveActive() {
                        activeRect.x = parent.x;
                        root.activeOccupied = st.isOccupied || false;
                        activeRect.implicitWidth = active ? Bar.wsActiveIconSize : Bar.wsIconSize;
                    }
                    onEntered: {
                        root.toChild = true;
                        moveActive();
                    }
                    // https://github.com/quickshell-mirror/quickshell/issues/118
                    // onPositionChanged: {
                    //     moveActive();
                    // }
                    onExited: {
                        root.toChild = false;
                        // outer MouseArea will handle this
                        // if (!active && previousActiveIndex >= 0) {
                        //     // just in case
                        //     activeRect.x = layout.x + previousActiveIndex * Bar.wsIconSize + previousActiveIndex * Bar.wsSpacing;
                        //     activeRect.implicitWidth = Bar.wsActiveIconSize;
                        //     // root.activeOccupied = parent.st.isOccupied || false;
                        //     root.activeOccupied = getWorkspaceStats(previousActiveIndex).isOccupied || false;
                        //     previousActiveIndex = -1;
                        // }
                    }
                    onWheel: event => {
                        // no idea wats wrong w/ prev so we just unify it to use +/- 1
                        if (event.angleDelta.y < 0) {
                            if (activeIndex + 1 < Bar.wss)
                                Hyprland.dispatch(`workspace +1`);
                            else
                                Hyprland.dispatch(`workspace 1`);
                        } else if (event.angleDelta.y > 0) {
                            if (activeIndex + 1 > 1) {
                                Hyprland.dispatch(`workspace -1`);
                            } else if (Bar.wss > 1) {
                                Hyprland.dispatch(`workspace ${Bar.wss}`);
                            }
                        }
                    }
                }

                Behavior on opacity {
                    NumberAnimation {
                        duration: Bar.wsAnimationDuration
                        easing.type: Easing.InOutQuad
                    }
                }
                Behavior on implicitWidth {
                    NumberAnimation {
                        duration: Bar.wsAnimationDuration
                        easing.type: Easing.InOutQuad
                    }
                }
                Behavior on color {
                    ColorAnimation {
                        duration: Bar.wsAnimationDuration
                        easing.type: Easing.InOutQuad
                    }
                }

                onActiveChanged: if (active) {
                    root.activeIndex = index;
                    root.activeOccupied = st.isOccupied;
                    activeRect.implicitWidth = Bar.wsActiveIconSize;
                    activeRect.x = activeRectX;
                }
            }
        }
    }
    MouseArea {
        height: Bar.height
        width: parent.width
        hoverEnabled: true
        z: -1000 // to be below the child's MouseArea
        acceptedButtons: Qt.MiddleButton

        // sync w the inner MouseArea
        // https://github.com/quickshell-mirror/quickshell/issues/118 // but onEnter won't update the mouseX
        onPositionChanged: {
            const abovedItemIndex = Math.round((mouseX - layout.x) / (Bar.wsIconSize + Bar.wsSpacing)) - 1; // TODO: workspaceActiveIconSize might be before
            activeRect.x = mouseX - activeRect.width / 2;
            root.activeOccupied = getWorkspaceStats(abovedItemIndex).isOccupied || false;
            activeRect.implicitWidth = root.activeIndex === abovedItemIndex ? Bar.wsActiveIconSize : Bar.wsIconSize;
        }
        onExited: {
            if (!root.toChild && root.activeIndex >= 0) {
                // just in case
                activeRect.x = layout.x + root.activeIndex * Bar.wsIconSize + root.activeIndex * Bar.wsSpacing;
                activeRect.implicitWidth = Bar.wsActiveIconSize;
                root.activeOccupied = getWorkspaceStats(root.activeIndex).isOccupied || false;
            }
        }
        onWheel: event => {
            // no idea wats wrong w/ prev so we just unify it to use +/- 1
            if (event.angleDelta.y < 0) {
                if (activeIndex + 1 < Bar.wss)
                    Hyprland.dispatch(`workspace +1`);
                else
                    Hyprland.dispatch(`workspace 1`);
            } else if (event.angleDelta.y > 0) {
                if (activeIndex + 1 > 1) {
                    Hyprland.dispatch(`workspace -1`);
                } else if (Bar.wss > 1) {
                    Hyprland.dispatch(`workspace ${Bar.wss}`);
                }
            }
        }
    }
}
