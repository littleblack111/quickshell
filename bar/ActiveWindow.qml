import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import qs.utils

Item {
    id: root
    property var toplevel: ToplevelManager.activeToplevel
    property var icon: Quickshell.iconPath(AppSearch.guessIcon(toplevel?.appId), "image-missing")

    IconImage {
        source: root.icon
        implicitWidth: 32
        implicitHeight: 32
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 8
    }
    Text {
        text: root.toplevel?.title
    }
}
