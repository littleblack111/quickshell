import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets

import qs.components
import qs.services
import qs.config

// TODO use a item wrapping loader for opacity Behavior
IRect {
    id: root
    // hyprland toplevel isn't shown immediately...
    property var toplevel: ToplevelManager.activeToplevel
    property var icon: Quickshell.iconPath(AppSearch.guessIcon(toplevel?.appId), "image-missing")

    property var activated: toplevel?.activated || false

    implicitWidth: activated ? rowLayout.implicitWidth + General.rectMargin * 4 : 0
    implicitHeight: rowLayout.implicitHeight + General.rectMargin * 2
    anchors.centerIn: parent

    color: Qt.rgba(Colors.background3.r, Colors.background3.g, Colors.background3.b, Bar.bgTransparency)
    // according to docs, null could happen but doesn't seem to happen in practice so..
    // hypr toplevel.activated is always true and doesn't change either so..
    opacity: activated ? 1 : 0

    radius: Style.rounding.smaller

    function strip(s) {
        var out = s;
        Bar.windowStrip.forEach(function (w) {
            out = out?.replace(new RegExp(w, "g"), "");
        });
        return out?.trim() || s;
    }

    RowLayout {
        id: rowLayout
        anchors.centerIn: parent
        spacing: Bar.resourceIconTextSpacing
        width: Math.min(implicitWidth, root.width)

        IconImage {
            id: icon
            source: root.icon
            implicitSize: General.appIconSize

            // sync animation
            opacity: root.activated ? 1 : 0
            Behavior on opacity {
                NumberAnimation {
                    duration: General.animationDuration / 4
                }
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            implicitWidth: childrenRect.width
            IText {
                anchors.verticalCenter: parent.verticalCenter
                width: Math.min(implicitWidth, rowLayout.width - icon.implicitWidth)
                animate: true
                clip: true
                elide: Text.ElideRight
                font.pixelSize: General.fontSize
                text: strip(root?.toplevel?.title) || ""

                // sync animation
                opacity: root.activated ? 1 : 0
                Behavior on opacity {
                    NumberAnimation {
                        duration: General.animationDuration / 4
                    }
                }
            }
        }
    }

    onIconChanged: fadeIcon.start()

    Behavior on opacity {
        NumberAnimation {
            duration: General.animationDuration / 4
        }
    }

    Behavior on width {
        ISpringAnimation {
            spring: General.springAnimationSpring * 2
            damping: General.springAnimationDamping * 1.3
        }
    }

    SequentialAnimation {
        id: fadeIcon
        running: false

        PropertyAnimation {
            target: icon
            property: "opacity"
            to: 0
            duration: General.animationDuration / 4
        }
        ScriptAction {
            script: icon.source = root.icon
        }
        PropertyAnimation {
            target: icon
            property: "opacity"
            to: 1
            duration: General.animationDuration / 4
        }
        ScriptAction {
            script: icon.source = root.icon
        }
    }
}
