import Quickshell
import QtQuick

import qs.components
import qs.config

IRect {
    id: root
    // virtual properties
    property string name // Component/File name
    readonly property string _input: SelectionState.input
    readonly property string input: _input.slice(prefix.length)
    readonly property string inputCleaned: input.toLowerCase().trim()
    property string prefix
    property bool active: input && _input.startsWith(prefix)
    property bool valid: processed?.valid || false
    property bool priority: valid && processed?.priority || false // please set priority to false if it's invalid
    property string answer: processed?.answer || ""
    property Component preview: Component {
        IText {
            animate: true
            text: answer
        }
    }
    property string predictiveCompletion: processed?.predictiveCompletion || "" // would technically work with just from answer, but stuff like calc's answer wouldnt have anything to do with the input
    property var processed: active ? process() : {} // cached process, thought qml would do that automatically :/
    property var process: () => ({
                valid: valid,
                priority: priority,
                answer: answer,
                preview: preview,
                predictiveCompletion: predictiveCompletion
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
    property var home: () => {}
    property var end: () => {}
    property var pgup: () => {}
    property var pgdn: () => {}

    signal close

    function _exec() {
        exec();
        close();
    }

    opacity: valid ? 1 : 0
    y: valid ? 0 : -Launcher.widgetHeight

    implicitWidth: valid ? Launcher.widgetWidth : 0
    implicitHeight: valid ? Launcher.widgetHeight : 0

    // implicitWidth: Launcher.widgetWidth
    // implicitHeight: Launcher.widgetHeight

    radius: Launcher.widgetRadius
    color: Qt.rgba(Colors.background3.r, Colors.background3.g, Colors.background3.b, Launcher.widgetBgTransparency) // TODO when prioritized, highlight

    onPriorityChanged: {
        SelectionState.priorities = [...[...SelectionState.priorities, root].reduce((s, x) => (s[(s.has(x) && 'delete') || 'add'](x), s), new Set())]; // sync with SelectionState.priorities
    }

    Behavior on y {
        NumberAnimation {
            duration: General.animationDuration / 4
            easing.type: Easing.InOutQuad
        }
    }
}
