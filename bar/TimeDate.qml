import QtQuick
import QtQuick.Layouts

import qs.services as Services
import qs.components
import qs.config

Item {
    implicitWidth: container.implicitWidth
    implicitHeight: container.implicitHeight - General.rectMargin
    Rectangle {
        id: container
        anchors {
            fill: parent
            verticalCenter: parent.verticalCenter
            horizontalCenter: parent.horizontalCenter
        }

        implicitWidth: layout.implicitWidth + General.rectMargin * 2
        implicitHeight: Bar.height

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
                text: Icons.resource.clock
                font.pixelSize: Style.font.size.larger
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
