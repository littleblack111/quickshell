import QtQuick
import Quickshell
import QtQuick.Layouts
import qs.utils
import qs.config

Scope {
    id: root

    Variants {
        model: Quickshell.screens

        IWindow {
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

                RowLayout {
                    id: leftRow
                    implicitWidth: (child.width - centerRow.width) / 2
                    implicitHeight: child.height

                    Workspace {
                        id: workspace
                        Layout.preferredWidth: 5
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        Layout.maximumWidth: 400 // FIXME
                    }
                    Mpris {
                        id: mpris
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.preferredWidth: 1
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

                    Cpu {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                    }
                    Memory {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                    }
                    Gpu {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                    }
                    Temp {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                    }
                    Network {
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
