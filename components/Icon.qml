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
}
