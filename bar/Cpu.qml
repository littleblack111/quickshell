import QtQuick
import QtQuick.Layouts

import qs.components
import qs.config
import qs.services as Services

Item {
    implicitWidth: resource.implicitWidth
    implicitHeight: resource.implicitHeight

    SimpleResource {
        id: resource

        text: Math.round(Services.Resource.cpuUsage * 100)
        icon: Icons.resource.cpu
    }
}
