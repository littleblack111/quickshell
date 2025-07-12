import QtQuick
import QtQuick.Layouts

import qs.services as Services
import qs.components
import qs.config as Config

Item {
    SimpleResource {
        icon: Config.Icons.resource.gpu
        text: Services.Resource.gpuUsage
    }
}
