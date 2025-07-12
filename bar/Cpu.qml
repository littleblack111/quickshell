import QtQuick
import QtQuick.Layouts

import qs.components
import qs.config
import qs.services as Services

Item {
    id: root
    SimpleResource {
        text: Math.round(Services.Resource.cpuUsage * 100)
        icon: Icons.resource.cpu
    }
}
