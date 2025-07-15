import QtQuick
import Quickshell
import QtQuick.Layouts
import qs.config
import qs.components

Item {
    id: root

    required property real value
    required property string suffix // unit
    required property string icon
    property string text: Math.round(root.value * 100) + root.suffix
    property real thresholdL1: 40 / 100
    property real thresholdL2: thresholdL1 * 1.5
    property real thresholdL3: thresholdL2 * 1.5
    property color thresholdColorL1: Colors.cyan
    property color thresholdColorL2: Colors.yellow
    property color thresholdColorL3: Colors.red

    implicitWidth: layout.implicitWidth
    implicitHeight: layout.implicitHeight

    RowLayout {
        id: layout

        spacing: Bar.resourceIconTextSpacing

        Item {
            Layout.fillWidth: true
        }

        Icon {
            text: root.icon
            color: root.value < root.thresholdL1 ? WallustColors.color15 : root.value >= root.thresholdL3 ? root.thresholdColorL3 : root.value >= root.thresholdL2 ? root.thresholdColorL2 : root.thresholdColorL1
        }
        IText {
            animate: true
            text: root.text
            color: root.value < root.thresholdL1 ? WallustColors.foreground : root.value >= root.thresholdL3 ? root.thresholdColorL3 : root.value >= root.thresholdL2 ? root.thresholdColorL2 : root.thresholdColorL1
        }

        Item {
            Layout.fillWidth: true
        }
    }
}
