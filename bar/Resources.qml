import QtQuick
import QtQuick.Layouts

import qs.components
import qs.config as Config
import qs.services as Services

Item {
    implicitWidth: container.implicitWidth
    implicitHeight: container.implicitHeight

    Rectangle {
        id: container
        implicitWidth: layout.implicitWidth + Config.General.rectMargin * 2
        implicitHeight: Config.Bar.height - Config.General.rectMargin

        color: Config.WallustColors.color4
        radius: Config.Style.rounding.large

        RowLayout {
            id: layout
            anchors.centerIn: parent
            SimpleResource {
                value: Services.Resource.cpuUsage
                suffix: "%"
                icon: Config.Icons.resource.cpu
            }
            SimpleResource {
                icon: Config.Icons.resource.memory
                value: Services.Resource.memoryUsedPercentage
                suffix: "%"
            }
            SimpleResource {
                icon: Config.Icons.resource.gpu
                value: Services.Resource.gpuUsage / 100
                suffix: "%"
                thresholdL1: 0.60
                thresholdL2: 0.70
                thresholdL3: 0.80
            }
            SimpleResource {
                icon: Config.Icons.resource.temp
                value: Services.Resource.cpuTemp
                suffix: "°C"
                thresholdL1: 0.60
                thresholdL2: 0.80
                thresholdL3: 0.90
            }
        }
    }
}
