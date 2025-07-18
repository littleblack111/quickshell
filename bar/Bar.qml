import QtQuick
import Quickshell
import QtQuick.Layouts
import qs.components
import qs.config

Scope {
    id: root
    required property ShellScreen modelData

    IWindow {
        id: barWindow

        modelData: root.modelData
        name: "quickshell:bar"

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
                anchors.left: parent.left
                width: leftRow.width + leftRow.anchors.leftMargin - leftSpacer.width
                height: leftRow.height
                color: Qt.rgba(WallustColors.background.r, WallustColors.background.g, WallustColors.background.b, Bar.bgTransparency)
                radius: Bar.moduleRadius
            }

            RowLayout {
                id: leftRow
                anchors {
                    left: parent.left
                    leftMargin: Bar.moduleLeftMargin
                }
                width: (child.width - centerRow.width) / 2
                height: child.height
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

            Item {
                id: centerRow
                anchors.centerIn: parent

                ActiveWindow {
                    id: activeWindow
                }
            }

            Rectangle {
                anchors.right: parent.right
                width: rightRow.width + rightRow.anchors.rightMargin - rightSpacer.width
                height: rightRow.height
                color: Qt.rgba(WallustColors.background.r, WallustColors.background.g, WallustColors.background.b, Bar.bgTransparency)
                radius: Bar.moduleRadius
            }

            RowLayout {
                id: rightRow
                anchors {
                    right: parent.right
                    rightMargin: Bar.moduleRightMargin
                }
                layoutDirection: Qt.RightToLeft
                width: (child.width - centerRow.width) / 2
                height: child.height
                spacing: Bar.rightModuleSpacing

                Power {
                    id: power
                }
                // Tray {
                //     id: tray
                // }
                TimeDate {}
                Network {}
                // Temp {
                //     id: temp
                // }
                // Gpu {
                //     id: gpu
                // }
                // Memory {
                //     id: memory
                // }
                // Cpu {
                //     id: cpu
                // }
                Resources {}

                Item {
                    id: rightSpacer
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }
            }
        }
    }
}
