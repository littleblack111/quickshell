import QtQuick
import Quickshell
import QtQuick.Layouts
import qs.config
import qs.components
import QtQuick.Controls

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

        spacing: 0

        Item {
            Layout.fillWidth: true
        }

        IRect {
            Layout.fillWidth: true
            Layout.fillHeight: true
            implicitWidth: m_icon.width + General.rectMargin * 2
            implicitHeight: Bar.height - General.rectMargin
            color: "transparent"
            Slider {
                id: pBar
                anchors.fill: parent
                handle: Item
                from: 0
                to: 100
                value: !root.isAlt ? root.value : root.altValue
                background: IRect {
                    anchors.fill: parent
                    color: "transparent"
                    // radius: Style.rounding.smaller
                }
                contentItem: Item {
                    IRect {
                        anchors.bottom: parent.bottom
                        width: parent.width
                        height: parent.height * pBar.visualPosition
                        color: Qt.rgba(Colors.accentAlt.r, Colors.accentAlt.g, Colors.accentAlt.b, General.accentTransparency * 1.5)
                        radius: Style.rounding.smaller

                        Behavior on width {
                            NumberAnimation {
                                duration: General.animationDuration / 2
                            }
                        }
                    }
                }
            }
            Icon {
                id: m_icon
                anchors {
                    centerIn: parent
                }
                iconSize: Style.font.size.small
                text: !root.isAlt ? root.icon : root.altIcon
                color: root.value < root.thresholdL1 ? Colors.foreground2 : root.value >= root.thresholdL3 ? root.thresholdColorL3 : root.value >= root.thresholdL2 ? root.thresholdColorL2 : root.thresholdColorL1
            }
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
