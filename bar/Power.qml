import QtQuick
import QtQuick.Layouts

import qs.services as Services
import qs.utils
import qs.config
import qs.components

Item {
    id: root

    implicitWidth: container.implicitWidth
    implicitHeight: container.implicitHeight

    property bool collapsed: true

    Rectangle {
        id: container

        anchors {
            fill: parent
            verticalCenter: parent.verticalCenter
            horizontalCenter: parent.horizontalCenter
        }
        implicitWidth: layout.implicitWidth + General.rectMargin * 2
        implicitHeight: Bar.height - General.rectMargin

        color: WallustColors.color4
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
                implicitWidth: root.collapsed ? 0 : loader.width
                visible: root.collapsed ? false : true
                Loader {
                    id: loader
                    anchors.verticalCenter: parent.verticalCenter
                    active: !root.collapsed
                    sourceComponent: Component {
                        RowLayout {
                            spacing: Bar.resourceIconTextSpacing
                            Icon {
                                text: Icons.power.dpms
                                font.pixelSize: Style.font.size.large
                            }

                            Icon {
                                text: Icons.power.lock
                                font.pixelSize: Style.font.size.large
                            }

                            Icon {
                                text: Icons.power.suspend
                                font.pixelSize: Style.font.size.large
                            }

                            Icon {
                                text: Icons.power.reboot
                                font.pixelSize: Style.font.size.large
                            }
                            SequentialAnimation {
                                running: true
                                NumberAnimation {
                                    target: parent
                                    property: "opacity"
                                    from: 0
                                    to: 1
                                    duration: General.animateDuration / 2
                                    easing.type: Easing.InOutQuad
                                }
                            }
                        }
                    }
                }
                Behavior on implicitWidth {
                    NumberAnimation {
                        duration: General.animateDuration / 4
                        easing.type: Easing.InOutQuad
                    }
                }

                // no idea why when collapsing the width animation won't trigger
                Behavior on visible {
                    NumberAnimation {
                        duration: General.animateDuration / 4
                        easing.type: Easing.InOutQuad
                    }
                }
            }

            Item {
                Layout.fillWidth: true
            }
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: {
                root.collapsed = false;
            }
            onExited: {
                root.collapsed = true;
            }
        }
    }
}
