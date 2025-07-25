import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

import qs.config

Item {
    id: root

    required property string iconName
    required property double percentage
    property bool shown: true
    clip: true
    visible: width > 0 && height > 0
    implicitWidth: resourceRowLayout.x < 0 ? 0 : childrenRect.width
    implicitHeight: childrenRect.height

    RowLayout {
        id: resourceRowLayout
        spacing: 4
        x: root.shown ? 0 : -resourceRowLayout.width

        CircularProgress {
            Layout.alignment: Qt.AlignVCenter
            lineWidth: 2
            value: root.percentage
            size: 26
            // secondaryColor: Appearance.colors.colSecondaryContainer
            // primaryColor: Appearance.m3colors.m3onSecondaryContainer

            MaterialSymbol {
                anchors.centerIn: parent
                fill: 1
                text: iconName
                // iconSize: Appearance.font.pixelSize.normal
                // color: Appearance.m3colors.m3onSecondaryContainer
            }
        }

        Text {
            Layout.alignment: Qt.AlignVCenter
            // color: Appearance.colors.colOnLayer1
            text: `${Math.round(percentage * 100)}`
        }

        Behavior on x {
            animation: Appearance.animation.elementMove.numberAnimation.createObject(this)
        }
    }

    Behavior on implicitWidth {
        NumberAnimation {
            duration: Appearance.animation.elementMove.duration
            easing.type: Appearance.animation.elementMove.type
            easing.bezierCurve: Appearance.animation.elementMove.bezierCurve
        }
    }
}
