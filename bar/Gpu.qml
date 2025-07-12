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
            text: Config.Icons.resource.gpu
        }
        Text {
            text: Services.Resource.gpuUsage
        }
        Item {
            Layout.fillWidth: true
        }
    }
}
