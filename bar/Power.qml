import QtQuick
import QtQuick.Layouts

import qs.services as Services
import qs.utils
import qs.config as Config
import qs.components

Item {
    id: root
    RowLayout {
        Item {
            Layout.fillWidth: true
        }
        anchors.fill: parent
        spacing: Config.Bar.resourceIconTextSpacing

        Icons {
            text: Config.Icons.power.shutdown
        }

        Icons {
            text: Config.Icons.power.dpms
        }

        Icons {
            text: Config.Icons.power.lock
        }

        Icons {
            text: Config.Icons.power.suspend
        }

        Icons {
            text: Config.Icons.power.reboot
        }

        Item {
            Layout.fillWidth: true
        }
    }
}
