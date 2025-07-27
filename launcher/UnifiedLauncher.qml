import Quickshell
import QtQuick

import "widgets"
import qs.components
import qs.config

ILauncher {
    property string input: "1+1"
    IRect {
        anchors.fill: parent
        Math {
            anchors.verticalCenter: parent.verticalCenter

            input: input
        }
    }
    implicitWidth: Launcher.width
    implicitHeight: Launcher.height
}
