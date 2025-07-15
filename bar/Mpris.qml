import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Mpris
import qs.services as Services
import qs.config
import qs.components

Item {
    id: root
    readonly property MprisPlayer activePlayer: Services.Mpris.activePlayer
    readonly property real progress: (activePlayer?.positionSupported && activePlayer?.lengthSupported && activePlayer?.length > 0) ? activePlayer?.position / activePlayer?.length : 0
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

    implicitWidth: activePlayer ? rect.width - General.rectMargin / 1.25 : 0
    height: Bar.height + General.rectMargin / 1.5
    opacity: activePlayer ? 1 : 0

    Rectangle {
        id: rect
        anchors.verticalCenter: parent.verticalCenter
        implicitWidth: layout.width + General.rectMargin * 4
        height: parent.height - General.rectMargin
        color: Colors.alt
        radius: Style.rounding.smaller

        RowLayout {
            id: layout
            anchors.centerIn: parent
            spacing: Bar.resourceIconTextSpacing / 1.5
            Image {
                source: activePlayer.trackArtUrl
                fillMode: Image.PreserveAspectFit
                Layout.preferredWidth: Bar.appIconSize
                cache: true
            }
            IText {
                animate: true
                text: root.cleanedTitle
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
