import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

import qs.services as Services
import qs.components
import qs.config

Item {
    id: root

    implicitWidth: container.implicitWidth
    implicitHeight: container.implicitHeight

    property bool menuOpen: false

    IRect {
        id: container

        anchors {
            fill: parent
            verticalCenter: parent.verticalCenter
            horizontalCenter: parent.horizontalCenter
        }
        implicitWidth: layout.implicitWidth + General.rectMargin * 2
        implicitHeight: Bar.height - General.rectMargin

        color: Colors.accent
        radius: Style.rounding.large

        RowLayout {
            id: layout

            anchors.fill: parent
            spacing: Bar.resourceIconTextSpacing

            Item {
                Layout.fillWidth: true
            }

            Icon {
                id: powerIcon
                text: Icons.power.shutdown
                font.pixelSize: Style.font.size.large
                color: Colors.red
            }

            Item {
                Layout.fillWidth: true
            }
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                root.menuOpen = !root.menuOpen;
            }
        }
    }

    LazyLoader {
        active: root.menuOpen
        component: IWindow {
            id: powerMenu
            name: "quickshell::powermenu"

            layer: WlrLayer.Overlay
            focusable: true

            anchors {
                top: true
                bottom: true
                left: true
                right: true
            }

            IRect {
                anchors.fill: parent
                color: Qt.rgba(Colors.background1.r, Colors.background1.g, Colors.background1.b, 0.9)
                radius: 0 

                MouseArea {
                    anchors.fill: parent
                    onClicked: root.menuOpen = false
                    hoverEnabled: true
                }

                RowLayout {
                    anchors.centerIn: parent
                    spacing: General.rectMargin * 8

                    Icon {
                        text: Icons.power.shutdown
                        font.pixelSize: Style.font.size.large * 8
                        color: shutdownMouse.containsMouse ? Colors.red : Colors.foreground1
                        Behavior on color { ColorAnimation { duration: General.animationDuration / 2 } }

                        MouseArea {
                            id: shutdownMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                // TODO: Services.Power.shutdown()
                                root.menuOpen = false
                            }
                        }
                    }
                    Icon {
                        text: Icons.power.reboot
                        font.pixelSize: Style.font.size.large * 8
                        color: rebootMouse.containsMouse ? Colors.accent : Colors.foreground1
                        Behavior on color { ColorAnimation { duration: General.animationDuration / 2 } }

                        MouseArea {
                            id: rebootMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                // TODO: Services.Power.reboot()
                                root.menuOpen = false
                            }
                        }
                    }
                    Icon {
                        text: Icons.power.suspend
                        font.pixelSize: Style.font.size.large * 8
                        color: suspendMouse.containsMouse ? Colors.accent : Colors.foreground1
                        Behavior on color { ColorAnimation { duration: General.animationDuration / 2 } }

                        MouseArea {
                            id: suspendMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                // TODO: Services.Power.suspend()
                                root.menuOpen = false
                            }
                        }
                    }
                    Icon {
                        text: Icons.power.lock
                        font.pixelSize: Style.font.size.large * 8
                        color: lockMouse.containsMouse ? Colors.accent : Colors.foreground1
                        Behavior on color { ColorAnimation { duration: General.animationDuration / 2 } }

                        MouseArea {
                            id: lockMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                // TODO: Services.Power.lock()
                                root.menuOpen = false
                            }
                        }
                    }
                    Icon {
                        text: Icons.power.dpms
                        font.pixelSize: Style.font.size.large * 8
                        color: dpmsMouse.containsMouse ? Colors.accent : Colors.foreground1
                        Behavior on color { ColorAnimation { duration: General.animationDuration / 2 } }

                        MouseArea {
                            id: dpmsMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                // TODO: Services.Power.dpms()
                                root.menuOpen = false
                            }
                        }
                    }
                }
            }
        }
    }
}
