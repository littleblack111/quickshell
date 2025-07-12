import QtQuick
import QtQuick.Layouts

import qs.services as Services
import qs.components
import qs.config as Config

Item {
    id: root
    SimpleResource {
        icon: Config.Icons.resource.temp
        text: Math.round(Services.Resource.cpuTemp * 100)
    }
}
