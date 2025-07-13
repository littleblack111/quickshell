import QtQuick.Layouts
import QtQuick
import Quickshell
import Quickshell.Services.Mpris
import qs.services as Services
import qs.config

// import Quickshell.Utils

Item {
    id: root
    readonly property MprisPlayer activePlayer: Services.Mpris.activePlayer
    readonly property string cleanedTitle: cleanMusicTitle(activePlayer?.trackTitle) || qsTr("No media")
    // length broken (https://github.com/quickshell-mirror/quickshell/issues/109)
    readonly property string position: friendlyTimeForSeconds(activePlayer?.position) || "0:00"
    readonly property string length: friendlyTimeForSeconds(activePlayer?.length) || "0:00"
    readonly property string progress: activePlayer.positionSupported && position != length ? position + "/" + length : activePlayer.positionSupported && !activePlayer.lengthSupported ? !activePlayer.positionSupported && activePlayer.lengthSupported ? "" : position : activePlayer.lengthSupported ? length : ""
    readonly property string state: activePlayer?.isPlaying ? Icons.media.pause : Icons.media.play

    function cleanMusicTitle(title: string): string {
        if (!title)
            return "";
        title = title.replace(/\s*\([^)]*\)/g, " "); // Round brackets
        title = title.replace(/\s*\[[^\]]*\]/g, " "); // Square brackets
        title = title.replace(/\s*\{[^\}]*\}/g, " "); // Curly brackets
        title = title.replace(/\s*【[^】]*】/g, " "); // Touhou
        title = title.replace(/\s*《[^》]*》/g, " ");
        title = title.replace(/\s*「[^」]*」/g, " ");
        title = title.replace(/\s*『[^』]*』/g, " ");

        return title.trim();
    }

    function friendlyTimeForSeconds(seconds) {
        if (isNaN(seconds) || seconds < 0)
            return "0:00";
        seconds = Math.floor(seconds);
        const h = Math.floor(seconds / 3600);
        const m = Math.floor((seconds % 3600) / 60);
        const s = seconds % 60;
        if (h > 0) {
            return `${h}:${m.toString().padStart(2, '0')}:${s.toString().padStart(2, '0')}`;
        } else {
            return `${m}:${s.toString().padStart(2, '0')}`;
        }
    }

    implicitWidth: rect.width - General.rectMargin / 2
    height: Bar.height + General.rectMargin / 2

    // TODO fancy animation progress bar etc.
    Rectangle {
        id: rect
        anchors.verticalCenter: parent.verticalCenter
        // TODO: move to IRect
        implicitWidth: text.width + General.rectMargin * 2
        height: parent.height - General.rectMargin
        color: Colors.alt
        radius: Style.rounding.smaller
        Text {
            id: text
            // TODO: use IText
            font.pixelSize: General.fontSize
            anchors.centerIn: parent
            anchors.verticalCenter: parent.verticalCenter
            text: root.state + " " + root.cleanedTitle + " [" + root.progress + "]"
        }
    }

    // hover
    // Text {
    //     text: root.activePlayer.trackTitle + " by " + root.activePlayer.trackArtist + " - " + root.activePlayer.trackAlbum + root.activePlayer.position + "/" + root.activePlayer.length
    // }
}
