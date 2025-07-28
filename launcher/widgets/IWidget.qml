// TODO: find better ways to do OOP in qml

import Quickshell

import qs.components
import qs.config

IRect {
    required property string name // Component/File name
    required property string input
    required property bool valid
    required property bool priority
    required property var process // function() -> {valid: bool, priority: bool} // use the current IRect if valid is set

    anchors.verticalCenter: parent.verticalCenter

    implicitWidth: Launcher.widgetWidth
    implicitHeight: Launcher.widgetHeight

    radius: Launcher.widgetRadius
    color: Qt.rgba(Colors.background3.r, Colors.background3.g, Colors.background3.b, Launcher.bgTransparency)

    IText {
        visible: valid
        text: name
        anchors.left: parent.left
    }
}
