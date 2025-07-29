pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root
    property list<string> clipHist: []
    property list<string> clipImg: []
    property list<string> clipImgIds: clipImg.map(img => img.split('/').pop().split('.').shift()) // used as index for clipImg
    property string toDecode: undefined

    Process {
        id: decodeProc
        property bool finished: false
        running: false
        command: ["cliphist", "decode", toDecode]
        stdout: StdioCollector {
            onStreamFinished: () => {
                decodeProc.finished = true;
            }
        }
    }

    Process {
        id: cacheClipProc
        running: true
        command: ["cliphist", "-preview-width", 9 ** 9, "-max-items", 9 ** 9, "list"]
        stdout: SplitParser {
            onRead: data => {
                clipHist.push(data);
            }
        }
    }

    Process {
        id: cacheImgProc
        running: true
        command: ["sh", Quickshell.shellDir + "/utils/cliphist-img.sh"]
        stdout: SplitParser {
            onRead: data => {
                clipImg.push(data);
            }
        }
    }
}
