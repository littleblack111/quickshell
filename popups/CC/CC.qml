import ".."
import "../.."
import qs.components
import qs.config
import Quickshell
import QtQuick
import Quickshell.Hyprland

IPopup {
    id: root
    anchors.top: true
    anchors.left: true

    name: "quickshell::CC"
    implicitWidth: Global.ccProp.x
    implicitHeight: Global.ccProp.y + CC.height * 2 + Bar.topMargin * 2

    aboveWindows: true
    exclusionMode: ExclusionMode.Ignore

    mask: Region {
        item: rect
    }

    IRect {
        id: rect

        x: Global.ccProp.x - CC.width
        y: Bar.height + Bar.topMargin * 2
        width: CC.width
        height: CC.height

        color: Qt.rgba(Colors.background1.r, Colors.background1.g, Colors.background1.b, CC.bgTransparency)
        radius: CC.borderRadius

        anchors.margins: 560

        IRect {
            id: container
            color: "transparent"
            anchors {
                fill: parent
                margins: CC.innerMargin
            }

            IText {
                text: "hiasdfkjhadslkfasdjkflhj"
            }
        }
    }

    HyprlandFocusGrab {
        active: true
        windows: [root]
        onCleared: {
            parentLoader.active = false; // or active = true again
        }
    }
}
