import QtQuick
import Quickshell
import QtQuick.Layouts
import qs.config as Config
import qs.components

Item {
    id: root

    required property string text
    required property string icon

    implicitWidth: container.implicitWidth
    implicitHeight: container.implicitHeight

    Rectangle {
        id: container
        implicitWidth: layout.implicitWidth + Config.General.rectMargin * 2
        implicitHeight: Config.Bar.height - Config.General.rectMargin

        color: Config.Colors.alt
        radius: Config.Style.rounding.large

        RowLayout {
            id: layout
            anchors.centerIn: parent

            spacing: Config.Bar.resourceIconTextSpacing

            Item {
                Layout.fillWidth: true
            }

            Icons {
                text: root.icon
            }
            IText {
                text: root.text
            }

            Item {
                Layout.fillWidth: true
            }
        }
    }
}
