import QtQuick
import QtQuick.Layouts

import qs.services as Services
import qs.components
import qs.config as Config

Item {
    implicitWidth: resource.implicitWidth
    implicitHeight: resource.implicitHeight

    SimpleResource {
        id: resource
        icon: Config.Icons.resource.gpu
        text: Services.Resource.gpuUsage
    }
}
