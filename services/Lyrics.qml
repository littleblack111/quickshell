pragma Singleton
import QtQuick
import Quickshell.Io
import Quickshell

Singleton {
    property var lyrics: []
    property string currentTrack: ""

    Process {
        command: ["python3", "/home/system/lyric_stream.py"]
        stdout: SplitParser {
            splitMarker: "\n"
            onRead: function (chunk) {
                var text = String(chunk).trim();
                if (!text)
                    return;
                var obj;
                try {
                    obj = JSON.parse(text);
                } catch (e) {
                    console.log("JSON parse error", e, text);
                    return;
                }
                if (obj.event === "track_change") {
                    lyrics = [];
                    currentTrack = obj.track;
                } else if (obj.event === "full_lyrics" && obj.track === currentTrack) {
                    lyrics = obj.lyrics;
                }
            }
        }
        running: true
    }

    function get_lyrics() {
        return lyrics;
    }
}
