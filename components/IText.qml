pragma ComponentBehavior: Bound

import QtQuick

import qs.config

Text {
    id: root

    property bool animate: false
    property real animateFrom: 0
    property real animateTo: 1

    // renderType: Text.NativeRendering
    textFormat: Text.PlainText
    elide: Text.ElideRight
    color: Colors.foreground1

    font {
        family: Style.font.family.iosevka
        // pointSize: root.pixelSize
        pixelSize: Style.font.size.larger
    }

    Behavior on color {
        ColorAnimation {
            duration: Style.anim.durations.normal
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Style.anim.curves.standard
        }
    }

    Behavior on text {
        enabled: root.animate

        SequentialAnimation {
            Anim {
                to: root.animateFrom
                easing.bezierCurve: Style.anim.curves.standardAccel
            }
            PropertyAction {}
            Anim {
                to: root.animateTo
                easing.bezierCurve: Style.anim.curves.standardDecel
            }
        }
    }

    component Anim: NumberAnimation {
        target: root
        property: General.animationProp
        duration: General.animationDuration / 4
        easing.type: Easing.BezierSpline
    }
}
