import QtQuick
import QtQuick.Layouts

import qs.services as Services
import qs.utils
import qs.config
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
        implicitWidth: layout.implicitWidth + General.rectMargin * 2
        implicitHeight: Bar.height - General.rectMargin

        color: Colors.alt
        radius: Style.rounding.large

        RowLayout {
            id: layout
            Item {
                Layout.fillWidth: true
            }
            anchors.fill: parent
            spacing: Bar.resourceIconTextSpacing

            Icon {
                text: Icons.power.shutdown
                font.pixelSize: Style.font.size.large
                color: Colors.red
            }

            // Icon {
            //     text: Icons.power.dpms
            //     font.pixelSize: Style.fontSize.large
            // }
            //
            // Icon {
            //     text: Icons.power.lock
            //     font.pixelSize: Style.fontSize.large
            // }
            //
            // Icon {
            //     text: Icons.power.suspend
            //     font.pixelSize: Style.fontSize.large
            // }
            //
            // Icon {
            //     text: Icons.power.reboot
            //     font.pixelSize: Style.fontSize.large
            // }

            Item {
                Layout.fillWidth: true
            }
        }
    }
}
