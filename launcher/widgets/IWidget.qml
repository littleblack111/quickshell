// TODO: find better ways to do OOP in qml

import Quickshell

import qs.components
import qs.config

IRect {
    required property string name // Component/File name
    required property string input
    input: input
    required property var process // function() -> {visible: bool, priority: bool} // use the current IRect if visible is set

    implicitWidth: Launcher.widgetWidth
    implicitHeight: Launcher.widgetHeight

    radius: Launcher.borderRadius
    color: Qt.rgba(Colors.background3.r, Colors.background3.g, Colors.background3.b, Launcher.bgTransparency)

    IText {
        text: name
        anchors.left: parent.left
    }
}
