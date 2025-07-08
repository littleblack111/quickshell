import "../utils"
import "../config"
import QtQuick
import Quickshell
import QtQuick.Layouts

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
                    anchors {
                        fill: parent
                        left: parent.left
                    }
					Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                    id: row

                    Workspace {
                        id: workspace
                    }
                    // Workspace {
                    //
                    //     id: workspace2
                    // }
                    // Workspace {
                    //
                    //     id: workspace3
                    // }
                }

            }
        }
    }
}
