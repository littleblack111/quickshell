import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets

import qs.components
import qs.services
import qs.config

Item {
    id: root
    
    // hyprland toplevel isn't shown immediately...
    property var toplevel: ToplevelManager.activeToplevel
    property var icon: Quickshell.iconPath(AppSearch.guessIcon(toplevel?.appId), "image-missing")

    property var activated: toplevel?.activated || false

    implicitWidth: loader.item ? loader.item.implicitWidth : 0
    implicitHeight: loader.item ? loader.item.implicitHeight : 0
    anchors.centerIn: parent

    function strip(s) {
        var out = s;
        Bar.windowStrip.forEach(function (w) {
            out = out?.replace(new RegExp(w, "g"), "");
        });
        return out?.trim() || s;
    }

    Behavior on width {
        ISpringAnimation {
            spring: General.springAnimationSpring * 2
            damping: General.springAnimationDamping * 1.3
        }
    }

    Loader {
        id: loader
        anchors.fill: parent
        active: root.activated || opacity > 0
        opacity: root.activated ? 1 : 0
        
        Behavior on opacity {
            NumberAnimation {
                duration: General.animationDuration / 4
            }
        }

        sourceComponent: Component {
            IRect {
                color: Qt.rgba(Colors.background3.r, Colors.background3.g, Colors.background3.b, Bar.bgTransparency)

                bottomLeftRadius: Bar.moduleRadius
                bottomRightRadius: Bar.moduleRadius
                
                implicitWidth: root.activated ? rowLayout.implicitWidth + General.rectMargin * 4 : 0
                implicitHeight: rowLayout.implicitHeight + General.rectMargin * 2 + Bar.topMargin * 2

                RowLayout {
                    id: rowLayout
                    anchors.centerIn: parent
                    spacing: Bar.resourceIconTextSpacing
                    width: Math.min(implicitWidth, root.width)

                    IconImage {
                        id: iconImage
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
                            width: Math.min(implicitWidth, rowLayout.width - iconImage.implicitWidth)
                            animate: true
                            clip: true
                            elide: Text.ElideRight
                            font.pixelSize: General.fontSize
                            text: root.strip(root?.toplevel?.title) || ""

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

                Connections {
                    target: root
                    function onIconChanged() {
                        fadeIcon.start()
                    }
                }

                SequentialAnimation {
                    id: fadeIcon
                    running: false

                    PropertyAnimation {
                        target: iconImage
                        property: "opacity"
                        to: 0
                        duration: General.animationDuration / 4
                    }
                    ScriptAction {
                        script: iconImage.source = root.icon
                    }
                    PropertyAnimation {
                        target: iconImage
                        property: "opacity"
                        to: 1
                        duration: General.animationDuration / 4
                    }
                    ScriptAction {
                        script: iconImage.source = root.icon
                    }
                }
            }
        }
    }
}
