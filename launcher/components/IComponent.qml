// TODO: find better ways to do OOP in qml

import Quickshell
import QtQuick

import qs.components
import qs.config

IRect {
    // virtual properties
    required property string name // Component/File name
    required property string input
    property bool valid: processed?.valid || false
    property bool priority: processed?.priority || false
    property string answer: processed?.answer || ""
    property Component preview: Component {
        IText {
            animate: true
            text: answer
        }
    }
    property var processed: process() // cached process, thought qml would do that automatically :/
    property var process: () => ({
                valid: valid,
                priority: priority,
                answer: answer,
                preview: preview
            })// use the current IRect if valid is set
    // actions
    property var up: () => ({
                top: false
            })
    property var down: () => ({
                bottom: false
            })
    property var prev: () => {}
    property var next: () => {}
    property var exec: () => {}

    // visible: valid // no anim :/
    opacity: valid ? 1 : 0 // TODO: better anim, maybe slide in from bottom

    implicitWidth: valid ? Launcher.widgetWidth : 0
    implicitHeight: valid ? Launcher.widgetHeight : 0
    // implicitWidth: Launcher.widgetWidth
    // implicitHeight: Launcher.widgetHeight

    radius: Launcher.widgetRadius
    color: Qt.rgba(Colors.background3.r, Colors.background3.g, Colors.background3.b, Launcher.widgetBgTransparency) // TODO when prioritized, highlight
}
