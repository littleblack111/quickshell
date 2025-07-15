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
                text: Math.round(Services.Resource.cpuUsage * 100) + "%"
                icon: Config.Icons.resource.cpu
            }
            SimpleResource {
                icon: Config.Icons.resource.memory
                text: Math.round(Services.Resource.memoryUsedPercentage * 100) + "%"
            }
            SimpleResource {
                icon: Config.Icons.resource.gpu
                text: Services.Resource.gpuUsage + "%"
            }
            SimpleResource {
                icon: Config.Icons.resource.temp
                text: Math.round(Services.Resource.cpuTemp * 100) + "°C"
            }
        }
    }
}
