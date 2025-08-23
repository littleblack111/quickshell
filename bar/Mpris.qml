import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects
import Qt5Compat.GraphicalEffects
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Mpris
import qs.services as Services

import qs.config
import qs.components
import "../utils/string_utils.js" as StringUtils

Item {
    id: root
    readonly property MprisPlayer activePlayer: Services.Mpris.activePlayer
    readonly property string cleanedTitle: StringUtils.cleanMusicTitle(activePlayer?.trackTitle)

    implicitWidth: activePlayer ? rect.width - General.rectMargin / 1.2 : 0
    height: Bar.height + General.rectMargin / 1.5
    opacity: activePlayer ? 1 : 0

    IRect {
        id: rect
        anchors.verticalCenter: parent.verticalCenter
        implicitWidth: layout.width + General.rectMargin * 4
        height: parent.height - General.rectMargin
        radius: Style.rounding.smaller
        color: "transparent"

        // FIXME: at the start, the progress bar's radius will make it go out of bounds. use OpacityMask or something
        Slider {
            id: pBar
            anchors.fill: parent

            handle: Item
            from: 0
            to: activePlayer?.length || 0
            value: activePlayer?.position || 0
            background: IRect {
                anchors.fill: parent
                color: Colors.accent
                radius: Style.rounding.smaller
            }
            contentItem: Item {
                IRect {
                    width: pBar.visualPosition * parent.width
                    height: parent.height
                    color: Qt.rgba(Colors.accentAlt.r, Colors.accentAlt.g, Colors.accentAlt.b, General.accentTransparency * 1.5)
                    radius: Style.rounding.smaller

                    Behavior on width {
                        NumberAnimation {
                            duration: General.animationDuration / 2
                        }
                    }
                }
            }

            // onMoved: {
            //     if (Math.round(root.activePlayer.position) !== Math.round(value)) {
            //         root.activePlayer.position = value;
            //     }
            // }

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.MiddleButton | Qt.RightButton | Qt.LeftButton
                cursorShape: Qt.PointingHandCursor
                onClicked: mouse => {
                    if (mouse.button === Qt.MiddleButton)
                        root.activePlayer?.togglePlaying();
                    else if (mouse.button === Qt.RightButton)
                        root.activePlayer?.next();
                }
                onWheel: mouse => {
                    root.activePlayer?.seek(-mouse.angleDelta.y * Bar.mediaScrollScale);
                }
            }
        }

        RowLayout {
            id: layout
            anchors.centerIn: parent
            spacing: Bar.resourceIconTextSpacing / 1.5
            Item {
                Layout.preferredWidth: childrenRect.width
                Layout.preferredHeight: childrenRect.height
                width: General.appIconSize
                height: General.appIconSize

                opacity: activePlayer?.playbackState === MprisPlaybackState.Playing ? 1 : Bar.mediaPausedOpacity

                DropShadow {
                    anchors.fill: image
                    source: image
                    opacity: activePlayer?.playbackState === MprisPlaybackState.Playing ? 1 : Bar.mediaPausedOpacity
                    radius: 6
                    color: Colors.background3

                    Behavior on opacity {
                        NumberAnimation {
                            duration: General.animationDuration / 4
                            easing.type: Easing.InOutQuad
                        }
                    }
                }

                ClippingWrapperRectangle {
                    id: image
                    anchors.fill: parent
                    radius: 6
                    color: "transparent"
                    child: Image {
                        id: albumArt
                        // IconImage makes it less crisp and blurry
                        anchors.fill: parent
                        source: activePlayer?.trackArtUrl || Quickshell.iconPath(AppSearch.guessIcon(activePlayer?.desktopEntry), "image-missing")
                        antialiasing: true
                        asynchronous: true
                        ColorOverlay {
                            property color rawColor: activePlayer?.playbackState === MprisPlaybackState.Playing ? Colors.background1 : Colors.background2
                            anchors.fill: albumArt
                            source: albumArt
                            color: Qt.rgba(rawColor.r, rawColor.g, rawColor.b, General.accentTransparency)

                            Behavior on color {
                                ColorAnimation {
                                    duration: General.animationDuration / 4
                                    easing.type: Easing.InOutQuad
                                }
                            }
                        }
                    }
                }

                Behavior on opacity {
                    NumberAnimation {
                        duration: General.animationDuration / 4
                        easing.type: Easing.InOutQuad
                    }
                }
            }
            IText {
                animate: true
                color: activePlayer?.playbackState === MprisPlaybackState.Playing ? Qt.rgba(Colors.foreground1.r, Colors.foreground1.g, Colors.foreground1.b, Colors.foreground1.a) : Qt.rgba(Colors.foreground2.r, Colors.foreground2.g, Colors.foreground2.b, Bar.mediaPausedOpacity)
                text: root.cleanedTitle

                Behavior on opacity {
                    NumberAnimation {
                        duration: General.animationDuration / 4
                        easing.type: Easing.InOutQuad
                    }
                }

                Behavior on color {
                    ColorAnimation {
                        duration: General.animationDuration / 4
                        easing.type: Easing.InOutQuad
                    }
                }
            }
        }
    }

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
}
