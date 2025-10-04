pragma Singleton

import Quickshell

Singleton {
    PersistentProperties {
        id: ccProp
        reloadableId: "ccLoaderProp"

        property int x
        property int y
        property bool active: false
    }

    property alias ccProp: ccProp
}
