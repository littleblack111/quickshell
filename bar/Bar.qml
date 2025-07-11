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
                    id: rowLayout
                    anchors.fill: parent

                    RowLayout {
                        id: leftRow
                        Layout.preferredWidth: 1
                        Layout.fillWidth: true
                        // Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter

                        Workspace {
                            id: workspace
                            Layout.preferredWidth: 3
                            Layout.fillWidth: true
                        }
                        Mpris {
                            id: mpris
                            Layout.fillWidth: true
                            Layout.preferredWidth: 1
                        }
                    }
                    RowLayout {
                        id: centerRow
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.preferredWidth: 1
                        Rectangle {
                            Layout.fillWidth: true
                            implicitHeight: 1
                            color: "#000000"
                        }
                    }
                    RowLayout {
                        id: rightRow
                        Layout.fillWidth: true
                        Layout.preferredWidth: 1
                        Rectangle {
                            Layout.fillWidth: true
                            Text {
                                text: "a"
                            }
                        }
                    }
                }
            }
        }
    }
}
