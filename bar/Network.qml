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
            anchors {
                verticalCenter: parent.verticalCenter
                horizontalCenter: parent.horizontalCenter
            }
            spacing: Bar.resourceIconTextSpacing

            Item {
                Layout.fillWidth: true
            }

            Icon {
                text: Services.Network.state
            }

            RowLayout {
                spacing: Bar.resourceIconTextSpacing / 2
                IText {
                    text: Icons.resource.network.download
                }
                IText {
                    animate: true
                    text: Services.NetworkUsage.down + Services.NetworkUsage.downUnit
                }
            }
            RowLayout {
                spacing: Bar.resourceIconTextSpacing / 2
                IText {
                    text: Icons.resource.network.upload
                }
                IText {
                    animate: true
                    text: Services.NetworkUsage.up + Services.NetworkUsage.upUnit
                }
            }

            Item {
                Layout.fillWidth: true
            }
        }
    }
}
