import QtQuick
import QtQuick.Layouts

import qs.config

IText {
    id: root
    property real iconSize: General.iconSize
    property real fill: 0
    property real truncatedFill: Math.round(fill * 100) / 100 // Reduce memory consumption spikes from constant font remapping
    renderType: Text.NativeRendering
    color: Colors.foreground2
    font {
        // hintingPreference: Font.PreferFullHinting
        hintingPreference: Font.PreferNoHinting // so the icons dont just offset away
        family: Style.font.family.symbols ?? "Symbols Nerd Font"
        pixelSize: iconSize
        weight: Font.Normal + (Font.DemiBold - Font.Normal) * fill
        variableAxes: {
            "FILL": truncatedFill,
            // "wght": font.weight,
            // "GRAD": 0,
            "opsz": iconSize
        }
    }
    verticalAlignment: Text.AlignVCenter
    // color: Style.m3colors.m3onBackground

    // Behavior on fill {
    //     NumberAnimation {
    //         duration: Appearance?.animation.elementMoveFast.duration ?? 200
    //         easing.type: Appearance?.animation.elementMoveFast.type ?? Easing.BezierSpline
    //         easing.bezierCurve: Appearance?.animation.elementMoveFast.bezierCurve ?? [0.34, 0.80, 0.34, 1.00, 1, 1]
    //     }
    // }
}
