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
        anchors {
            fill: parent
            verticalCenter: parent.verticalCenter
            horizontalCenter: parent.horizontalCenter
        }
        implicitWidth: layout.implicitWidth + Config.General.rectMargin * 2
        implicitHeight: Config.Bar.height - Config.General.rectMargin

        color: Config.Colors.alt
        radius: Config.Style.rounding.large

        RowLayout {
            id: layout

            anchors {
                verticalCenter: parent.verticalCenter
                horizontalCenter: parent.horizontalCenter
            }

            spacing: Config.Bar.resourceIconTextSpacing

            Icons {
                text: root.icon
            }
            Text {
                text: root.text
            }

            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
        }
    }
}
