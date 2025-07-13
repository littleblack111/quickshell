import QtQuick
import QtQuick.Layouts

// TODO: sort all header
import qs.services as Services
import qs.components
import qs.config as Config

Item {
    implicitWidth: resource.implicitWidth
    implicitHeight: resource.implicitHeight

    SimpleResource {
        id: resource

        icon: Config.Icons.resource.memory
        text: Math.round(Services.Resource.memoryUsedPercentage * 100) + "%"
    }
}
