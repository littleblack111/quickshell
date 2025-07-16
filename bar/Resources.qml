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
                value: Math.round(Services.Resource.cpuUsage * 100)
                altValue: Math.round(Services.Resource.cpuFreq / 10) / 100
                suffix: "%"
                altSuffix: "GHz"
                icon: Config.Icons.resource.cpu
            }
            SimpleResource {
                icon: Config.Icons.resource.memory
                value: Math.round(Services.Resource.memoryUsedPercentage * 100)
                altValue: Math.round(Services.Resource.memoryUsed / 1024 / 1024)
                suffix: "%"
                altSuffix: "GB"
            }
            SimpleResource {
                icon: Config.Icons.resource.gpu
                value: Services.Resource.gpuUsage
                altValue: Services.Resource.gpuTemp
                suffix: "%"
                altSuffix: "°C"
                altIcon: Config.Icons.resource.temp
                thresholdL1: 60
                thresholdL2: 70
                thresholdL3: 80
            }
            SimpleResource {
                icon: Config.Icons.resource.temp
                value: Math.round(Services.Resource.cpuTemp * 100)
                suffix: "°C"
                thresholdL1: 60
                thresholdL2: 80
                thresholdL3: 90
            }
        }
    }
}
