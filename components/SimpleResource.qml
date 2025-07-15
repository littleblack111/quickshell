import QtQuick
import Quickshell
import QtQuick.Layouts
import qs.config
import qs.components

Item {
    id: root

    required property string text
    required property string icon

    implicitWidth: layout.implicitWidth
    implicitHeight: layout.implicitHeight

    RowLayout {
        id: layout

        spacing: Bar.resourceIconTextSpacing

        Item {
            Layout.fillWidth: true
        }

        Icon {
            text: root.icon
        }
        IText {
            animate: true
            text: root.text
        }

        Item {
            Layout.fillWidth: true
        }
    }
}
