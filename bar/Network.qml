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
            anchors {
                verticalCenter: parent.verticalCenter
                horizontalCenter: parent.horizontalCenter
            }
            spacing: Config.Bar.resourceIconTextSpacing

            Item {
                Layout.fillWidth: true
            }

            Icons {
                text: Services.Network.state
            }

            RowLayout {
                spacing: Config.Bar.resourceIconTextSpacing / 2
                Text {
                    text: Config.Icons.resource.network.download
                }
                Text {
                    text: Services.NetworkUsage.down + Services.NetworkUsage.downUnit
                }
            }
            RowLayout {
                spacing: Config.Bar.resourceIconTextSpacing / 2
                Text {
                    text: Config.Icons.resource.network.upload
                }
                Text {
                    text: Services.NetworkUsage.up + Services.NetworkUsage.upUnit
                }
            }

            Item {
                Layout.fillWidth: true
            }
        }
    }
}
