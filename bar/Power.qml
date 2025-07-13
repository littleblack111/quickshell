import QtQuick
import QtQuick.Layouts

import qs.services as Services
import qs.utils
import qs.config as Config
import qs.components

Item {
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
            Item {
                Layout.fillWidth: true
            }
            anchors.fill: parent
            spacing: Config.Bar.resourceIconTextSpacing

            Icons {
                text: Config.Icons.power.shutdown
                font.pixelSize: Config.Style.font.size.large
                color: Qt.rgba(191, 97, 106, 1)
            }

            // Icons {
            //     text: Config.Icons.power.dpms
            //     font.pixelSize: Config.Style.fontSize.large
            // }
            //
            // Icons {
            //     text: Config.Icons.power.lock
            //     font.pixelSize: Config.Style.fontSize.large
            // }
            //
            // Icons {
            //     text: Config.Icons.power.suspend
            //     font.pixelSize: Config.Style.fontSize.large
            // }
            //
            // Icons {
            //     text: Config.Icons.power.reboot
            //     font.pixelSize: Config.Style.fontSize.large
            // }

            Item {
                Layout.fillWidth: true
            }
        }
    }
}
