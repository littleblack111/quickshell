// TODO: find better ways to do OOP in qml

import Quickshell
import QtQuick

import qs.components
import qs.config

IRect {
    // virtual properties
    required property string name // Component/File name
    required property string input
    property bool valid: processed.valid
    property bool priority: processed.priority
    property var processed: process() // cached process, thought qml would do that automatically :/
    property var process // function() -> {valid: bool, priority: bool} // use the current IRect if valid is set
    // visible: valid // no anim :/
    opacity: valid ? 1 : 0 // TODO: better anim, maybe slide in from bottom

    implicitWidth: valid ? Launcher.widgetWidth : 0
    implicitHeight: valid ? Launcher.widgetHeight : 0
    // implicitWidth: Launcher.widgetWidth
    // implicitHeight: Launcher.widgetHeight

    radius: Launcher.widgetRadius
    color: Qt.rgba(Colors.background3.r, Colors.background3.g, Colors.background3.b, Launcher.widgetBgTransparency) // TODO when prioritized, highlight

    IRect {
        height: childrenRect.height
        width: parent.width
        topLeftRadius: Launcher.widgetRadius
        topRightRadius: Launcher.widgetRadius
        color: Qt.rgba(Colors.background3.r, Colors.background3.g, Colors.background3.b, Launcher.widgetTitleBgTransparency)

        IText {
            anchors {
                top: parent.top
                left: parent.left
                leftMargin: Launcher.innerMargin
            }
            visible: valid
            font.pixelSize: Launcher.widgetFontSize
            text: name
        }
    }
}
