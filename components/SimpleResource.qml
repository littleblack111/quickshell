import QtQuick
import Quickshell
import QtQuick.Layouts
import qs.config
import qs.components

Item {
    id: root

    required property string text
    required property string icon

    implicitWidth: container.implicitWidth
    implicitHeight: container.implicitHeight

    Rectangle {
        id: container
        implicitWidth: layout.implicitWidth + General.rectMargin * 2
        implicitHeight: Bar.height - General.rectMargin

        color: Colors.alt
        radius: Style.rounding.large

        RowLayout {
            id: layout
            anchors.centerIn: parent

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
}
