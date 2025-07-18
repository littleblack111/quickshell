import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets

import qs.components
import qs.config

Rectangle {
    id: root

    property var toplevel: ToplevelManager.activeToplevel
    property var icon: Quickshell.iconPath(AppSearch.guessIcon(toplevel?.appId), "image-missing")
    // according to docs, null could happen but doesn't seem to happen in practice so..
    // hypr toplevel.activated is always true and doesn't change either so..
    property var activated: toplevel?.activated || false

    implicitWidth: activated ? loader.item.implicitWidth + General.rectMargin * 4 : 0
    implicitHeight: loader.item.implicitHeight + General.rectMargin * 2
    anchors.centerIn: parent

    color: WallustColors.color4
    opacity: activated ? 1 : 0
    radius: Style.rounding.smaller

    function strip(s) {
        var out = s;
        Bar.windowStrip.forEach(function (w) {
            out = out?.replace(new RegExp(w, "g"), "");
        });
        return out?.trim() || s;
    }

    Loader {
        id: loader
        active: activated
        anchors.centerIn: parent
        sourceComponent: rowComponent
    }

    Component {
        id: rowComponent
        RowLayout {
            spacing: Bar.resourceIconTextSpacing

            IconImage {
                id: icon
                source: root.icon
                implicitWidth: Bar.appIconSize
                implicitHeight: Bar.appIconSize
            }

            IText {
                animate: true
                font.pixelSize: General.fontSize
                text: strip(root?.toplevel?.title) || ""
            }
        }
    }

    onIconChanged: {
        if (loader.item) {
            loader.item.icon.opacity = 0;
            loader.item.icon.source = root.icon;
            loader.item.icon.opacity = 1;
        }
    }

    Behavior on opacity {
        NumberAnimation {
            duration: General.animateDuration / 4
        }
    }

    Behavior on implicitWidth {
        ISpringAnimation {
            spring: General.springAnimationSpring * 2
            damping: General.springAnimationDamping * 1.3
        }
    }
}
