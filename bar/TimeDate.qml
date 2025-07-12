import QtQuick
import QtQuick.Layouts

import qs.services as Services
import qs.components
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
            text: Config.Icons.resource.clock
        }
        Text {
            text: Services.TimeDate.time
        }
        Item {
            Layout.fillWidth: true
        }
    }
}
