// TODO: find better ways to do OOP in qml

import Quickshell

import qs.components
import qs.config

IRect {
    required property string name
    required property var process // function(data: string) -> {visible: bool, priority: bool} // use the current IRect if visible is set
    // we should maintain a internal priority configrable by user if multiple are prioritized

    implicitWidth: Launcher.widgetWidth
    implicitHeight: Launcher.widgetHeight

    radius: Launcher.borderRadius

    IText {
        text: name
        anchors.left: parent.left
    }
}
