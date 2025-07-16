import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Mpris
import qs.services as Services
import qs.config
import qs.components

Item {
    id: root
    readonly property MprisPlayer activePlayer: Services.Mpris.activePlayer
    readonly property string cleanedTitle: cleanMusicTitle(activePlayer?.trackTitle)

    function cleanMusicTitle(title) {
        if (!title)
            return "";
        title = title.replace(/\s*\([^)]*\)/g, " ");
        title = title.replace(/\s*\[[^\]]*\]/g, " ");
        title = title.replace(/\s*\{[^\}]*\}/g, " ");
        title = title.replace(/\s*【[^】]*】/g, " ");
        title = title.replace(/\s*《[^》]*》/g, " ");
        title = title.replace(/\s*「[^」]*」/g, " ");
        title = title.replace(/\s*『[^』]*』/g, " ");
        return title.trim();
    }

    implicitWidth: activePlayer ? rect.implicitWidth - General.rectMargin / 1.2 : 0
    height: Bar.height + General.rectMargin / 1.5
    opacity: activePlayer ? 1 : 0

    Rectangle {
        id: rect
        anchors.verticalCenter: parent.verticalCenter
        implicitWidth: layout.width + General.rectMargin * 4
        height: parent.height - General.rectMargin
        radius: Style.rounding.smaller
        color: "transparent"

        Slider {
            id: pBar
            anchors.fill: parent

            handle: Item
            from: 0
            to: activePlayer?.length || 0
            value: activePlayer?.position || 0
            background: Rectangle {
                anchors.fill: parent
                color: WallustColors.color4
                radius: Style.rounding.smaller
            }
            contentItem: Item {
                Rectangle {
                    width: pBar.visualPosition * parent.width
                    height: parent.height
                    color: WallustColors.color12
                    radius: Style.rounding.smaller

                    Behavior on width {
                        NumberAnimation {
                            duration: General.animateDuration / 2
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
                width: Bar.appIconSize
                height: Bar.appIconSize

                opacity: activePlayer?.playbackState === MprisPlaybackState.Playing ? 1 : Bar.mediaPausedOpacity

                // put shadow
                Image {
                    id: image
                    anchors.fill: parent

                    source: activePlayer?.trackArtUrl
                    fillMode: Image.PreserveAspectFit
                    antialiasing: true
                    asynchronous: true
                    visible: false
                    cache: false
                }
                Rectangle {
                    id: mask
                    anchors.fill: parent
                    radius: 6
                    visible: false
                }
                OpacityMask {
                    anchors.fill: parent
                    source: image
                    maskSource: mask
                }

                Behavior on opacity {
                    NumberAnimation {
                        duration: General.animateDuration / 4
                        easing.type: Easing.InOutQuad
                    }
                }
            }
            IText {
                animate: true
                opacity: activePlayer?.playbackState === MprisPlaybackState.Playing ? 1 : Bar.mediaPausedOpacity
                color: activePlayer?.playbackState === MprisPlaybackState.Playing ? WallustColors.foreground : WallustColors.color15
                text: root.cleanedTitle

                Behavior on opacity {
                    NumberAnimation {
                        duration: General.animateDuration / 4
                        easing.type: Easing.InOutQuad
                    }
                }

                Behavior on color {
                    ColorAnimation {
                        duration: General.animateDuration / 4
                        easing.type: Easing.InOutQuad
                    }
                }
            }
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
