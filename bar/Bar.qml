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
                    anchors {
                        left: parent.left
                    }
                    implicitWidth: leftRow.width + leftRow.spacing - leftSpacer.width
                    implicitHeight: leftRow.height
                    color: Qt.rgba(Colors.background.r, Colors.background.g, Colors.background.b, Bar.bgTransparency)
                    radius: Bar.moduleRadius
                }

                RowLayout {
                    id: leftRow
                    anchors {
                        left: parent.left
                        leftMargin: Bar.moduleLeftMargin
                    }
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
                        id: leftSpacer
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                    }
                }

                Rectangle {
                    id: centerRow
                    anchors.centerIn: parent
                    implicitWidth: activeWindow.implicitWidth + General.rectMargin * 2
                    implicitHeight: activeWindow.implicitHeight

                    color: Colors.alt
                    radius: Style.rounding.smaller
                    ActiveWindow {
                        id: activeWindow
                        anchors.fill: parent
                    }
                }

                Rectangle {
                    anchors {
                        right: parent.right
                        rightMargin: Bar.moduleRightMargin
                    }
                    implicitWidth: power.width + tray.width + timeDate.width + network.width + temp.width + gpu.width + memory.width + cpu.width
                    implicitHeight: leftRow.height
                    color: Qt.rgba(Colors.background.r, Colors.background.g, Colors.background.b, Bar.bgTransparency)
                    radius: Bar.moduleRadius
                }

                RowLayout {
                    id: rightRow
                    anchors.right: parent.right
                    layoutDirection: Qt.RightToLeft
                    implicitWidth: (child.width - centerRow.width) / 2
                    implicitHeight: child.height

                    Power {
                        id: power
                    }
                    Tray {
                        id: tray
                    }
                    TimeDate {
                        id: timeDate
                    }
                    Network {
                        id: network
                    }
                    Temp {
                        id: temp
                    }
                    Gpu {
                        id: gpu
                    }
                    Memory {
                        id: memory
                    }
                    Cpu {
                        id: cpu
                    }

                    Item {}
                }
            }
        }
    }
}
