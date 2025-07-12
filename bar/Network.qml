import QtQuick
import QtQuick.Layouts

import qs.services as Services
import qs.utils
import qs.config as Config

Item {
    id: root

    RowLayout {
        Item {
            Layout.fillWidth: true
        }
        anchors.fill: parent
        spacing: Config.Bar.resourceIconTextSpacing

        Icons {
            text: Services.Network.state
        }
        Text {
            text: Math.round(Services.Resource.cpuUsage * 100)
        }
        Text {
            text: NetworkUsage.up + " " + NetworkUsage.upUnit
        }
        Text {
            text: NetworkUsage.down + " " + NetworkUsage.downUnit
        }
        Item {
            Layout.fillWidth: true
        }
    }
}
