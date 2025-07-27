import QtQuick
import Quickshell
import QtQuick.Layouts
import qs.config
import qs.components

Item {
    id: root

    // TODO: use https://quickshell.org/docs/master/types/Quickshell/PopupWindow/ for tooltip

    required property real value
    required property string suffix // unit
    required property string icon
    property string altValue: value
    property string altSuffix: suffix
    property string altIcon: icon
    property string text: root.value + root.suffix
    property string altText: root.altValue + root.altSuffix
    property real thresholdL1: 40
    property real thresholdL2: thresholdL1 * 1.5
    property real thresholdL3: thresholdL2 * 1.5
    property color thresholdColorL1: Colors.cyan
    property color thresholdColorL2: Colors.yellow
    property color thresholdColorL3: Colors.red

    property bool isAlt: false

    implicitWidth: layout.implicitWidth
    implicitHeight: layout.implicitHeight

    RowLayout {
        id: layout

        spacing: Bar.resourceIconTextSpacing

        Item {
            Layout.fillWidth: true
        }

        Icon {
            text: !root.isAlt ? root.icon : root.altIcon
            color: root.value < root.thresholdL1 ? Colors.foreground2 : root.value >= root.thresholdL3 ? root.thresholdColorL3 : root.value >= root.thresholdL2 ? root.thresholdColorL2 : root.thresholdColorL1
        }
        IText {
            animate: true
            text: !root.isAlt ? root.text : root.altText
            color: root.value < root.thresholdL1 ? Colors.foreground1 : root.value >= root.thresholdL3 ? root.thresholdColorL3 : root.value >= root.thresholdL2 ? root.thresholdColorL2 : root.thresholdColorL1
        }

        Item {
            Layout.fillWidth: true
        }
    }
    MouseArea {
        anchors.fill: parent
        cursorShape: altValue != value ? Qt.PointingHandCursor : Qt.ArrowCursor
        onPressed: {
            root.isAlt = !root.isAlt;
        }
    }
}
