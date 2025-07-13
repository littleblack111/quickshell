import QtQuick
import QtQuick.Layouts

import qs.services as Services
import qs.components
import qs.config as Config

Item {
    implicitWidth: container.implicitWidth
    implicitHeight: container.implicitHeight - Config.General.rectMargin
    Rectangle {
        id: container
        anchors {
            fill: parent
            verticalCenter: parent.verticalCenter
            horizontalCenter: parent.horizontalCenter
        }

        implicitWidth: layout.implicitWidth + Config.General.rectMargin * 2
        implicitHeight: Config.Bar.height

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
                text: Config.Icons.resource.clock
                font.pixelSize: Config.Style.font.size.larger
            }
            IText {
                text: Services.TimeDate.time
            }
            Item {
                Layout.fillWidth: true
            }
        }
    }
}
