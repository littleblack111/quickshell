import QtQuick
import QtQuick.Layouts

import qs.services as Services
import qs.components
import qs.config

Item {
    id: root
    property int down: Services.NetworkUsage.down
    property string downUnit: Services.NetworkUsage.downUnit
    property int up: Services.NetworkUsage.up
    property string upUnit: Services.NetworkUsage.upUnit

    property int significantUsage: 30
    property string usageUnit: "M"

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
        color: WallustColors.color4
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
                Icon {
                    text: Icons.resource.network.download
                    color: root.downUnit == root.usageUnit && root.down > root.significantUsage ? Colors.cyan : WallustColors.color15
                }
                IText {
                    animate: true
                    text: root.down + root.downUnit
                    color: root.downUnit == root.usageUnit && root.down > root.significantUsage ? Colors.cyan : WallustColors.color15
                }
            }
            RowLayout {
                spacing: Bar.resourceIconTextSpacing / 2
                Icon {
                    text: Icons.resource.network.upload
                    color: root.upUnit == root.usageUnit && root.up > root.significantUsage ? Colors.cyan : WallustColors.color15
                }
                IText {
                    animate: true
                    text: root.up + root.upUnit
                    color: root.upUnit == root.usageUnit && root.up > root.significantUsage ? Colors.cyan : WallustColors.color15
                }
            }

            Item {
                Layout.fillWidth: true
            }
        }
    }
}
