import QtQuick
import Quickshell
import QtQuick.Layouts
import qs.components
import qs.config

Scope {
    id: root

    Variants {
        model: Quickshell.screens

        IWindow {
            id: barWindow
            name: "Bar"

            anchors {
                top: true
                left: true
                right: true
            }
            implicitHeight: child.implicitHeight + Bar.topMargin * 2

            Rectangle {
                id: child
                radius: Bar.borderRadius
                implicitHeight: Bar.height
                implicitWidth: parent.width

                anchors {
                    left: parent.left
                    right: parent.mid
                    fill: parent
                    top: parent.top
                    topMargin: Bar.topMargin
                    leftMargin: Bar.leftMargin
                    rightMargin: Bar.rightMargin
                }

                color: "transparent"

                Rectangle {
                    id: barBackground
                    anchors {
                        left: parent.left
                    }
                    implicitWidth: workspace.width + leftRow.anchors.leftMargin + leftRow.anchors.rightMargin + leftRow.spacing + mpris.width
                    implicitHeight: leftRow.height
                    color: Qt.rgba(Colors.r, Colors.g, Colors.b, Bar.bgTransparency)
                    radius: Bar.moduleRadius
                }

                RowLayout {
                    id: leftRow
                    anchors.left: parent.left
                    anchors.leftMargin: Bar.moduleLeftMargin
                    anchors.rightMargin: Bar.moduleRightMargin // does nothing but more consistent code style (as leftRow's right is middle but leftRow will never reach middle)
                    implicitWidth: (child.width - centerRow.width) / 2
                    implicitHeight: child.height
                    spacing: Bar.leftModuleSpacing

                    Workspace {
                        id: workspace
                        // screen: barWindow.screen // multi monitor
                        // Layout.minimumWidth: 400 // FIXME
                    }
                    Mpris {
                        id: mpris
                    }
                    Item {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.preferredWidth: 1
                    }
                }

                Item {
                    id: centerRow
                    anchors.centerIn: parent
                    ActiveWindow {
                        anchors.fill: parent
                    }
                }

                RowLayout {
                    id: rightRow
                    anchors.right: parent.right
                    layoutDirection: Qt.RightToLeft
                    implicitWidth: (child.width - centerRow.width) / 2
                    implicitHeight: child.height

                    Power {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                    }
                    TimeDate {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                    }
                    Network {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                    }
                    Temp {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                    }
                    Gpu {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                    }
                    Memory {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                    }
                    Cpu {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                    }

                    Item {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                    }
                }
            }
        }
    }
}
