import QtQuick
import Quickshell
import QtQuick.Layouts
import qs.config as Config
import qs.components

RowLayout {
    id: root
    required property string text
    required property string icon
    Item {
        Layout.fillWidth: true
    }
    anchors.fill: parent
    spacing: Config.Bar.resourceIconTextSpacing

    Icons {
        text: root.icon
    }
    Text {
        text: root.text
    }
    Item {
        Layout.fillWidth: true
    }
}
