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
            name: "quickshell::bar"

            anchors {
                top: true
                left: true
                right: true
            }
            implicitHeight: child.implicitHeight + Bar.topMargin * 2

            IRect {
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

                IRect {
                    id: leftRow
                    anchors {
                        left: parent.left
                    }
                    width: leftInnerRow.width + leftInnerRow.anchors.leftMargin - leftSpacer.width
                    height: leftInnerRow.height
                    color: Qt.rgba(Colors.background3.r, Colors.background3.g, Colors.background3.b, Bar.bgTransparency)
                    radius: Bar.moduleRadius

                    Behavior on color {
                        NumberAnimation {
                            duration: General.animationDuration
                            easing.type: Easing.InOutQuad
                        }
                    }
                    RowLayout {
                        id: leftInnerRow
                        height: child.height
                        spacing: Bar.leftModuleSpacing
                        anchors {
                            left: parent.left
                            leftMargin: Bar.moduleLeftMargin
                        }

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
                }

                Item {
                    id: centerRow
                    anchors.centerIn: parent

                    ActiveWindow {
                        id: activeWindow
                    }
                }

                IRect {
                    id: rightRow
                    anchors.right: parent.right
                    width: rightInnerRow.width + rightInnerRow.anchors.rightMargin - rightSpacer.width
                    height: rightInnerRow.height
                    color: Qt.rgba(Colors.background3.r, Colors.background3.g, Colors.background3.b, Bar.bgTransparency)
                    radius: Bar.moduleRadius

                    RowLayout {
                        id: rightInnerRow
                        anchors {
                            right: parent.right
                            rightMargin: Bar.moduleRightMargin
                        }
                        layoutDirection: Qt.RightToLeft
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

                    Behavior on color {
                        ColorAnimation {
                            duration: General.animationDuration
                            easing.type: Easing.InOutQuad
                        }
                    }
                }
            }
        }
    }
}
