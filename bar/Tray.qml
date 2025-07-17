import QtQuick.Layouts
import QtQuick
import Quickshell.Services.SystemTray
import Quickshell

import qs.components
import qs.config

IWindow {
    id: root
    // required property var parentWindow

    property int x: parentWindow.item.mapToGlobal(Qt.point(0, 0)).x

    name: "quickshell:tray"
    aboveWindows: true
    anchors {
        top: true
        left: true
        // bottom: true
    }

    // implicitWidth: screen.width + root.x + parentWindow.width
    implicitWidth: 1000
    implicitHeight: MediaController.height
    color: "blue"

    mask: Region {
        item: layout
    }

    focusable: true
    RowLayout {
        id: layout
        // layoutDirection: Qt.RightToLeft
        // anchors.fill: parent
        // x: root.screen.width - 100
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        spacing: 100
        // anchors.right: parent.right

        Text {
            text: root.screen.width
        }
        Text {
            text: root.x
        }
        Text {
            text: parentWindow.width
        }
    }
}
