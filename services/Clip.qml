pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property list<string> rawClipHist: []
    property list<string> clipImg: []
    property list<string> clipImgIds: clipImg.map(p => p.split("/").pop().split(".").shift())

    property string toDecode: ""
    property string toCopy: ""
    property string decoded: ""

    property var clipHist: {
        const arr = [];
        if (!rawClipHist?.length)
            return arr;

        const imgMap = {};
        const nimg = Math.min(clipImg.length, clipImgIds.length);
        for (let i = 0; i < nimg; i++) {
            const id = clipImgIds[i];
            if (id)
                imgMap[id] = clipImg[i];
        }

        for (let i = 0; i < rawClipHist.length; i++) {
            const raw = rawClipHist[i];
            if (!raw)
                continue;
            const tab = raw.indexOf("\t");
            let idNum = -1;
            let payload = raw;
            if (tab > 0) {
                const n = parseInt(raw.slice(0, tab), 10);
                if (!Number.isNaN(n)) {
                    idNum = n;
                    payload = raw.slice(tab + 1); // strip "ID<TAB>"
                }
            }

            const idStr = idNum >= 0 ? "" + idNum : "";
            const imgPath = idStr ? imgMap[idStr] || "" : "";
            const isImg = !!imgPath;

            arr.push({
                index: idNum,
                isImage: isImg,
                data: isImg ? imgPath : payload
            });
        }
        return arr;
    }

    component SClip_t: QtObject {
        property int index
        property bool isImage
        property string data
    }

    function decode(text) {
        toDecode = text;
        decodeProc.running = true;
    }

    function copy(text) {
        toCopy = text;
        copyProc.running = true;
    }

    Process {
        id: decodeProc
        running: false
        command: ["cliphist", "decode", toDecode]
        stdout: StdioCollector {
            onStreamFinished: () => {
                decoded = data;
            }
        }
        onStarted: {
            decoded = "";
        }
        onExited: {
            toDecode = "";
        }
    }

    Process {
        id: clipProc
        running: true
        command: ["cliphist", "-preview-width", 9 ** 9, "-max-items", 9 ** 9, "list"]
        property bool finished: false
        stdout: SplitParser {
            onRead: line => {
                if (clipProc.finished) {
                    rawClipHist = [];
                    clipProc.finished = false;
                }
                if (line)
                    rawClipHist.push(line);
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
            onRead: line => {
                if (line)
                    clipImg.push(line);
            }
        }
    }

    Process {
        id: copyProc
        running: false
        command: ["wl-copy", toCopy]
        onExited: {
            toCopy = "";
        }
    }
}
