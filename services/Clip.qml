pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root
    property list<SClip_t> clipHist
    property list<string> rawClipHist
    property list<string> clipImg
    property list<string> clipImgIds: clipImg.map(img => img.split('/').pop().split('.').shift()) // used as index for clipImg
    property string toDecode: undefined
    property string decoded: undefined

    component SClip_t: QtObject {
        property int index
        property bool isImage
        property string data
    }

    Process {
        id: decodeProc
        running: false
        command: ["cliphist", "decode", toDecode]
        stdout: StdioCollector {
            onStreamFinished: () => {
                decoded = data;
                toDecode = undefined;
            }
        }
    }

    Process {
        id: clipProc
        running: true
        command: ["cliphist", "-preview-width", 9 ** 9, "-max-items", 9 ** 9, "list"]
        property bool finished: false
        stdout: SplitParser {
            onRead: data => {
                if (finished) {
                    rawClipHist = [];
                    finished = false;
                }
                rawClipHist.push(data);
            }
        }
        onExited: {
            finished = true;
        }
    }

    Process {
        id: imgProc
        running: true
        command: ["sh", Quickshell.shellDir + "/utils/cliphist-img.sh"]
        stdout: SplitParser {
            onRead: data => {
                clipImg.push(data);
            }
        }
    }
}
