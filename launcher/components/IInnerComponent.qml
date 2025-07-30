import QtQuick
import QtQuick.Layouts

import qs.components
import qs.config

ColumnLayout {
    property bool fromParent: true
    anchors.fill: fromParent ? parent : undefined
    spacing: 0
    IRect {
        Layout.fillWidth: true
        Layout.fillHeight: false
        visible: Launcher.showWidgetTitle && valid
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
